//
//  LAHDownloader.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHRecognizer.h"

@interface LAHDownloader : LAHNode {
    LAHPropertyFetcher _linker;
    NSString *_link;
    NSString *_symbol;
    NSArray *_fetchers;
}
@property(nonatomic, copy)LAHPropertyFetcher linker;
@property(nonatomic, copy)NSString *symbol;
@property(nonatomic, copy)NSString *link;
@property(nonatomic, retain)NSArray *fetchers;
//@property(nonatomic, readonly, getter = link)NSString *path;
@property(nonatomic, readonly, getter = hostName)NSString *hostName;
@property(nonatomic, readonly, getter = absolutePath)NSString *absolutePath;

- (LAHOperation*)recursiveOperation;
- (void)download:(LAHEle)element;
- (void)seekWithRoot:(LAHEle)element;

#pragma mark - Interpreter
- (void)addFetcher:(LAHFetcher *)fetcher;

@end