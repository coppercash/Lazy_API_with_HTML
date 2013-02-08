//
//  LAHGreffier.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LAHDownloader.h"
@protocol LAHDataSource, LAHDelegate;
@class LAHContainer;
@interface LAHOperation : LAHDownloader {
    NSMutableDictionary *_theDownloading;
    NSMutableArray *_theFetching;

    LAHContainer *_rootContainer;
    
    id<LAHDelegate> _delegate;
    NSMutableArray *_completions;
}
//@property(nonatomic, retain)LAHContainer *rootContainer;
@property(nonatomic, assign)id<LAHDelegate> delegate;

- (id)initWithPath:(NSString*)path rootContainer:(LAHContainer*)rootContainer firstChild:(LAHNode*)firstChild variadicChildren:(va_list)children;
- (id)initWithPath:(NSString*)path rootContainer:(LAHContainer*)rootContainer children:(LAHNode*)firstChild, ... NS_REQUIRES_NIL_TERMINATION;

- (void)saveDownloader:(LAHDownloader*)downloader forKey:(id)key;
- (void)awakeDownloaderForKey:(id)key withElement:(id<LAHHTMLElement>)element;

- (void)addFetcher:(LAHDownloader*)fetcher;
- (void)removeFetcher:(LAHDownloader*)fetcher;

- (void)start;
- (void)addCompletion:(LAHCompletion)completion;
- (id)container;
@end

