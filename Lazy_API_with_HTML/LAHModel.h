//
//  LAHConstruct.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"

@interface LAHModel : LAHNode {
    
    NSString *_key;
    
    BOOL _needUpdate;
    
    NSInteger _index;
    
    NSMutableDictionary *_states;
}
@property(nonatomic, copy)NSString *key;
@property(nonatomic, assign)BOOL needUpdate;
@property(nonatomic, assign)NSInteger index;
@property(nonatomic, readonly)id data;
@property(nonatomic, retain)NSMutableDictionary* states;
@property(nonatomic, readonly)NSString *identifier;

- (void)refresh;
- (void)saveStateForKey:(id)key;
- (void)restoreStateForKey:(id)key;
- (void)recieve:(LAHModel*)object;

@end

extern NSString * const gKeyContainer;
extern NSString * const gKeyNeedUpdate;
extern NSString * const gKeyIndex;

