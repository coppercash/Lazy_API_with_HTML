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
@dynamic recursiveOperation;

#pragma mark - Life Cycle
- (id)init{
    self = [super init];
    if (self) {
        [self.states = [[NSMutableDictionary alloc] init] release];
    }
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
- (void)setChildren:(NSArray *)children{
    [_children release];
    _children = [children retain];
    for (LAHNode* node in _children) {
        node.father = self;
    }
}

#pragma mark - Getter
- (LAHOperation*)recursiveOperation{
    return _father.recursiveOperation;
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

#pragma mark - Log
@dynamic degree;
@synthesize degreeSpace;
- (NSUInteger)degree{
    return (_father == nil) ? 0 : _father.degree + 1;
}

- (NSString *)degreeSpace{
    NSUInteger degree = self.degree;
    NSMutableString *space = [NSMutableString string];
    while (degree --) {
        [space appendString:@"\t"];
    }
    return space;
}

- (NSString *)des{
    return [super description];
}

- (NSString *)description{
    NSString *info = [NSString stringWithFormat:@"<%@%@  @%p>", self.tagNameInfo, self.attributesInfo, self.des];
    return info;
}

- (NSString *)debugDescription{
    return [self debugLog:0];
}

- (NSString *)debugLog:(NSUInteger)degree{
    NSMutableString *info = [NSMutableString stringWithString:@"\n"];
    
    NSUInteger counter = degree;
    while (counter --) [info appendString:@"\t"];
    
    [info appendString:self.description];
    
    for (LAHNode *child in self.children) {
        [info appendFormat:@"%@", [child debugLog:degree + 1]];
    }
    
    return info;
}

- (NSString *)tagNameInfo{
    return @"node";
}

- (NSString *)attributesInfo{
    return @"";
}

#pragma mark - Init
- (id)initWithFirstChild:(LAHNode*)firstChild variadicChildren:(va_list)children{
    self = [self init];
    if (self) {
        [self.children = [[NSMutableArray alloc] initWithObjects:firstChild, nil] release];
        firstChild.father = self;
        
        LAHNode* child;
        NSMutableArray *collector = [[NSMutableArray alloc] init];
        while ((child = va_arg(children, LAHNode*)) != nil){
            [collector addObject:child];
            child.father = self;
        }
        _children = [[NSArray alloc] initWithArray:collector];
        [collector release];
    }
    return self;
}

- (id)initWithChildren:(LAHNode*)firstChild, ... {
    va_list children; va_start(children, firstChild);
    self = [self initWithFirstChild:firstChild variadicChildren:children];
    va_end(children);
    return self;
}

@end