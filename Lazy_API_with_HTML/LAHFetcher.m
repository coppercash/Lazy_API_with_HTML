//
//  LAHFetcher.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHFetcher.h"

@interface LAHFetcher ()
@property(nonatomic, copy)NSString *property;
@end

@implementation LAHFetcher
@synthesize fetcher = _fetcher, property = _property;
#pragma mark - Life Cycle
- (id)initWithKey:(NSString*)key fetcher:(LAHPropertyFetcher)fetcher{
    self = [super init];
    if (self) {
        self.type = LAHConstructTypeFetcher;
        self.key = key;
        self.fetcher = fetcher;
    }
    return self;
}

- (id)initWithFetcher:(LAHPropertyFetcher)property{
    self = [super init];
    if (self) {
        self.type = LAHConstructTypeFetcher;
        self.fetcher = property;
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
    copy.indexSource = self.indexSource;
    
    copy.fetcher = self.fetcher;
    
    return copy;
}

#pragma mark - Element
- (void)fetchProperty:(id<LAHHTMLElement>)element{
    self.property = _fetcher(element);
    
    if (_property == nil) return;
    LAHConstruct *father = (LAHConstruct *)_father;
    [father recieveObject:self];
}

- (id)newValue{
    _count ++;
    if (_property == nil) return [NSNull null];
    return _property;
}

@end

