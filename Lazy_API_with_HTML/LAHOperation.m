//
//  LAHGreffier.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHOperation.h"
#import "LAHDownloader.h"
#import "LAHConstruct.h"

@implementation LAHOperation
@synthesize delegate = _delegate;
- (id)init{
    self = [super init];
    if (self) {
        _theDownloading = [[NSMutableDictionary alloc] init];
        _theSeeking = [[NSMutableArray alloc] init];
        _completions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithPath:(NSString*)path rootContainer:(LAHConstruct*)rootContainer firstChild:(LAHRecognizer*)firstChild variadicChildren:(va_list)children{
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        _theDownloading = [[NSMutableDictionary alloc] init];
        _theSeeking = [[NSMutableArray alloc] init];
        _completions = [[NSMutableArray alloc] init];

        _rootContainer = [rootContainer retain];
        self.linker = ^(id<LAHHTMLElement> element){
            return path;
        };
    }
    return self;
}

- (id)initWithPath:(NSString*)path rootContainer:(LAHConstruct*)rootContainer children:(LAHRecognizer*)firstChild, ... NS_REQUIRES_NIL_TERMINATION{
    va_list children;
    va_start(children, firstChild);
    
    self = [self initWithPath:path rootContainer:rootContainer firstChild:firstChild variadicChildren:children];
    
    va_end(children);
    return self;
}

- (void)dealloc{
    [_theDownloading release]; _theDownloading = nil;
    [_theSeeking release]; _theSeeking = nil;
    [_completions release]; _completions = nil;
    
    [_rootContainer release]; _rootContainer = nil;

    _delegate = nil;
    
    [super dealloc];
}

#pragma mark - Recursive
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
    
    [self addSeeker:downloader];

    [downloader restoreStateForKey:key];
    [downloader seekWithRoot:element];
    
    [_theDownloading removeObjectForKey:key];
    [self removeSeeker:downloader];
}

- (void)addSeeker:(LAHDownloader*)fetcher{
    [_theSeeking addObject:fetcher];
}

- (void)removeSeeker:(LAHDownloader*)fetcher{
    [_theSeeking removeObject:fetcher];
    if (_theSeeking.count + _theDownloading.count == 0) {
        for (LAHCompletion completion in _completions) {
            completion(self);
        }
        [_delegate downloader:self didFetch:_rootContainer.container];
    }
}

#pragma mark - Event
- (void)start{
    [self download:nil];
}

- (void)addCompletion:(LAHCompletion)completion{
    [_completions addObject:completion];
}

#pragma mark - Getter
- (id)container{
    return _rootContainer.container;
}

@end
