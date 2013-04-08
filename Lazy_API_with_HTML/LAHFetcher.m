//
//  LAHFetcher.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHFetcher.h"
#import "LAHRecognizer.h"
#import "LAHDownloader.h"

@interface LAHFetcher ()
@property(nonatomic, copy)NSString *property;
- (void)doFetch;
@end

@implementation LAHFetcher
@synthesize fetcher = _fetcher, property = _property, symbol = _symbol;
#pragma mark - Life Cycle

- (id)init{
    self = [super init];
    if (self) {
        self.type = LAHConstructTypeFetcher;
    }
    return self;
}

- (id)initWithFetcher:(LAHPropertyFetcher)property{
    self = [self init];
    if (self) {
        self.fetcher = property;
    }
    return self;
}

- (id)initWithSymbol:(NSString *)symbol{
    self = [self init];
    if (self) {
        self.symbol = symbol;
    }
    return self;
}

- (void)dealloc{
    self.fetcher = nil;
    self.property = nil;
    self.symbol = nil;
    
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone{
    LAHFetcher *copy = [super copyWithZone:zone];
    
    copy.fetcher = _fetcher;
    copy.symbol = _symbol;
    copy.property = _property;
    
    return copy;
}

#pragma mark - Element
- (void)fetchProperty:(LAHEle)element{
    if (_fetcher) {
        self.property = _fetcher(element);
    }else if (_symbol){
        if ([_symbol isEqualToString:LAHValTag])  self.property = element.tagName;
        else if ([_symbol isEqualToString:LAHValText]) self.property = element.text;
        else if ([_symbol isEqualToString:LAHValContent]) self.property = element.content;
        else self.property = [element.attributes objectForKey:_symbol];
    }else{
        return;
    }
    [self doFetch];
}

- (void)fetchSystemInfo:(LAHNode *)node{
    if ([_symbol isEqualToString:LAHValPath]) {
        LAHDownloader *downloader = (LAHDownloader *)node;
        self.property = downloader.link;
    }else if ([_symbol isEqualToString:LAHValURL]) {
        LAHDownloader *downloader = (LAHDownloader *)node;
        self.property = downloader.absolutePath;
    }else if ([_symbol isEqualToString:LAHValHost]) {
        LAHDownloader *downloader = (LAHDownloader *)node;
        self.property = downloader.hostName;
    }
    [self doFetch];
}

- (void)doFetch{
#ifdef LAH_RULES_DEBUG
    NSMutableString *space = [NSMutableString string];
    for (int i = 0; i < gRecLogDegree; i ++) [space appendString:@"\t"];
    NSMutableString *info = [NSMutableString stringWithFormat:@"%@%@\n%@%@=%@",
                             space, self,
                             space, _symbol, _property];
    printf("\n%s\n", [info cStringUsingEncoding:NSASCIIStringEncoding]);
#endif
    if (_property == nil) return;
    
    LAHConstruct *father = (LAHConstruct *)_father;
    [father checkUpate:self];
    [father recieve:self];
}

- (id)container{
    return _property;
}

- (id)newValue{
    if (_property == nil) return [NSNull null];
    return _property;
}

#pragma mark - Interpreter
- (NSString *)infoProperties{
    NSMutableString *info = [NSMutableString string];
    if (_symbol) [info appendFormat:@"sym=%@, ", _symbol];
    if (_fetcher) [info appendFormat:@"fet=%@, ", _fetcher];
    [info appendString:[super infoProperties]];
    
    return info;
}

@end

