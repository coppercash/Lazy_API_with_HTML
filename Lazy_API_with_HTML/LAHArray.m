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
    LAHConstruct *father = (LAHConstruct *)_father;
    BOOL update = NO;
    update |= [father checkUpate:self];
    update |= father.container != _lastFather;
    update |= _array == nil;
    if (update) {
        [self.array = [[NSMutableArray alloc] init] release];
        [father recieve:self];
    }
    
    _lastFather = father.container;
    _lastElement = self.currentRecognizer;
    return object.isIdentifierChanged;
}

- (void)recieve:(LAHConstruct*)object{
    [_array addObject:object.container];
}

- (id)container{
    return _array;
}

- (void)saveStateForKey:(id)key{
        NSMutableDictionary *collector = [[NSMutableDictionary alloc] initWithCapacity:3];
        if (_lastFather) [collector setObject:_lastFather forKey:gKeyLastFatherContainer];
        if (_lastElement) [collector setObject:_lastElement forKey:gKeyLastIdentifierElement];
        if (_array) [collector setObject:_array forKey:gKeyContainer];
        
        [_states setObject:collector forKey:key];
        [collector release];
        
        [super saveStateForKey:key];
}

- (void)restoreStateForKey:(id)key{
    NSDictionary *state = [_states objectForKey:key];
    _lastFather = [state objectForKey:gKeyLastFatherContainer];
    _lastElement = [state objectForKey:gKeyLastIdentifierElement];
    self.array = [state objectForKey:gKeyContainer];
    [_states removeObjectForKey:key];
    
    [super restoreStateForKey:key];
}

@end

