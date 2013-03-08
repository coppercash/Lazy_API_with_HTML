//
//  LAHNode.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"
#import "LAHInterface.h"

@interface LAHNode ()
@property(nonatomic, retain)NSMutableDictionary* states;
@end

@implementation LAHNode
@synthesize father = _father, children = _children, states = _states;
#pragma mark - Life Cycle

- (id)init{
    self = [super init];
    if (self) {
        [self.states = [[NSMutableDictionary alloc] init] release];
    }
    return self;
}

- (id)initWithFirstChild:(LAHNode*)firstChild variadicChildren:(va_list)children{
    self = [self init];
    if (self) {
        [self.children = [[NSMutableArray alloc] initWithObjects:firstChild, nil] release];
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
    va_list children; va_start(children, firstChild);
    self = [self initWithFirstChild:firstChild variadicChildren:children];
    va_end(children);
    return self;
}

- (void)dealloc{
    self.father = nil;
    self.children = nil;
    self.states = nil;
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
- (LAHOperation*)recursiveGreffier{
    return _father.recursiveGreffier;
}

- (void)handleElement:(LAHEle)element atIndex:(NSUInteger)index{
    NSArray *fakeChildren = [[NSArray alloc] initWithArray:_children];
    for (LAHNode *node in fakeChildren) {
        NSUInteger index = 0;
        for (LAHEle e in element.children) {
            [node handleElement:e atIndex:index];
            index++;
        }
    }
    [fakeChildren release];
}

- (void)releaseChild:(LAHNode*)child{
    [_children removeObject:child];
    child.father = nil;
    if (_children.count == 0) {
        [_children release]; _children = nil;
        [_father releaseChild:self];
    }
}

#pragma mark - States
- (void)saveStateForKey:(id)key{}
- (void)restoreStateForKey:(id)key{}

@end