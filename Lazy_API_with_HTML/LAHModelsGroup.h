//
//  LAHModelsGroup.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 4/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LAHOperation.h"

@interface LAHModelsGroup : NSObject <LAHDelegate> {
    NSArray *_operations;
    NSDictionary *_containerCache;
    NSInteger _currentIndex;
}
@property(nonatomic, retain)NSArray *operations;
@property(nonatomic, readonly)LAHOperation *operation;
#pragma mark - Class Basic
- (id)initWithCommand:(NSString *)command key:(NSString *)key;
#pragma mark - Operations
- (LAHOperation *)operationAtIndex:(NSInteger)index;
#pragma mark - Push & Pop
- (void)pushWithLink:(NSString *)link;
- (void)popNumberOfDegree:(NSUInteger)number;
- (void)pop;
@end
