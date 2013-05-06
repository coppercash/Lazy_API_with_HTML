//
//  LAHArray.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHArray.h"
#import "LAHTag.h"

@interface LAHArray ()
@property(nonatomic, retain)NSMutableArray *array;
@end

@implementation LAHArray
@synthesize array = _array;

- (id)initWithObjects:(LAHModel *)firstObj, ... {
    va_list objs; va_start(objs, firstObj);
    self = [self initWithFirstChild:firstObj variadicChildren:objs];
    va_end(objs);
    return self;
}

- (void)dealloc{
    self.array = nil;
    [super dealloc];
}

#pragma mark - recursion
- (void)recieve:(LAHModel*)object{
    [super recieve:object];
    [self.array addObject:object.data];
}

- (NSMutableArray *)array{
    if (!_array || self.needUpdate) {
        [_array release];
        _array = [[NSMutableArray alloc] init];
        self.needUpdate = NO;
        [(LAHModel *)_father recieve:self];
    }
    return _array;
}

- (id)data{
    return _array;
}

#pragma mark - States
- (void)saveStateForKey:(id)key{
    NSAssert(_states[key] == nil, @"Will overwrite state for key '%@'", key);
    
    NSMutableDictionary *state = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (_array) state[gKeyContainer] = _array;
    state[gKeyNeedUpdate] = [NSNumber numberWithBool:_needUpdate];
    
    _states[key] = state;
    [state release];
    
    [super saveStateForKey:key];
}

- (void)restoreStateForKey:(id)key{
    NSDictionary *state = [_states objectForKey:key];
    self.array = [state objectForKey:gKeyContainer];
    self.needUpdate = [state[gKeyNeedUpdate] boolValue];
    
    [_states removeObjectForKey:key];
    
    [super restoreStateForKey:key];
}

- (void)refresh{
    self.array = nil;
    [super refresh];
}

#pragma mark - Log
- (NSString *)tagNameInfo{
    return @"arr";
}

@end

