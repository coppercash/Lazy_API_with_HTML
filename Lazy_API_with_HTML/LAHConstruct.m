//
//  LAHConstruct.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHConstruct.h"
#import "LAHRecognizer.h"
#import "LAHOperation.h"

@implementation LAHConstruct
@synthesize type = _type, key = _key, indexes = _indexes;

- (id)initWithKey:(NSString *)key children:(LAHNode *)firstChild, ... NS_REQUIRES_NIL_TERMINATION{
    va_list children; va_start(children, firstChild);
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    va_end(children);
    if (self){
        self.key = key;
    }
    return self;
}

- (void)dealloc{
    self.key = nil;
    self.indexes = nil;
    
    [super dealloc];
}

- (void)setIndexes:(NSArray *)indexes{
    [_indexes release];
    _indexes = [indexes retain];
    
    for (LAHRecognizer *r in _indexes) {
        r.isIndex = YES;
    }
}

#pragma mark - States
- (void)saveStateForKey:(id)key{
    for (LAHConstruct *c in _children) {
        [c saveStateForKey:key];
    }
}

- (void)restoreStateForKey:(id)key{
    for (LAHConstruct *c in _children) {
        [c restoreStateForKey:key];
    }
}

#pragma mark - Identifier
- (LAHEle)currentRecognizer{
    for (LAHRecognizer *r in _indexes) {
        LAHEle matchingElement = r.matchingElement;
        if (matchingElement != nil) return matchingElement;
    }
    return nil;
}

- (BOOL)isIdentifierChanged{
    LAHEle current = self.currentRecognizer;
    return _lastElement != current;
}

#pragma mark - recursion
- (BOOL)checkUpate:(LAHConstruct *)object{
    return NO;
}

- (void)recieve:(LAHConstruct*)object{
    
}


@end

NSString * const gKeyLastFatherContainer = @"LFC";
NSString * const gKeyLastIdentifierElement = @"LIE";
NSString * const gKeyContainer = @"Con";


