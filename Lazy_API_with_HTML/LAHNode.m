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


@end