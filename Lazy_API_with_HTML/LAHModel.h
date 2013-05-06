//
//  LAHConstruct.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"

@class LAHTag;
@interface LAHModel : LAHNode {
    
    NSString *_key;
    NSArray *_range;
    
    BOOL _needUpdate;
}
@property(nonatomic, copy)NSString *key;
@property(nonatomic, retain)NSArray *range;
@property(nonatomic, assign)BOOL needUpdate;
@property(nonatomic, readonly)id data;

- (void)recieve:(LAHModel*)object;

@end

extern NSString * const gKeyContainer;
extern NSString * const gKeyNeedUpdate;

