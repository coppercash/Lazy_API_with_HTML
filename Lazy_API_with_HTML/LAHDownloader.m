//
//  LAHDownloader.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHDownloader.h"
#import "LAHGreffier.h"

@implementation LAHDownloader
#pragma mark - Life Cycle
- (void)dealloc{
    [super dealloc];
}

#pragma mark - Recursive
- (void)handleElement:(id<LAHHTMLElement>)element atIndex:(NSUInteger)index{
    if (![self isElementMatched:element atIndex:index]) return;
    if (_propertyGetter == nil) return;
    NSString *info = _propertyGetter(element);
    
    id<LAHDataSource> dataSource = self.greffier.dataSource;
    if (dataSource && [dataSource respondsToSelector:@selector(downloader:needFileAtPath:)]) {
        id key = [dataSource downloader:self needFileAtPath:info];
        [self.greffier setDownloader:self forKey:key];
    }
}

- (void)continueHandlingElement:(id<LAHHTMLElement>)element{
    [self.greffier addFetcher:self];
    [self fetchWithRoot:element];
    [self.greffier removeFetcher:self];
}

- (void)fetchWithRoot:(id<LAHHTMLElement>)element{
    NSArray *fakeChildren = [[NSArray alloc] initWithArray:_children];
    for (LAHNode* node in fakeChildren) {
        [node handleElement:element atIndex:0];
    }
    [fakeChildren release];
    for (id<LAHHTMLElement> e in element.children) {
        [self fetchWithRoot:e];
    }
}

- (LAHGreffier*)recursiveGreffier{
    if (_greffier == nil) _greffier = _father.recursiveGreffier;
    return _greffier;
}

@end
