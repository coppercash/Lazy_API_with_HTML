//
//  LAHNode.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDTreeNode.h"

@class LAHOperation;
@interface LAHNode : CDTreeNode
@property(nonatomic, readonly)LAHOperation *recursiveOperation;

#pragma mark - Copy
- (id)copyVia:(NSMutableDictionary *)table;

#pragma mark - Log
@property(nonatomic, readonly)NSUInteger degree;
@property(nonatomic, readonly)NSString *degreeSpace;
- (NSString *)desc;
- (NSString *)debugLog:(NSUInteger)degree;
- (NSString *)tagNameInfo;
- (NSString *)attributesInfo;

@end
