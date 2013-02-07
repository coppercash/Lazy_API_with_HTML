//
//  LAHFetcher.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHFetcher.h"
#import "LAHGreffier.h"

@implementation LAHFetcher
@synthesize key = _key, propertyGetter = _propertyGetter;
@synthesize greffier = _greffier;
#pragma mark - Life Cycle
- (id)initWithKey:(NSString*)key propertyGetter:(LAHPropertyGetter)propertyGetter{
    self = [super init];
    if (self) {
        self.key = key;
        self.propertyGetter = propertyGetter;
    }
    return self;
}

- (id)initWithKey:(NSString*)key propertyGetter:(LAHPropertyGetter)propertyGetter firstChild:(LAHNode*)firstChild variadicChildren:(va_list)children {
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        self.key = key;
        self.propertyGetter = propertyGetter;
    }
    return self;
}

- (id)initWithKey:(NSString*)key propertyGetter:(LAHPropertyGetter)propertyGetter children:(LAHNode*)firstChild, ... NS_REQUIRES_NIL_TERMINATION {
    va_list children;
    va_start(children, firstChild);
    
    self = [self initWithKey:key propertyGetter:propertyGetter firstChild:firstChild variadicChildren:children];
    
    va_end(children);
    return self;
}

- (void)dealloc{
    [_key release]; _key = nil;
    [_propertyGetter release]; _propertyGetter = nil;
    
    [super dealloc];
}

#pragma mark - Element
- (void)handleElement:(id<LAHHTMLElement>)element atIndex:(NSUInteger)index{
    if (![self isElementMatched:element atIndex:index]) return;
    DLogElement(element)
    DLogFetcher(self)
    if (_propertyGetter == nil) return;
    NSString *info = _propertyGetter(element);
    
    id container = self.recursiveContainer;
    if (_key != nil && [container isKindOfClass:[NSMutableDictionary class]]) {
        [(NSMutableDictionary*)container setObject:info forKey:_key];
    }else if ([container isKindOfClass:[NSMutableArray class]]) {
        [(NSMutableArray*)container addObject:info];
    }
    
    [super handleElement:element atIndex:index];
}

@end