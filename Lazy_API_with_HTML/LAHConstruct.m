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
@synthesize type = _type, key = _key, indexSource = _indexSource;
@synthesize count = _count;

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
    [_key release]; _key = nil;
    _indexSource = nil;
    
    [super dealloc];
}

- (id)recieveObject:(LAHConstruct*)object{
    _count ++;
    return nil;
}

- (id)newValue{
    return nil;
}

- (NSUInteger)index{
    if (_indexSource == nil) return NSNotFound;
    return _indexSource.numberInRange - 1;
}

@end



