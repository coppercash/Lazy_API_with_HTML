//
//  LAHNode.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"

@interface LAHNode ()
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

- (id)initWithChildren:(LAHNode*)firstChild, ... {
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

- (id)copyWithZone:(NSZone *)zone{
    LAHNode *copy = [[[self class] allocWithZone:zone] init];
    
    if (_children) copy.children = [[NSMutableArray alloc] initWithArray:_children copyItems:YES];
    for (LAHNode *node in copy.children) {
        node.father = copy;
    }
    
    if (_states) copy.states = [[NSMutableDictionary alloc] initWithDictionary:_states copyItems:YES];

    [copy.children release];
    [copy.states release];
    
    return copy;
}

#pragma mark - Setter
- (void)setChildren:(NSMutableArray *)children{
    [_children release];
    _children = [children retain];
    for (LAHNode* node in _children) {
        node.father = self;
    }
}

#pragma mark - Recursive
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

- (LAHOperation*)recursiveOperation{
    return _father.recursiveOperation;
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

- (void)refresh{
    [_states removeAllObjects];
    for (LAHNode *c in _children) {
        [c refresh];
    }
}

#pragma mark - Interpreter
- (void)addChild:(LAHNode *)child{
    if (_children == nil) [self.children = [[NSMutableArray alloc] init] release];
    [_children addObject:child];
    child.father = self;
}

#pragma mark - Log
- (NSString *)description{
    return [self info:0];
}

- (void)log{
    NSLog(@"%@", [self info:0]);
}

- (void)logLonely{
    NSLog(@"%@", self.infoSelf);
}

- (NSString *)info:(NSUInteger)degree{
    NSMutableString *info = [NSMutableString stringWithString:@"\n"];
    
    for (int i = 0; i < degree; i ++)  [info appendString:@"\t"];
    
    [info appendString:self.infoSelf];
    
    NSString *chiInfo = [self infoChildren:degree + 1];
    if (chiInfo && chiInfo.length != 0) [info appendFormat:@":%@", chiInfo];
    
    return info;
}

- (NSString *)infoSelf{
    NSMutableString *info = [NSMutableString stringWithFormat:@"%@", super.description];
    NSString *proInfo = self.infoProperties;
    if (proInfo && proInfo.length != 0) {
        [info appendFormat:@" ( %@)", proInfo];
    }
    return info;
}

- (NSString *)infoProperties{
    return nil;
}

- (NSString *)infoChildren:(NSUInteger)degree{
    NSMutableString *info = [NSMutableString string];
    for (LAHNode *n in _children) [info appendString:[n info:degree]];
    return info;
}

@end