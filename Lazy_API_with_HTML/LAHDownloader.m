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
@synthesize linker = _linker, symbol = _symbol;
#pragma mark - Life Cycle
- (void)dealloc{
    self.linker = nil;
    self.symbol = nil;
    [super dealloc];
}

#pragma mark - Seek
- (void)download:(LAHEle)element{
    NSString *link = nil;
    if (_linker) {
        link = _linker(element);
    }else if (_symbol){
        if ([_symbol isEqualToString:LAHParaTag])  link = element.tagName;
        else if ([_symbol isEqualToString:LAHParaText]) link = element.text;
        else if ([_symbol isEqualToString:LAHValContent]) link = element.content;
        else link = [element.attributes objectForKey:_symbol];
    }else{
        return;
    }
    
#ifdef LAH_RULES_DEBUG
    NSMutableString *space = [NSMutableString string];
    for (int i = 0; i < gRecLogDegree; i ++) [space appendString:@"\t"];
    NSMutableString *info = [NSMutableString stringWithFormat:@"%@%@\n%@%@=%@",
                             space, self,
                             space, _symbol, link];
    printf("\n%s\n", [info cStringUsingEncoding:NSASCIIStringEncoding]);
#endif
    
    if (link == nil) return;

    LAHOperation *operation = self.recursiveOperation;
    id<LAHDelegate> delegate = operation.delegate;
    if (delegate && [delegate respondsToSelector:@selector(downloader:needFileAtPath:)]) {
        id key = [delegate downloader:self needFileAtPath:link];
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

#pragma mark - Log
- (NSString *)infoProperties{
    NSMutableString *info = [NSMutableString string];
    if (_symbol) [info appendFormat:@"sym=%@, ", _symbol];
    return info;
}

@end
