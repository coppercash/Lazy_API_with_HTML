//
//  LAHGreffier.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LAHInterface.h"

@protocol LAHDelegate;
@class LAHModel, LAHPage;

@interface LAHOperation : NSObject {
    
    LAHModel *_model;
    LAHPage *_page;
    
    //Pages in States
    NSMutableDictionary *_downloadings;
    NSMutableArray *_seekings;
    NSMutableArray *_networks;

    //Delegate & Call back
    id<LAHDelegate> _delegate;
    NSMutableArray *_completions;
    NSMutableArray *_correctors;
}
@property(nonatomic, retain)LAHModel *model;
@property(nonatomic, retain)LAHPage *page;
@property(nonatomic, assign)id<LAHDelegate> delegate;
@property(nonatomic, readonly)id data;
@property(nonatomic, readonly)NSString *hostName;

#pragma mark - Class Basic
- (id)initWithModel:(LAHModel *)model page:(LAHPage *)page;

#pragma mark - Event
- (void)start;
- (void)cancel;
- (void)addCompletion:(LAHCompletion)completion;
- (void)addCorrector:(LAHCorrector)corrector;

#pragma mark - Queue
- (void)freezePage:(LAHPage*)page forKey:(id)key;
- (void)awakePageForKey:(id)key withElement:(LAHEle)element;
- (void)handleError:(NSError *)error withKey:(id)key;

#pragma mark - Network
- (void)downloadPage:(LAHPage *)page;
- (void)addNetwork:(id)object;
- (void)cancelNetwork;

#pragma mark - Info
- (NSString *)urlStringWith:(NSString *)relativeLink;

@end

