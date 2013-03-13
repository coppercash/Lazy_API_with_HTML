//
//  LAHGreffier.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHDownloader.h"
@protocol LAHDataSource, LAHDelegate;
@class LAHConstruct;
@interface LAHOperation : LAHDownloader {
    NSMutableDictionary *_theDownloading;
    NSMutableArray *_theSeeking;

    LAHConstruct *_rootContainer;
    NSString *_path;
    
    id<LAHDelegate> _delegate;
    NSMutableArray *_completions;
    NSMutableArray *_correctors;
}
@property(nonatomic, retain)LAHConstruct *rootContainer;
@property(nonatomic, copy)NSString *path;
@property(nonatomic, assign)id<LAHDelegate> delegate;
@property(nonatomic, readonly)id container;

- (id)initWithPath:(NSString*)path rootContainer:(LAHConstruct*)rootContainer firstChild:(LAHRecognizer*)firstChild variadicChildren:(va_list)children;
- (id)initWithPath:(NSString*)path rootContainer:(LAHConstruct*)rootContainer children:(LAHRecognizer*)firstChild, ... NS_REQUIRES_NIL_TERMINATION;

- (void)start;
- (void)handleError:(NSError*)error;
- (void)addCompletion:(LAHCompletion)completion;
- (void)addCorrector:(LAHCorrector)corrector;

- (void)saveDownloader:(LAHDownloader*)downloader forKey:(id)key;
- (void)awakeDownloaderForKey:(id)key withElement:(LAHEle)element;

- (void)addSeeker:(LAHDownloader*)fetcher;
- (void)removeSeeker:(LAHDownloader*)fetcher;

@end

