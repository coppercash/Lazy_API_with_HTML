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
- (void)handleElement:(id<LAHHTMLElement>)element atIndex:(NSUInteger)index{
    _index = index;
    [super handleElement:element atIndex:index];
}

- (id)recursiveContainer{
    id fatherContainer = _father.recursiveContainer;
    if (fatherContainer == nil) {
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

- (void)dealloc{
    [_container release]; _container = nil;
    [super dealloc];
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
