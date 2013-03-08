//
//  LAHArray.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHArray.h"
#import "LAHRecognizer.h"

@interface LAHArray ()
@property(nonatomic, retain)NSMutableArray *array;
@end

@implementation LAHArray
@synthesize array = _array;

- (id)initWithObjects:(LAHConstruct *)firstObj, ... NS_REQUIRES_NIL_TERMINATION{
    va_list objs; va_start(objs, firstObj);
    self = [self initWithFirstChild:firstObj variadicChildren:objs];
    va_end(objs);
    return self;
}

- (id)initWithFirstChild:(LAHNode *)firstChild variadicChildren:(va_list)children{
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        self.type = LAHConstructTypeArray;
    }
    return self;
}

- (void)dealloc{
    self.array = nil;
    [super dealloc];
}

- (BOOL)checkUpate:(LAHConstruct *)object{
    [super checkUpate:object];
    return object.isIdentifierElementChanged;
}

- (void)update{
    [self.array = [[NSMutableArray alloc] init] release];
    [(LAHConstruct *)_father recieve:self];
}

- (void)recieve:(LAHConstruct*)object{
    [_array addObject:object.container];
}

- (id)container{
    return _array;
}

- (void)saveStateForKey:(id)key{
    NSMutableDictionary *collector = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (_lastFatherContainer) [collector setObject:_lastFatherContainer forKey:gKeyLastFatherContainer];
    if (_lastIdentifierElement) [collector setObject:_lastIdentifierElement forKey:gKeyLastIdentifierElement];
    if (_array) [collector setObject:_array forKey:gKeyContainer];
    
    [_states setObject:collector forKey:key];
    [collector release];
    
    [super saveStateForKey:key];
}

- (void)restoreStateForKey:(id)key{
    NSDictionary *state = [_states objectForKey:key];
    _lastFatherContainer = [state objectForKey:gKeyLastFatherContainer];
    _lastIdentifierElement = [state objectForKey:gKeyLastIdentifierElement];
    self.array = [state objectForKey:gKeyContainer];
    [_states removeObjectForKey:key];
    
    [super restoreStateForKey:key];
}

@end

