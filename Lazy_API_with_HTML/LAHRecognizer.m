//
//  LAHRecognizer.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHRecognizer.h"
#import "LAHConstruct.h"
#import "LAHFetcher.h"
#import "LAHDownloader.h"
#import "LAHProtocols.h"

@implementation LAHRecognizer
@synthesize tagName = _tagName, text = _text, attributes = _attributes, isTextNode = _isTextNode, rule = _rule;
@synthesize range = _range;
@synthesize isIndex = _isIndex, numberOfMatched = _numberOfMatched;
@synthesize fetchers = _fetchers, downloaders = _downloaders;

#pragma mark - Life Cycle
- (id)init{
    self = [super init];
    if (self) {
        self.isTextNode = NO;
        self.isIndex = NO;
        self.range = NSMakeRange(0, NSUIntegerMax);
        _states = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)initWithFirstFetcher:(LAHFetcher *)firstFetcher variadicFetchers:(va_list)fetchers{
    self = [self init];
    if (self) {
        NSMutableArray *collector = [[NSMutableArray alloc] initWithObjects:firstFetcher, nil];
        LAHFetcher *fetcher;
        while ((fetcher = va_arg(fetchers, LAHFetcher*)) != nil) {
            [collector addObject:fetcher];
        }
        _fetchers = [[NSArray alloc] initWithArray:collector];
        [collector release];
    }
    return self;
}

- (id)initWithFetchers:(LAHFetcher *)firstFetcher, ... NS_REQUIRES_NIL_TERMINATION{
    va_list fetchers; va_start(fetchers, firstFetcher);
    self = [self initWithFirstFetcher:firstFetcher variadicFetchers:fetchers];
    va_end(fetchers);
    return self;
}

- (id)initWithFirstChild:(LAHNode*)firstChild variadicChildren:(va_list)children{
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        self.isTextNode = NO;
        self.range = NSMakeRange(0, NSUIntegerMax);
        _states = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc{
    [_tagName release]; _tagName = nil;
    [_text release]; _text = nil;
    [_attributes release]; _attributes = nil;

    [_states release]; _states = nil;
    
    [_fetchers release]; _fetchers = nil;
    [_downloaders release]; _downloaders = nil;
    
    [super dealloc];
}

#pragma mark - Setter
- (void)setIndex:(NSUInteger)index{
    _range = NSMakeRange(index, 1);
}

- (void)setDownloaders:(NSArray *)downloaders{
    [_downloaders release];
    _downloaders = [downloaders retain];
    
    for (LAHDownloader *d in _downloaders) {
        d.father = self;
    }
}

#pragma mark - Getter
- (NSUInteger)numberInRange{
    NSRange wR = NSMakeRange(0, _numberOfMatched);  //whole range
    NSRange iR = NSIntersectionRange(wR, _range);   //intersection range
    return iR.length;
}

#pragma mark - Recursive
- (BOOL)handleElement:(id<LAHHTMLElement>)element{
    //Step 0, check matching.

    if (![self isElementMatched:element]) return NO;
    DLogElement(element);

    //Step 1, fetch linked properties.
    for (LAHFetcher *f in _fetchers) {
        [f fetchProperty:element];
    }
    
    for (LAHRecognizer *node in _children) {
        if (_isIndex) [node refreshState];
        for (id<LAHHTMLElement> e in element.children) {
            //if ([node handleElement:e]) node.indexOfElements ++;
            [node handleElement:e];
        }
    }

    //Step 3, download with the property.
    for (LAHDownloader *d in _downloaders) {
        [d download:element];
    }
    
    return YES;
}

- (BOOL)isElementMatched:(id<LAHHTMLElement>)element{
    if (_tagName != nil) {
        NSString *tagName = element.tagName;
        if (![_tagName isEqualToString:tagName]) return NO;
    }
    if (_text != nil) {
        if (![_text isEqualToString:element.text]) return NO;
    }
    if (_attributes != nil) {
        if (element.attributes == nil) return NO;
        for (NSString *key in _attributes.allKeys) {
            NSString *rAV = [_attributes valueForKey:key];   //recognizer attribute value
            NSString *eAV = [element.attributes valueForKey:key];   //element attribute value
            if (eAV == nil || ![rAV isEqualToString:eAV]) return NO;
        }
    }
    if (_isTextNode != element.isTextNode) {
        return NO;
    }
    if (_rule != nil) {
        if (!_rule(element)) return NO;
    }

    //range indicates range of elements matched by above rules,
    //so before using it, _numberOfMatched should increase.
    _numberOfMatched ++;
    if (!NSLocationInRange(_numberOfMatched - 1, _range)) return NO;
    
    return YES;
}

- (LAHOperation*)recursiveOperation{
    LAHRecognizer *father = (LAHRecognizer *)_father;
    return father.recursiveOperation;
}

#pragma mark - State
- (void)saveStateForKey:(id)key{
    NSNumber *count = [[NSNumber alloc] initWithUnsignedInteger:_numberOfMatched];
    [_states setObject:count forKey:key]; 
    [count release];
}

- (void)restoreStateForKey:(id)key{
    NSNumber *count = [_states objectForKey:key];
    _numberOfMatched = [count unsignedIntegerValue];
    [_states removeObjectForKey:key];
}

- (void)refreshState{
    _numberOfMatched = 0;
    for (LAHRecognizer *r in _children) {
        [r refreshState];
    }
}

@end