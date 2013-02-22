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
    self = [self initWithFirstChild:firstChild variadicChildren:children];
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

- (id)recieveObject:(LAHConstruct*)object{
    return nil;
}

- (id)newValue{
    return nil;
}

- (void)saveStateForKey:(id)key{
    for (LAHRecognizer *r in _indexes) {
        [r saveStateForKey:key];
    }
    for (LAHRecognizer *c in _children) {
        [c saveStateForKey:key];
    }
}

- (void)restoreStateForKey:(id)key{
    for (LAHRecognizer *r in _indexes) {
        [r restoreStateForKey:key];
    }
    for (LAHRecognizer *c in _children) {
        [c restoreStateForKey:key];
    }
}

@end



