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
@dynamic tagName, text;
@synthesize attributes = _attributes, isTextNode = _isTextNode, rule = _rule;
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
        [self.fetchers = [[NSArray alloc] initWithArray:collector] release];
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
    //[_tagName release]; _tagName = nil;
    //[_text release]; _text = nil;
    [_attributes release]; _attributes = nil;

    [_states release]; _states = nil;
    
    [_fetchers release]; _fetchers = nil;
    [_downloaders release]; _downloaders = nil;
    
    [super dealloc];
}

#pragma mark - Setter
- (void)setTagName:(NSString *)tagName{
    NSSet *tagNames = [[NSSet alloc] initWithObjects:tagName, nil];
    if (_attributes) {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:_attributes];
        [temp setObject:tagNames forKey:gRWTagName];
        
        NSDictionary *newAttr = [[NSDictionary alloc] initWithDictionary:temp];

        self.attributes = newAttr;
        [temp release]; [newAttr release];
    }else{
        NSDictionary *newAttr = [[NSDictionary alloc] initWithObjectsAndKeys:tagNames, gRWTagName, nil];
        
        self.attributes = newAttr;
        [newAttr release];
    }
    [tagNames release];
}

- (void)setText:(NSString *)text{
    NSSet *texts = [[NSSet alloc] initWithObjects:text, nil];
    if (_attributes) {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:_attributes];
        [temp setObject:texts forKey:gRWText];
        
        NSDictionary *newAttr = [[NSDictionary alloc] initWithDictionary:temp];
        
        self.attributes = newAttr;
        [temp release]; [newAttr release];
    }else{
        NSDictionary *newAttr = [[NSDictionary alloc] initWithObjectsAndKeys:texts, gRWText, nil];
        
        self.attributes = newAttr;
        [newAttr release];
    }
    [texts release];
}

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

#pragma mark - Attributes
- (void)setKey:(NSString *)key firstValue:(NSString *)firstValue variadicValues:(va_list)values{
    NSMutableArray *collector = [[NSMutableArray alloc] initWithObjects:firstValue, nil];
    NSString *value = nil;
    while ((value = va_arg(values, NSString*)) != nil) {
        [collector addObject:value];
    }
    NSSet *set = [[NSSet alloc] initWithArray:collector];
    
    if (_attributes) {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:_attributes];
        [temp setObject:set forKey:key];
        
        NSDictionary *newAttr = [[NSDictionary alloc] initWithDictionary:temp];
        
        self.attributes = newAttr;
        [temp release]; [newAttr release];
    }else{
        NSDictionary *newAttr = [[NSDictionary alloc] initWithObjectsAndKeys:set, key, nil];
        self.attributes = newAttr;
        [newAttr release];
    }
    
    [collector release];
}

- (void)setKey:(NSString *)key attributes:(NSString *)firstValue, ... NS_REQUIRES_NIL_TERMINATION{
    va_list values; va_start(values, firstValue);
    [self setKey:key firstValue:firstValue variadicValues:values];
    va_end(values);
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
    
    //Step 2, recursion
    //Two iteration in this order, so that the fetcher's fetching sequence depends on the sequence in the HTML.
    for (id<LAHHTMLElement> e in element.children) {
        for (LAHRecognizer *node in _children) {
            if (_isIndex) [node refreshState];
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
    for (NSString *key in _attributes) {
        NSSet *lVs = [_attributes objectForKey:key];    //legal values
        NSAssert([lVs isKindOfClass:[NSSet class]], @"LAHRecognizer: legal values should be a NSSet.");

        NSString *value = nil;
        if ([key isEqualToString:gRWTagName]) {
            value = element.tagName;
        }else if ([key isEqualToString:gRWText]){
            value = element.text;
        }else{
            value = [element.attributes objectForKey:key];
        }
        
        BOOL isMatched = NO;
        
        if (value) {
            for (NSString *lV in lVs) {
                if ([lV isEqualToString:gRWNotNone]) {
                    isMatched = YES;
                    break;
                }
                isMatched |= [lV isEqualToString:value];
            }
        }else {
            for (NSString *lV in lVs)
                isMatched |= [lV isEqualToString:gRWNone];
        }
        if (!isMatched) return NO;
        
        //Statement below has same logic with the above one.But in each step of loop, it do [value isEqualToString:gRWNone].So its performance is worse.
        /*
        value = value ? value : gRWNone;
        for (NSString *lV in lVs) {
            if ([lV isEqualToString:gRWNotNone] && ![value isEqualToString:gRWNone]) {
                isMatched = YES;
                break;
            }
            isMatched |= [lV isEqualToString:value];
        }*/
        
        if (!isMatched) return NO;
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
/*
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
}*/

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

NSString * const gRWNone = @"_none";
NSString * const gRWNotNone = @"_notNone";
NSString * const gRWTagName = @"_tag";
NSString * const gRWText = @"_text";