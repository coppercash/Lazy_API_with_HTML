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
#import "LAHFetcher.h"

@interface LAHOperation ()
@property(nonatomic, retain)NSMutableDictionary *downloadings;
@property(nonatomic, retain)NSMutableArray *seekings;
@property(nonatomic, retain)NSMutableArray *networks;
@property(nonatomic, retain)NSMutableArray *completions;
@property(nonatomic, retain)NSMutableArray *correctors;
- (BOOL)checkUpate:(LAHConstruct *)object;
- (void)checkFinishing;
@end

@implementation LAHOperation
@synthesize construct = _construct;
@synthesize downloadings = _downloadings, seekings = _seekings, networks = _networks;
@synthesize completions = _completions, correctors = _correctors;
@synthesize delegate = _delegate;


- (id)init{
    self = [super init];
    if (self) {
        self.link = @"";
    }
    return self;
}

- (id)initWithPath:(NSString*)path construct:(LAHConstruct*)rootContainer firstChild:(LAHRecognizer*)firstChild variadicChildren:(va_list)children{
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        self.link = path;
        self.construct = rootContainer;
    }
    return self;
}

- (id)initWithPath:(NSString*)path construct:(LAHConstruct*)rootContainer children:(LAHRecognizer*)firstChild, ... {
    va_list children;
    va_start(children, firstChild);
    
    self = [self initWithPath:path construct:rootContainer firstChild:firstChild variadicChildren:children];
    
    va_end(children);
    return self;
}

