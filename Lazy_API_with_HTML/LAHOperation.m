//
//  LAHGreffier.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHOperation.h"
#import "LAHPage.h"
#import "LAHModel.h"
#import "LAHCategories.h"
#import "LAHNote.h"

@interface LAHOperation ()
//Pages in States
@property(nonatomic, retain)NSMutableDictionary *downloadings;
@property(nonatomic, retain)NSMutableArray *seekings;
@property(nonatomic, retain)NSMutableArray *networks;
//Delegate & Call back
@property(nonatomic, retain)NSMutableArray *completions;
@property(nonatomic, retain)NSMutableArray *correctors;
- (void)checkFinishing;
@end

@implementation LAHOperation
@synthesize model = _model, page = _page;
@synthesize downloadings = _downloadings, seekings = _seekings, networks = _networks;
@synthesize delegate = _delegate, completions = _completions, correctors = _correctors;
@dynamic data;
@dynamic hostName;

#pragma mark - Class Basic
- (id)initWithModel:(LAHModel *)model page:(LAHPage *)page{
    self = [super init];
    if (self) {
        self.model = model;
        self.page = page;
    }
    return self;
}

- (void)dealloc{
    
    self.model = nil;
    self.page = nil;
    
    self.downloadings = nil;
    self.seekings = nil;
    self.networks = nil;
    
    self.delegate = nil;
    self.completions = nil;
    self.correctors = nil;
    
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone{
    LAHOperation *copy = [super copyWithZone:zone];
    
    copy.model = [_model copy];
    copy.model.father = copy;
    
    if (_downloadings) copy.downloadings = [[NSMutableDictionary alloc] initWithDictionary:_downloadings copyItems:YES];
    if (_seekings) copy.seekings = [[NSMutableArray alloc] initWithArray:_seekings copyItems:YES];
    if (_networks) copy.networks = [[NSMutableArray alloc] initWithArray:_networks copyItems:YES];
    
    copy.delegate = _delegate;
    if (_completions) copy.completions = [[NSMutableArray alloc] initWithArray:_completions copyItems:YES];
    if (_correctors) copy.correctors = [[NSMutableArray alloc] initWithArray:_correctors copyItems:YES];
    
    [copy.model release];
    [copy.downloadings release];
    [copy.completions release];
    [copy.correctors release];
    
    return copy;
}

#pragma mark = Setters
- (void)setPage:(LAHPage *)page{
    [_page release];
    _page = [page retain];
    page.father = self;
}

- (void)setModel:(LAHModel *)model{
    [_model release];
    _model = [model retain];
    model.father = self;
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

- (id)data{
    return _model.data;
}

- (NSArray *)children{
    NSArray *children = [NSArray arrayWithObjects:_model, _page, nil];
    return children;
}

#pragma mark - Status
- (void)refresh{
    [self cancelNetwork];
    [_model refresh];
    [_page refresh];
    [_downloadings removeAllObjects];
    [_seekings removeAllObjects];
    [_completions removeAllObjects];
    [_correctors removeAllObjects];
}

#pragma mark - Fake
- (LAHOperation *)recursiveOperation{
    return self;
}

- (void)recieve:(LAHModel *)model{
    
}

- (BOOL)needUpdate{
    return NO;
}

#pragma mark - Queue
- (void)freezePage:(LAHPage *)page forKey:(id)key{
    
    NSMutableArray *pages = [_downloadings objectForKey:key];
    if (pages) {    //If pages with same key exits, they will be dowloaded only once
        
        [pages addObject:page];
    
    } else {    //Doesn't exit yet, create a array to keep it
        
        pages = [[NSMutableArray alloc] initWithObjects:page, nil];
        [self.downloadings setObject:pages forKey:key];
    
    }

    [_model saveStateForKey:key];
    [_page saveStateForKey:key];
}

- (void)awakePageForKey:(id)key withElement:(LAHEle)element{
    
    NSArray *pages = [_downloadings objectForKey:key];
    NSAssert(pages != nil, @"Can't get pages for key:%@", key);
    
    for (LAHPage *page in pages) {
        
        [_model restoreStateForKey:key];
        [_page restoreStateForKey:key];
        
        //Seek the pages, and when they being seeked mark them
#ifdef LAH_RULES_DEBUG
        [LAHNote openNote:@"%@", page];
#endif
        [self.seekings addObject:page];
        [page seekWithElement:element];
        [_seekings removeObject:page];

#ifdef LAH_RULES_DEBUG
        [LAHNote closeNote];
#endif
    }
    
    [_downloadings removeObjectForKey:key];
    
    [self checkFinishing];

}

#pragma mark - Network
- (void)downloadPage:(LAHPage *)page{
    NSAssert(_delegate != nil, @"Can't download without download delegate.");
    NSAssert(page.link != nil, @"Can't download without LAHPage or link of it.");
    if (!page.link) return;
    
    if (_delegate && [_delegate respondsToSelector:@selector(operation:needPageAtLink:)]) {
        id key = [_delegate operation:self needPageAtLink:page.link];
        [self freezePage:page forKey:key];
    }
}

- (void)addNetwork:(id)network{
    [_networks addObject:network];
}

- (void)cancelNetwork{
    if (_delegate && [_delegate respondsToSelector:@selector(operation:willCancelNetworks:)]) {
        [_delegate operation:self willCancelNetworks:_networks];
    }
    [_networks removeAllObjects];
}

#pragma mark - Event
- (void)start{
#ifdef LAH_RULES_DEBUG
    [LAHNote openNote:@"%@", self];
#endif
    
    [_page fetchValue:nil];
}

- (void)cancel{
    [self cancelNetwork];
}

- (void)addCompletion:(LAHCompletion)completion{
    LAHCompletion copy = [completion copy];
    [self.completions addObject:copy];
    [copy release];
}

- (void)addCorrector:(LAHCorrector)corrector{
    LAHCompletion copy = [corrector copy];
    [self.correctors addObject:copy];
    [copy release];
}

- (void)handleError:(NSError*)error withKey:(id)key{
    [self cancelNetwork];

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
    
#ifdef LAH_RULES_DEBUG
        [LAHNote logWisely];
#endif
    }
}

#pragma mark - Delegate Info
- (NSString *)urlStringWith:(NSString *)relativeLink{
    NSString *protocol = @"http://";
    if ([relativeLink hasPrefix:protocol]) {
        return relativeLink;
    }else{
        NSString *host = self.hostName;
        NSString *path = [protocol stringByAppendingString:[host stringByAppendingPathComponent:relativeLink]];
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

- (LAHAttrMethod)methodWithName:(NSString *)name{
    if (_delegate && [_delegate respondsToSelector:@selector(operation:needsMethodNamed:)]) {
        LAHAttrMethod method = [_delegate operation:self needsMethodNamed:name];
        return method;
    }
    return nil;
}

#pragma mark - Log
- (NSString *)tagNameInfo{
    return @"ope";
}

- (NSString *)attributesInfo{
    NSMutableString *info = [NSMutableString stringWithString:[super attributesInfo]];
    if (_model) [info appendFormat:@"  model=%@", _model.des];
    if (_page) [info appendFormat:@"  page=%@", _page.des];
    return info;
}

@end
