//
//  CDTreeNode.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 5/6/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDTreeNode.h"

@implementation CDTreeNode
@synthesize father = _father, children = _children;

- (void)dealloc{
    self.father = nil;
    self.children = nil;
    [super dealloc];
}

#pragma mark - Init
- (id)initWithFirstChild:(CDTreeNode*)firstChild variadicChildren:(va_list)children{
    self = [self init];
    if (self) {
        [self.children = [[NSMutableArray alloc] initWithObjects:firstChild, nil] release];
        firstChild.father = self;
        
        CDTreeNode* child;
        NSMutableArray *collector = [[NSMutableArray alloc] init];
        while ((child = va_arg(children, CDTreeNode*)) != nil){
            [collector addObject:child];
            child.father = self;
        }
        _children = [[NSArray alloc] initWithArray:collector];
        [collector release];
    }
    return self;
}

- (id)initWithChildren:(CDTreeNode*)firstChild, ... {
    va_list children; va_start(children, firstChild);
    self = [self initWithFirstChild:firstChild variadicChildren:children];
    va_end(children);
    return self;
}

#pragma mark - Setter
- (void)setChildren:(NSArray *)children{
    [_children release];
    _children = [children retain];
    
    for (CDTreeNode* child in _children) {
        child.father = self;
    }
}
@end
