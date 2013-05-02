//
//  LAHFrame.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 5/2/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LAHNode;
@class LAHStmtValue;

@interface LAHFrame : NSObject {
    NSMutableArray *_toRefer;
    NSMutableDictionary *_references;
    LAHFrame *_father;
}
@property(nonatomic, retain)NSMutableArray *toRefer;
@property(nonatomic, retain)NSMutableDictionary *references;
@property(nonatomic, assign)LAHFrame *father;
#pragma mark - Class Basic
- (id)initWithDictionary:(NSMutableDictionary *)container;
#pragma mark - Reference
- (void)referObject:(LAHNode *)entity toKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
#pragma mark - Error
- (void)error:(NSString *)message;
- (void)object:(NSString *)object expect:(NSString *)expect butFind:(NSString *)find;
- (BOOL)object:(NSString *)object accept:(NSArray *)types find:(NSObject *)find strict:(BOOL)strict;
- (BOOL)object:(NSString *)object accept:(NSArray *)types find:(NSObject *)find;
- (void)attribute:(NSString *)attr ofEntity:(LAHNode *)entity expect:(NSArray *)types find:(LAHStmtValue *)find;

@end

