//
//  LAHManager.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/8/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHOperation.h"
@class LAHOperation, LAHModel, LAHTag;
@protocol LAHManagerDelegate;
@interface LAHManager : NSObject <LAHDelegate>{
    NSMutableArray* _operations;
    id<LAHManagerDelegate> _delegate;
}
@property(nonatomic, readonly)NSMutableArray *operations;
@property(nonatomic, assign)id<LAHManagerDelegate> delegate;

#pragma mark - Operation
- (LAHOperation *)operationWithPath:(NSString *)path rootContainer:(LAHModel *)rootContainer children:(LAHTag*)firstChild, ... NS_REQUIRES_NIL_TERMINATION;
- (LAHOperation *)operationWithFile:(NSString *)path key:(NSString *)key dictionary:(NSMutableDictionary *)dictionary;
- (LAHOperation *)operationWithFile:(NSString *)path key:(NSString *)key;

#pragma mark - Operations Management
- (void)cancel;

#pragma mark - Info
- (NSUInteger)numberOfOperations;

@end

@protocol LAHManagerDelegate <NSObject>
- (void)managerStartRunning:(LAHManager *)manager;
- (void)managerStopRunnning:(LAHManager *)manager finish:(BOOL)finish;
@end