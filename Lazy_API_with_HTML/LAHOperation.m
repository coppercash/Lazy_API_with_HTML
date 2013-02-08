//
//  LAHGreffier.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHOperation.h"
#import "LAHDownloader.h"
#import "LAHContainer.h"

@implementation LAHOperation
@synthesize delegate = _delegate;
- (id)init{
    self = [super init];
    if (self) {
        _theDownloading = [[NSMutableDictionary alloc] init];
        _theFetching = [[NSMutableArray alloc] init];
        _completions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithPath:(NSString*)path rootContainer:(LAHContainer*)rootContainer firstChild:(LAHNode*)firstChild variadicChildren:(va_list)children{
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        _theDownloading = [[NSMutableDictionary alloc] init];
        _theFetching = [[NSMutableArray alloc] init];
        _completions = [[NSMutableArray alloc] init];

        _rootContainer = [rootContainer retain];
        self.property = ^(id<LAHHTMLElement> element){
            return path;
        };
    }
    return self;
}

- (id)initWithPath:(NSString*)path rootContainer:(LAHContainer*)rootContainer children:(LAHNode*)firstChild, ... NS_REQUIRES_NIL_TERMINATION{
    va_list children;
    va_start(children, firstChild);
    
    self = [self initWithPath:path rootContainer:rootContainer firstChild:firstChild variadicChildren:children];
    
    va_end(children);
    return self;
}

- (void)dealloc{
    [_theDownloading release]; _theDownloading = nil;
    [_theFetching release]; _theFetching = nil;
    [_completions release]; _completions = nil;
    
    [_rootContainer release]; _rootContainer = nil;

    _delegate = nil;
    
    [super dealloc];
}

#pragma mark - Recursive
- (void)handleElement:(id<LAHHTMLElement>)element atIndex:(NSUInteger)index{
    if (_property == nil) return;
    NSString *info = _property(element);
    
    if (_delegate && [_delegate respondsToSelector:@selector(downloader:needFileAtPath:)]) {
        id key = [_delegate downloader:self needFileAtPath:info];
        [self saveDownloader:self forKey:key];
    }
}

- (id)recursiveContainer{
    return _rootContainer;
}

- (LAHOperation*)recursiveGreffier{
    return self;
}

#pragma mark - Queue
- (void)saveDownloader:(LAHDownloader*)downloader forKey:(id)key{
    [_theDownloading setObject:downloader forKey:key];
    [downloader saveStateForKey:key];
}

- (void)awakeDownloaderForKey:(id)key withElement:(id<LAHHTMLElement>)element{
    LAHDownloader *downloader = [_theDownloading objectForKey:key];
    
    [self addFetcher:self];

    [downloader restoreStateForKey:key];
    [downloader fetchWithRoot:element];
    
    [_theDownloading removeObjectForKey:key];
    [self removeFetcher:self];
}

- (void)addFetcher:(LAHDownloader*)fetcher{
    [_theFetching addObject:fetcher];
}

- (void)removeFetcher:(LAHDownloader*)fetcher{
    [_theFetching removeObject:fetcher];
    if (_theFetching.count + _theDownloading.count == 0) {
        for (LAHCompletion completion in _completions) {
            completion(self);
        }
        [_delegate downloader:self didFetch:_rootContainer.container];
    }
}

#pragma make - Event
- (void)start{
    [self handleElement:nil atIndex:0];
}

- (void)addCompletion:(LAHCompletion)completion{
    [_completions addObject:completion];
}

- (id)container{
    return _rootContainer.container;
}

@end
