//
//  LAHModelsGroup.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 4/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LAHOperation;
@interface LAHModelsGroup : NSObject{
    NSArray *_operations;
    NSDictionary *_containerCache;
}
@property(nonatomic, retain)NSArray *operations;
#pragma mark - Cache
@property(nonatomic, retain)NSDictionary *containerCache;
- (void)cacheContainerWithCommand:(NSString *)command;

#pragma mark - Class Basic
- (id)initWithCommand:(NSString *)command key:(NSString *)key;
#pragma mark - Operations
- (void)setupOperationWithKey:(NSString *)key;
- (LAHOperation *)operationAtIndex:(NSInteger)index;
@end
