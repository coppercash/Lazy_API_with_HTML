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

@interface LAHOperation ()
@property(nonatomic, retain)NSMutableDictionary *theDownloading;
@property(nonatomic, retain)NSMutableArray *theSeeking;
@property(nonatomic, retain)NSMutableArray *completions;
@property(nonatomic, retain)NSMutableArray *correctors;
@end

@implementation LAHOperation
@synthesize rootContainer = _rootContainer, path = _path;
@synthesize theDownloading = _theDownloading, theSeeking = _theSeeking, completions = _completions, correctors = _correctors;
@synthesize delegate = _delegate;

- (void)initialize{
    [self.theDownloading = [[NSMutableDictionary alloc] init] release];
    [self.theSeeking = [[NSMutableArray alloc] init] release];
    [self.completions = [[NSMutableArray alloc] init] release];
    [self.correctors = [[NSMutableArray alloc] init] release];
}

- (id)init{
    self = [super init];
    if (self) {
        [self initialize];
        self.path = @"";
    }
    return self;
}

- (id)initWithPath:(NSString*)path rootContainer:(LAHConstruct*)rootContainer firstChild:(LAHRecognizer*)firstChild variadicChildren:(va_list)children{
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        [self initialize];
        self.path = path;
        self.rootContainer = rootContainer;
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
    self.theDownloading = nil;
    self.theSeeking = nil;
    self.completions = nil;
    self.correctors = nil;
    self.path = nil;
    
    self.rootContainer = nil;
    
    self.delegate = nil;
    
    [super dealloc];
}

#pragma mark - Download
- (void)download:(LAHEle)element{
    NSString *link = _path;
    
    LAHOperation *operation = self.recursiveOperation;
    id<LAHDelegate> delegate = operation.delegate;
    if (delegate && [delegate respondsToSelector:@selector(downloader:needFileAtPath:)]) {
        id key = [delegate downloader:self needFileAtPath:link];
        [operation saveDownloader:self forKey:key];
    }
}

#pragma mark - Recursive
- (LAHOperation*)recursiveOperation{
    return self;
}

#pragma mark - Queue
- (void)saveDownloader:(LAHDownloader*)downloader forKey:(id)key{
    [_theDownloading setObject:downloader forKey:key];

    [_rootContainer saveStateForKey:key];
    for (LAHConstruct *c in _children) {
        [c saveStateForKey:key];
    }
}

- (void)awakeDownloaderForKey:(id)key withElement:(LAHEle)element{
    LAHDownloader *downloader = [_theDownloading objectForKey:key];
    if (downloader == nil) return;
    
    [self addSeeker:downloader];
    [_theDownloading removeObjectForKey:key];
    
    [_rootContainer restoreStateForKey:key];
    for (LAHConstruct *c in _children) {
        [c restoreStateForKey:key];
    }
    [downloader seekWithRoot:element];
    
    [self removeSeeker:downloader];
}

- (void)addSeeker:(LAHDownloader*)fetcher{
    [_theSeeking addObject:fetcher];
}

- (void)removeSeeker:(LAHDownloader*)fetcher{
    [_theSeeking removeObject:fetcher];
    if (_theSeeking.count + _theDownloading.count == 0) {
        __block LAHOperation *bSelf = self;
        for (LAHCompletion completion in _completions) {
            completion(bSelf);
        }
        [_delegate downloader:self didFetch:_rootContainer.container];
    }
}

#pragma mark - Event
- (void)start{
    [self download:nil];
}

- (void)addCompletion:(LAHCompletion)completion{
    if (completion == nil) return;
    LAHCompletion copy = [completion copy];
    [_completions addObject:copy];
    [copy release];
}

- (void)addCorrector:(LAHCorrector)corrector{
    if (corrector == nil) return;
    LAHCompletion copy = [corrector copy];
    [_correctors addObject:copy];
    [copy release];
}

- (void)handleError:(NSError*)error{
    for (LAHCorrector c in _correctors) {
        c(self, error);
    }
}

#pragma mark - Getter
- (id)container{
    return _rootContainer.container;
}

#pragma mark - Log
- (NSString *)infoProperties{
    NSMutableString *info = [NSMutableString string];
    if (_path) [info appendFormat:@"path=%@", _path];
    return info;
}

- (NSString *)infoChildren:(NSUInteger)degree{
    NSMutableString *info = [NSMutableString string];
    
    [info appendString:[_rootContainer info:degree]];
    [info appendString:[super infoChildren:degree]];
    
    return info;
}

@end
