//
//  LAHNode.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LAHOperation;
@interface LAHNode : NSObject <NSCopying> {
    LAHNode *_father;
    NSArray *_children;
}
@property(nonatomic, assign)LAHNode *father;
@property(nonatomic, retain)NSArray *children;
@property(nonatomic, readonly)LAHOperation *recursiveOperation;

#pragma mark - Status
- (void)refresh;

#pragma mark - Log
@property(nonatomic, readonly)NSUInteger degree;
@property(nonatomic, readonly)NSString *degreeSpace;
- (NSString *)des;
- (NSString *)debugLog:(NSUInteger)degree;
- (NSString *)tagNameInfo;
- (NSString *)attributesInfo;

#pragma mark - Init
- (id)initWithFirstChild:(LAHNode*)firstChild variadicChildren:(va_list)children;
- (id)initWithChildren:(LAHNode*)firstChild, ... NS_REQUIRES_NIL_TERMINATION;
@end
