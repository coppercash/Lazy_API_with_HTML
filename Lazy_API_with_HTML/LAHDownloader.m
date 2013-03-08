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
    [_linker release]; _linker = nil;
    [super dealloc];
}

#pragma mark - Seek
- (void)download:(LAHEle)element{
    NSString *link = nil;
    if (_linker) {
        link = _linker(element);
    }else if (_symbol){
        if ([_symbol isEqualToString:LAH_TagName])  link = element.tagName;
        else if ([_symbol isEqualToString:LAH_Text]) link = element.text;
        else link = [element.attributes objectForKey:_symbol];
    }else{
        return;
    }
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

@end
