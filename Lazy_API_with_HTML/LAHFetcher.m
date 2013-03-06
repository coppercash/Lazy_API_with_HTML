//
//  LAHFetcher.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHFetcher.h"
#import "LAHRecognizer.h"

@interface LAHFetcher ()
@property(nonatomic, copy)NSString *property;
@end

@implementation LAHFetcher
@synthesize fetcher = _fetcher, property = _property, symbol = _symbol;
#pragma mark - Life Cycle

- (id)init{
    self = [super init];
    if (self) {
        self.type = LAHConstructTypeFetcher;
    }
    return self;
}

- (id)initWithFetcher:(LAHPropertyFetcher)property{
    self = [self init];
    if (self) {
        self.fetcher = property;
    }
    return self;
}

- (id)initWithSymbol:(NSString *)symbol{
    self = [super init];
    if (self) {
        self.symbol = symbol;
    }
    return self;
}

- (void)dealloc{
    self.fetcher = nil;
    self.property = nil;
    
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    LAHFetcher *copy = [[[self class] allocWithZone:zone] init];
    
    copy.father = self.father;
    copy.children = self.children;
    
    copy.type = self.type;
    copy.key = self.key;
    copy.indexes = self.indexes;
    copy.fetcher = self.fetcher;
    
    return copy;
}

#pragma mark - Element
- (void)fetchProperty:(id<LAHHTMLElement>)element{
    if (_fetcher) {
        self.property = _fetcher(element);
    }else if (_symbol){
        if ([_symbol isEqualToString:gRWTagName])  self.property = element.tagName;
        else if ([_symbol isEqualToString:gRWText]) self.property = element.text;
        else self.property = [element.attributes objectForKey:_symbol];
    }else{
        return;
    }

    //self.property = _fetcher(element);
    
    if (_property == nil) return;
    LAHConstruct *father = (LAHConstruct *)_father;
    [father recieveObject:self];
}

- (id)newValue{
    if (_property == nil) return [NSNull null];
    return _property;
}

@end

