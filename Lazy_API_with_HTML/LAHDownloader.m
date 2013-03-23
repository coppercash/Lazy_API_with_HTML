//
//  LAHDownloader.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHDownloader.h"
#import "LAHOperation.h"
#import "LAHFetcher.h"

@interface LAHDownloader ()
@end

@implementation LAHDownloader
@synthesize linker = _linker, symbol = _symbol, link = _link;
#pragma mark - Life Cycle
- (void)dealloc{
    self.linker = nil;
    self.link = nil;
    self.symbol = nil;
    self.fetchers = nil;
    [super dealloc];
}

#pragma mark - Info
- (NSString *)path{
    return _link;
}

- (NSString *)absolutePath{
    LAHOperation *ope = self.recursiveOperation;
    NSString * abP = [ope absolutePathWith:_link];  //absolute path
    return abP;
}

#pragma mark - Seek
- (void)download:(LAHEle)element{
    if (_linker) {
        self.link = _linker(element);
    }else if (_symbol){
        if ([_symbol isEqualToString:LAHParaTag])  self.link = element.tagName;
        else if ([_symbol isEqualToString:LAHParaText]) self.link = element.text;
        else if ([_symbol isEqualToString:LAHValContent]) self.link = element.content;
        else self.link = [element.attributes objectForKey:_symbol];
    }
    
    if (_link == nil) return;

#ifdef LAH_RULES_DEBUG
    NSMutableString *space = [NSMutableString string];
    for (int i = 0; i < gRecLogDegree; i ++) [space appendString:@"\t"];
    NSMutableString *info = [NSMutableString stringWithFormat:@"%@%@\n%@%@=%@",
                             space, self,
                             space, _symbol, _link];
    printf("\n%s\n", [info cStringUsingEncoding:NSASCIIStringEncoding]);
    
    gRecLogDegree += 1;
#endif
    for (LAHFetcher *f in _fetchers) {
        [f fetchSystemInfo:self];
    }
#ifdef LAH_RULES_DEBUG
    gRecLogDegree -= 1;
#endif
    
    LAHOperation *operation = self.recursiveOperation;
    id<LAHDelegate> delegate = operation.delegate;
    if (delegate && [delegate respondsToSelector:@selector(downloader:needFileAtPath:)]) {
        id key = [delegate downloader:self needFileAtPath:_link];
        [operation saveDownloader:self forKey:key];
    }
}

- (void)seekWithRoot:(LAHEle)element{
    for (LAHRecognizer* node in _children) {
        [node handleElement:element];
    }
    
    for (LAHEle e in element.children) {
        [self seekWithRoot:e];
    }
}

- (LAHOperation*)recursiveOperation{
    LAHRecognizer *father = (LAHRecognizer*)_father;
    LAHOperation* greffier = father.recursiveOperation;
    return greffier;
}

#pragma mark - Interpreter
- (void)addFetcher:(LAHFetcher *)fetcher{
    if (_fetchers == nil) [self.fetchers = [[NSMutableArray alloc] init] release];
    [(NSMutableArray *)_fetchers addObject:fetcher];
}

#pragma mark - Log
- (NSString *)infoProperties{
    NSMutableString *info = [NSMutableString string];
    if (_symbol) [info appendFormat:@"sym=%@, ", _symbol];
    return info;
}

@end