- (void)dealloc{
    self.downloadings = nil;
    self.seekings = nil;
    self.networks = nil;
    
    self.completions = nil;
    self.correctors = nil;
    
    self.construct = nil;
    
    self.delegate = nil;
    
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone{
    LAHOperation *copy = [super copyWithZone:zone];
    
    copy.construct = [_construct copy];
    copy.construct.father = copy;
    
    if (_downloadings) copy.downloadings = [[NSMutableDictionary alloc] initWithDictionary:_downloadings copyItems:YES];
    if (_seekings) copy.seekings = [[NSMutableArray alloc] initWithArray:_seekings copyItems:YES];
    if (_networks) copy.networks = [[NSMutableArray alloc] initWithArray:_networks copyItems:YES];
    
    copy.delegate = _delegate;
    if (_completions) copy.completions = [[NSMutableArray alloc] initWithArray:_completions copyItems:YES];
    if (_correctors) copy.correctors = [[NSMutableArray alloc] initWithArray:_correctors copyItems:YES];
    
    [copy.construct release];
    [copy.downloadings release];
    [copy.completions release];
    [copy.correctors release];
    
    return copy;
}

#pragma mark - Getters
- (NSMutableDictionary *)downloadings{
    if (!_downloadings) {
        _downloadings = [[NSMutableDictionary alloc] init];
    }
    return _downloadings;
}

- (NSMutableArray *)seekings{
    if (!_seekings) {
        _seekings = [[NSMutableArray alloc] init];
    }
    return _seekings;
}

- (NSMutableArray *)networks{
    if (!_networks) {
        _networks = [[NSMutableArray alloc] init];
    }
    return _networks;
}

- (NSMutableArray *)completions{
    if (!_completions) {
        _completions = [[NSMutableArray alloc] init];
    }
    return _completions;
}

- (NSMutableArray *)correctors{
    if (!_correctors) {
        _correctors = [[NSMutableArray alloc] init];
    }
    return _correctors;
}

#pragma mark - Status
- (void)refresh{
    [self cancel];
    [_construct refresh];
    [_downloadings removeAllObjects];
    [_seekings removeAllObjects];
    [_completions removeAllObjects];
    [_correctors removeAllObjects];
    [super refresh];
}

#pragma mark - Fake LAHConstruct
- (BOOL)checkUpate:(LAHConstruct *)object{
    return NO;
}

- (void)update{
}

- (void)recieve:(LAHConstruct*)object{
}

#pragma mark - Recursive
- (void)setConstruct:(LAHConstruct *)construct{
    [_construct release];
    _construct = [construct retain];
    construct.father = self;
}

- (LAHOperation*)recursiveOperation{
    return self;
}

#pragma mark - Queue
- (void)saveDownloader:(LAHDownloader *)downloader forKey:(id)key{
    
    NSMutableArray *pages = [_downloadings objectForKey:key];
    if (pages) {
        
        [pages addObject:downloader];
    
    } else {
        
        pages = [[NSMutableArray alloc] initWithObjects:downloader, nil];
        [self.downloadings setObject:pages forKey:key];
    
    }

    NSString *pageKey = downloader.identifier;
    [_construct saveStateForKey:pageKey];
    for (LAHConstruct *c in _children) {
        [c saveStateForKey:pageKey];
    }
}

- (void)awakeDownloaderForKey:(id)key withElement:(LAHEle)element{
    
    NSArray *pages = [_downloadings objectForKey:key];
    
    for (LAHDownloader *p in pages) {
        
        NSString *pageKey = p.identifier;
        [_construct restoreStateForKey:pageKey];
        for (LAHConstruct *c in _children) {
            [c restoreStateForKey:pageKey];
        }
        
        [self.seekings addObject:p];
        
        [p seekWithRoot:element];

        [_seekings removeObject:p];
    }
    
    [_downloadings removeObjectForKey:key];
    
    [self checkFinishing];

}

#pragma mark - Network
- (void)addNetwork:(id)network{
#ifdef LAH_OPERATION_DEBUG
    NSUInteger c = _networks.count;
#endif
    [_networks addObject:network];
#ifdef LAH_OPERATION_DEBUG
    NSString *info = [NSString stringWithFormat:@"%@\tnetwork ADD %d -> %d",
                      self, c, _networks.count];
    printf("\n%s\n", [info cStringUsingEncoding:NSASCIIStringEncoding]);
#endif
}

- (void)cancel{
#ifdef LAH_OPERATION_DEBUG
    NSString *info = [NSString stringWithFormat:@"%@\tcancel networks:%d",
                         self, _networks.count];
    printf("\n%s\n", [info cStringUsingEncoding:NSASCIIStringEncoding]);
#endif
    
    if (_delegate && [_delegate respondsToSelector:@selector(operation:willCancelNetworks:)]) {
        [_delegate operation:self willCancelNetworks:_networks];
    }
    [_networks removeAllObjects];
}

#pragma mark - Event
- (void)start{
    [self download:nil];
}

- (void)addCompletion:(LAHCompletion)completion{
    if (completion == nil) return;
    LAHCompletion copy = [completion copy];
    [self.completions addObject:copy];
    [copy release];
}

- (void)addCorrector:(LAHCorrector)corrector{
    if (corrector == nil) return;
    LAHCompletion copy = [corrector copy];
    [self.correctors addObject:copy];
    [copy release];
}

- (void)handleError:(NSError*)error withKey:(id)key{
    [self cancel];
    if (_delegate && [_delegate respondsToSelector:@selector(operation:didFetch:)]) {
        [_delegate operation:self didFetch:_construct.container];
    }
    for (LAHCorrector c in _correctors) {
        c(self, error);
    }
}

- (void)checkFinishing{
    if (_downloadings.count + _seekings.count == 0) {
        __block LAHOperation *bSelf = self;
        for (LAHCompletion completion in _completions) {
            completion(bSelf);
        }
        if (_delegate && [_delegate respondsToSelector:@selector(operation:didFetch:)]) {
            [_delegate operation:self didFetch:_construct.container];
        }
    }
}

#pragma mark - Getter
- (id)container{
    return _construct.container;
}

- (NSString *)absolutePathWith:(NSString *)subpath{
    NSString *protocol = @"http://";
    if ([subpath hasPrefix:protocol]) {
        return subpath;
    }else{
        NSString *host = self.hostName;
        NSString *path = [protocol stringByAppendingString:[host stringByAppendingPathComponent:subpath]];
        return path;
    }
    return nil;
}

- (NSString *)hostName{
    if (_delegate && [_delegate respondsToSelector:@selector(operationNeedsHostName:)]) {
        NSString *host = [_delegate operationNeedsHostName:self];
        return host;
    }
    return nil;
}

#pragma mark - Log
- (NSString *)infoProperties{
    NSMutableString *info = [NSMutableString string];
    if (_link) [info appendFormat:@"path=%@", _link];
    return info;
}

- (NSString *)infoChildren:(NSUInteger)degree{
    NSMutableString *info = [NSMutableString string];
    
    [info appendString:[_construct info:degree]];
    [info appendString:[super infoChildren:degree]];
    
    return info;
}

@end
