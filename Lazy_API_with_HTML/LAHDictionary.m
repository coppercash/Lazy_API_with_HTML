//
//  LAHDictionary.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHDictionary.h"
#import "LAHRecognizer.h"

@interface LAHDictionary ()
@property(nonatomic, retain)NSMutableDictionary *dictionary;
@end

@implementation LAHDictionary
@synthesize dictionary = _dictionary;

- (id)initWithFirstChild:(LAHNode *)firstChild variadicChildren:(va_list)children{
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        self.type = LAHConstructTypeDictionary;
    }
    return self;
}

- (void)dealloc{
    self.dictionary = nil;
    [super dealloc];
}

- (BOOL)checkUpate:(LAHConstruct *)object{
    LAHConstruct *father = (LAHConstruct *)_father;
    BOOL update = NO;
    update |= [father checkUpate:self];
    update |= father.container != _lastFather;
    update |= _dictionary == nil;

    if (update) {
        [self.dictionary = [[NSMutableDictionary alloc] init] release];
        [father recieve:self];
    }

    _lastFather = father.container;
    _lastElement = self.currentRecognizer;
    return NO;
}

- (void)recieve:(LAHConstruct*)object{
    [_dictionary setObject:object.container forKey:object.key];
}

- (id)container{
    return _dictionary;
}

- (void)saveStateForKey:(id)key{
    NSMutableDictionary *collector = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (_lastFather) [collector setObject:_lastFather forKey:gKeyLastFatherContainer];
    if (_lastElement) [collector setObject:_lastElement forKey:gKeyLastIdentifierElement];
    if (_dictionary) [collector setObject:_dictionary forKey:gKeyContainer];
    
    [_states setObject:collector forKey:key];
    [collector release];
    
    [super saveStateForKey:key];
}

- (void)restoreStateForKey:(id)key{
    NSDictionary *state = [_states objectForKey:key];
    _lastFather = [state objectForKey:gKeyLastFatherContainer];
    _lastElement = [state objectForKey:gKeyLastIdentifierElement];
    self.dictionary = [state objectForKey:gKeyContainer];
    [_states removeObjectForKey:key];
    
    [super restoreStateForKey:key];
}

@end

