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
@synthesize linker = _linker;
#pragma mark - Life Cycle
- (id)initWithLinker:(LAHPropertyFetcher)linker firstChild:(LAHNode*)firstChild variadicChildren:(va_list)children{
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        self.linker = linker;
    }
    return self;
}

- (id)initWithLinker:(LAHPropertyFetcher)linker children:(LAHNode*)firstChild, ... NS_REQUIRES_NIL_TERMINATION{
    va_list children;
    va_start(children, firstChild);
    self = [self initWithLinker:linker firstChild:firstChild variadicChildren:children];
    va_end(children);
    return self;
}

- (void)dealloc{
    [_linker release]; _linker = nil;
    [super dealloc];
}

#pragma mark - Seek
- (void)download:(id<LAHHTMLElement>)element{
    if (_linker == nil) return;
    NSString *link = _linker(element);
    
    LAHOperation *operation = self.recursiveOperation;
    id<LAHDelegate> delegate = operation.delegate;
    if (delegate && [delegate respondsToSelector:@selector(downloader:needFileAtPath:)]) {
        id key = [delegate downloader:self needFileAtPath:link];
        [operation saveDownloader:self forKey:key];
    }
}

- (void)seekWithRoot:(id<LAHHTMLElement>)element{
    for (LAHRecognizer* node in _children) {
        [node refreshState];
        [node handleElement:element];
    }
    
    for (id<LAHHTMLElement> e in element.children) {
        [self seekWithRoot:e];
    }
}

#pragma mark - State
- (void)saveStateForKey:(id)key{
    LAHRecognizer *father = (LAHRecognizer*)_father;
    [father saveStateForKey:key];
}

- (void)restoreStateForKey:(id)key{
    LAHRecognizer *father = (LAHRecognizer*)_father;
    [father restoreStateForKey:key];
}

- (LAHOperation*)recursiveOperation{
    LAHRecognizer *father = (LAHRecognizer*)_father;
    LAHOperation* greffier = father.recursiveOperation;
    return greffier;
}

@end
