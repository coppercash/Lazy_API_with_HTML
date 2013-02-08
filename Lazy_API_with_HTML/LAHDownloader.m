//
//  LAHDownloader.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHDownloader.h"
#import "LAHOperation.h"

@implementation LAHDownloader
#pragma mark - Life Cycle
- (id)initWithProperty:(LAHPropertyGetter)property firstChild:(LAHNode*)firstChild variadicChildren:(va_list)children{
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        self.property = property;
    }
    return self;
}

- (id)initWithProperty:(LAHPropertyGetter)property children:(LAHNode*)firstChild, ... NS_REQUIRES_NIL_TERMINATION{
    va_list children;
    va_start(children, firstChild);
    self = [self initWithProperty:property firstChild:firstChild variadicChildren:children];
    va_end(children);
    return self;
}

- (void)dealloc{
    [super dealloc];
}

#pragma mark - Recursive
- (void)handleElement:(id<LAHHTMLElement>)element atIndex:(NSUInteger)index{
    if (![self isElementMatched:element atIndex:index]) return;
    DLogElement(element)
    DLogFetcher(self)
    
    if (_property == nil) return;
    NSString *info = _property(element);
    
    id<LAHDelegate> delegate = self.recursiveGreffier.delegate;
    if (delegate && [delegate respondsToSelector:@selector(downloader:needFileAtPath:)]) {
        id key = [delegate downloader:self needFileAtPath:info];
        [self.greffier saveDownloader:self forKey:key];
    }
}

- (void)fetchWithRoot:(id<LAHHTMLElement>)element{
    NSArray *fakeChildren = [[NSArray alloc] initWithArray:_children];
    for (LAHNode* node in fakeChildren) {
        [node handleElement:element atIndex:0];
    }
    [fakeChildren release];
    for (id<LAHHTMLElement> e in element.children) {
        [self fetchWithRoot:e];
    }
}

- (LAHOperation*)recursiveGreffier{
    if (_greffier == nil) _greffier = _father.recursiveGreffier;
    return _greffier;
}

@end
