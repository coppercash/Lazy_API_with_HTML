//
//  LAHContainer.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/7/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHContainer.h"

@implementation LAHContainer
@synthesize container = _container, key = _key;
- (id)initWithFirstChild:(LAHNode *)firstChild variadicChildren:(va_list)children{
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        _states = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc{
    [_states release]; _states = nil;
    [_container release]; _container = nil;

    [super dealloc];
}

- (void)handleElement:(id<LAHHTMLElement>)element atIndex:(NSUInteger)index{
    _index = index;
    [super handleElement:element atIndex:index];
}

- (id)recursiveContainer{
    id fatherContainer = _father.recursiveContainer;
    if (fatherContainer == self) {  //is root container
        if (_container == nil) _container = [[_containerClass alloc] init];
        return _container;
        
    }else if ([fatherContainer isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *fatherArray = (NSMutableArray*)fatherContainer;
        id container = nil;
        if (_index < fatherArray.count) {
            container = [(NSMutableArray*)fatherContainer objectAtIndex:_index];
        }else{
            container = [[_containerClass alloc] init];
            [fatherContainer addObject:container];
            [container release];
        }
        
        return container;
    }else if (_key != nil && [fatherContainer isKindOfClass:[NSMutableDictionary class]]) {
        id container = [(NSMutableDictionary*)fatherContainer objectForKey:_key];
        if (container == nil) {
            container = [[_containerClass alloc] init];
            [fatherContainer setObject:container forKey:_key];
            [container release];
        }
        return container;
    }
    return fatherContainer;
}

- (void)saveStateForKey:(id)key{
    id fatherContainer = _father.recursiveContainer;
    if ([fatherContainer isKindOfClass:[NSMutableArray class]]) {
        NSNumber *index = [[NSNumber alloc] initWithUnsignedInteger:_index];
        [_states setObject:index forKey:key];
        [index release];
    }
    [super saveStateForKey:key];
}

- (void)restoreStateForKey:(id)key{
    id fatherContainer = _father.recursiveContainer;
    if ([fatherContainer isKindOfClass:[NSMutableArray class]]) {
        NSNumber *index = [_states objectForKey:key];
        [_states removeObjectForKey:key];
        _index = index.unsignedIntegerValue;
    }
    [super restoreStateForKey:key];
}

@end

@implementation LAHDictionary : LAHContainer
- (id)initWithFirstChild:(LAHNode *)firstChild variadicChildren:(va_list)children{
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        self.containerClass = [NSMutableDictionary class];
    }
    return self;
}

@end

@implementation LAHArray : LAHContainer
- (id)initWithFirstChild:(LAHNode *)firstChild variadicChildren:(va_list)children{
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        self.containerClass = [NSMutableArray class];
    }
    return self;
}

@end
