//
//  LAHManager.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/8/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHOperation.h"
@class LAHOperation, LAHConstruct, LAHRecognizer;
@protocol LAHManagerDelegate;
@interface LAHManager : NSObject <LAHDelegate>{
    NSMutableArray* _operations;
    id<LAHManagerDelegate> _delegate;
}
@property(nonatomic, readonly)NSMutableArray *operations;
@property(nonatomic, assign)id<LAHManagerDelegate> delegate;
- (LAHOperation*)operationWithPath:(NSString*)path rootContainer:(LAHConstruct*)rootContainer firstChild:(LAHRecognizer*)firstChild variadicChildren:(va_list)children;
- (LAHOperation*)operationWithPath:(NSString*)path rootContainer:(LAHConstruct*)rootContainer children:(LAHRecognizer*)firstChild, ... NS_REQUIRES_NIL_TERMINATION;
- (LAHOperation *)operationWithFile:(NSString *)path key:(NSString *)key;
- (LAHOperation *)operationWithFile:(NSString *)path key:(NSString *)key dictionary:(NSMutableDictionary *)dictionary;

- (NSUInteger)numberOfOperations;
- (void)cancel;

@end

@protocol LAHManagerDelegate <NSObject>
- (void)managerStartRunning:(LAHManager *)manager;
- (void)managerStopRunnning:(LAHManager *)manager finish:(BOOL)finish;
@end