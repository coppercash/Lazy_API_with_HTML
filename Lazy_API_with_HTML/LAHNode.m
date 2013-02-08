//
//  LAHNode.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"
#import "LAHProtocols.h"

@implementation LAHNode
@synthesize father = _father, children = _children;
#pragma mark - Life Cycle
- (id)init{
    self = [super init];
    if (self) {
        _children = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithFirstChild:(LAHNode*)firstChild variadicChildren:(va_list)children{
    self = [super init];
    if (self) {
        _children = [[NSMutableArray alloc] initWithObjects:firstChild, nil];
        firstChild.father = self;

        LAHNode* child;
        while ((child = va_arg(children, LAHNode*)) != nil){
            [_children addObject:child];
            child.father = self;
        }
    }
    return self;
}

- (id)initWithChildren:(LAHNode*)firstChild, ... NS_REQUIRES_NIL_TERMINATION{
    va_list children;
    va_start(children, firstChild);

    self = [self initWithFirstChild:firstChild variadicChildren:children];

    va_end(children);
    return self;
}

- (void)dealloc{
    _father = nil;
    [_children release]; _children = nil;
    [super dealloc];
}

#pragma mark - Setter
- (void)setChildren:(NSMutableArray *)children{
    _children = [children retain];
    for (LAHNode* node in _children) {
        node.father = self;
    }
}

#pragma mark - Recursive
- (LAHGreffier*)recursiveGreffier{
    return _father.recursiveGreffier;
}

- (id)recursiveContainer{
    return _father.recursiveContainer;
}

- (void)handleElement:(id<LAHHTMLElement>)element atIndex:(NSUInteger)index{}

- (void)saveStateForKey:(id)key{
    [_father saveStateForKey:key];
}

- (void)restoreStateForKey:(id)key{
    [_father restoreStateForKey:key];
}

- (void)releaseChild:(LAHNode*)child{
    [_children removeObject:child];
    child.father = nil;
    if (_children.count == 0) {
        [_children release]; _children = nil;
        [_father releaseChild:self];
    }
}

@end
