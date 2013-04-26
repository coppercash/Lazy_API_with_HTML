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
    LAHConstruct *_construct;
    
    NSMutableDictionary *_downloadings;
    NSMutableArray *_seekings;
    NSMutableArray *_networks;

    id<LAHDelegate> _delegate;
    NSMutableArray *_completions;
    NSMutableArray *_correctors;
}
@property(nonatomic, retain)LAHConstruct *construct;
@property(nonatomic, assign)id<LAHDelegate> delegate;
@property(nonatomic, readonly)id container;

- (id)initWithPath:(NSString*)path construct:(LAHConstruct*)rootContainer firstChild:(LAHRecognizer*)firstChild variadicChildren:(va_list)children;
- (id)initWithPath:(NSString*)path construct:(LAHConstruct*)rootContainer children:(LAHRecognizer*)firstChild, ... NS_REQUIRES_NIL_TERMINATION;

#pragma mark - Event
- (void)start;
- (void)addCompletion:(LAHCompletion)completion;
- (void)addCorrector:(LAHCorrector)corrector;

#pragma mark - Queue
- (void)saveDownloader:(LAHDownloader*)downloader forKey:(id)key;
- (void)awakeDownloaderForKey:(id)key withElement:(LAHEle)element;
- (void)handleError:(NSError*)error withKey:(id)key;

#pragma mark - Network
- (void)addNetwork:(id)object;
- (void)cancel;

#pragma mark - Info
- (NSString *)absolutePathWith:(NSString *)subpath;

@end

