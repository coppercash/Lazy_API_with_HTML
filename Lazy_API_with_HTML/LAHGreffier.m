//
//  LAHGreffier.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHGreffier.h"
#import "LAHDownloader.h"
#import "LAHContainer.h"

@implementation LAHGreffier
@synthesize rootContainer = _rootContainer;
@synthesize dataSource = _dataSource, delegate = _delegate;
- (id)init{
    self = [super init];
    if (self) {
        _theDownloading = [[NSMutableDictionary alloc] init];
        _theFetching = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithPath:(NSString*)path rootContainer:(LAHContainer*)rootContainer{
    self = [super init];
    if (self) {
        _theDownloading = [[NSMutableDictionary alloc] init];
        _theFetching = [[NSMutableArray alloc] init];
        
        self.rootContainer = rootContainer;
        self.property = ^(id<LAHHTMLElement> element){
            return path;
        };
    }
    return self;

}

- (id)initWithPath:(NSString*)path rootContainer:(LAHContainer*)rootContainer firstChild:(LAHNode*)firstChild variadicChildren:(va_list)children{
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        _theDownloading = [[NSMutableDictionary alloc] init];
        _theFetching = [[NSMutableArray alloc] init];
        
        self.rootContainer = rootContainer;
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

    [_rootContainer release]; _rootContainer = nil;

    _dataSource = nil;
    _delegate = nil;
    
    [super dealloc];
}

#pragma mark - Recursive
- (void)handleElement:(id<LAHHTMLElement>)element atIndex:(NSUInteger)index{
    if (_property == nil) return;
    NSString *info = _property(element);
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(downloader:needFileAtPath:)]) {
        id key = [_dataSource downloader:self needFileAtPath:info];
        [self saveDownloader:self forKey:key];
    }
}

- (id)recursiveContainer{
    return _rootContainer;
}

- (LAHGreffier*)recursiveGreffier{
    return self;
}

/*
- (id)initWithRootDownloader:(LAHDownloader*)root{
    self = [super init];
    if (self) {
        _container = [[NSMutableDictionary alloc] init];
        _waitingDowloaders = [[NSMutableDictionary alloc] init];
        
        _rootDownloader = [root retain];
        _rootDownloader.greffier = self;
    }
    return self;
}*/


#pragma mark - Queue
/*
- (void)setDownloader:(LAHDownloader*)downloader forKey:(id)key{
    [_theDownloading setObject:downloader forKey:key];
}

- (LAHDownloader*)downloaderForKey:(id)key{
    LAHDownloader *downloader = [_theDownloading objectForKey:key];
    [_theDownloading removeObjectForKey:key];
    [downloader restoreStateForKey:key];
    return downloader;
}*/

- (void)saveDownloader:(LAHDownloader*)downloader forKey:(id)key{
    [_theDownloading setObject:downloader forKey:key];
    [downloader saveStateForKey:key];
}

- (void)awakeDownloaderForKey:(id)key withElement:(id<LAHHTMLElement>)element{
    LAHDownloader *downloader = [_theDownloading objectForKey:key];
    [_theDownloading removeObjectForKey:key];
    
    [self addFetcher:self];

    [downloader restoreStateForKey:key];
    [downloader fetchWithRoot:element];
    
    [self removeFetcher:self];
}

- (void)addFetcher:(LAHDownloader*)fetcher{
    [_theFetching addObject:fetcher];
}

- (void)removeFetcher:(LAHDownloader*)fetcher{
    [_theFetching removeObject:fetcher];
    if (_theFetching.count + _theDownloading.count == 0) {
        [_delegate downloader:fetcher didFetch:_rootContainer.container];
    }
}


/*
- (void)startWithTreeRoot:(LAHDownloader*)root{
    if (root == nil) return;
    [root handleElement:nil];
}*/


/*
- (void)startWithPath:(NSString*)path{
    if (_rootDownloader == nil && path == nil) return;
    _rootDownloader.propertyGetter = ^(id<LAHHTMLElement> element){
        return path;
    };
    [_rootDownloader handleElement:nil];
}*/


@end
