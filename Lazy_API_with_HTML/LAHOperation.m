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

#pragma mark - Copy
- (id)copy{
    NSMutableDictionary *table = [[NSMutableDictionary alloc] init];
    
    LAHOperation *copy = [self copyVia:table];
    
    [table release];

    return copy;
}

- (id)copyVia:(NSMutableDictionary *)table{
    LAHOperation *copy = [[[self class] alloc] init];
    
    copy.model = [_model copyVia:table];
    [copy.model release];
    
    copy.page = [_page copyVia:table];
    [copy.page release];
    
    copy.delegate = _delegate;
    
    copy.completions = [[NSMutableArray alloc] initWithArray:_completions copyItems:YES];
    [copy.completions release];
    
    copy.correctors = [[NSMutableArray alloc] initWithArray:_correctors copyItems:YES];
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
        self.downloadings[key] = pages;
        [pages release];
    }

    [_model saveStateForKey:key];
}

- (void)awakePageForKey:(id)key withElement:(LAHEle)element{
    
    NSArray *pages = [_downloadings objectForKey:key];
    NSAssert(pages != nil, @"Can't get pages for key:%@", key);
    
    for (LAHPage *page in pages) {
        
        [_model restoreStateForKey:key];
        
        //Seek the pages, and when they being seeked mark them
        LAHNoteOpen(@"%@", page);
        
        [self.seekings addObject:page];
        [page seekWithElement:element];
        [_seekings removeObject:page];
        
        LAHNoteClose;
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
        NSDictionary *returnDic = [_delegate operation:self needPageAtLink:page.link];
        id netOpe = returnDic[LAHKeyRetNetOpe];
        NSString *url = returnDic[LAHKeyRetURL];
        NSAssert(returnDic && netOpe && url, @"Can't download page returnDic:%@ netOpe:%@ url:%@", returnDic, netOpe, url);
        
        [self addNetwork:netOpe];
        [self freezePage:page forKey:url];
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
    LAHNoteOpen(@"%@", self);
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
        LAHNoteLogWisely;
        //LAHNoteLogAllAndClean;
        
        __block LAHOperation *bSelf = self;
        for (LAHCompletion completion in _completions) {
            completion(bSelf);
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(operationFinished:)]) {
            [_delegate operationFinished:self];
        }
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
    if (_model) [info appendFormat:@"  model=%@", _model.desc];
    if (_page) [info appendFormat:@"  page=%@", _page.desc];
    return info;
}

@end
