//
//  LAHNode.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"
#define kFater ((LAHNode *)_father)

@interface LAHNode ()
@end

@implementation LAHNode
@dynamic recursiveOperation;

#pragma mark - Life Cycle

- (void)dealloc{
    self.father = nil;
    self.children = nil;
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone{
    LAHNode *copy = [[[self class] allocWithZone:zone] init];
    
    if (_children) copy.children = [[NSMutableArray alloc] initWithArray:_children copyItems:YES];
    for (LAHNode *node in copy.children) {
        node.father = copy;
    }
    
    [copy.children release];
    
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
    return kFater.recursiveOperation;
}

#pragma mark - States
- (void)refresh{
    for (LAHNode *c in _children) {
        [c refresh];
    }
}

#pragma mark - Log
@dynamic degree;
@synthesize degreeSpace;

- (NSString *)debugDescription{
    return [self debugLog:0];
}

- (NSString *)description{
    NSString *info = [NSString stringWithFormat:@"<%@%@  @%p>", self.tagNameInfo, self.attributesInfo, self.des];
    return info;
}

- (NSString *)des{
    return [super description];
}

- (NSUInteger)degree{
    return (_father == nil) ? 0 : kFater.degree + 1;
}

- (NSString *)degreeSpace{
    NSUInteger degree = self.degree;
    NSMutableString *space = [NSMutableString string];
    while (degree --) {
        [space appendString:@"\t"];
    }
    return space;
}

- (NSString *)debugLog:(NSUInteger)degree{
    NSMutableString *info = [NSMutableString stringWithFormat:@"\n%@%@", self.degreeSpace, self];
    
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


@end