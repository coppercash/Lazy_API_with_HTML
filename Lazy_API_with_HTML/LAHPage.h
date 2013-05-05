//
//  LAHDownloader.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"

@interface LAHPage : LAHNode <LAHFetcher> {
    NSString *_link;
    NSMutableSet *_attributes;
}
@property(nonatomic, copy)NSString *link;
@property(nonatomic, retain)NSMutableSet *attributes;

@property(nonatomic, readonly)LAHOperation *recursiveOperation;
@property(nonatomic, readonly)NSString *identifier;
@property(nonatomic, readonly)NSString *hostName;
@property(nonatomic, readonly)NSString *urlString;

- (void)download;
- (void)seekWithElement:(LAHEle)element;

#pragma mark - Interpreter
//- (void)addFetcher:(LAHString *)fetcher;

@end