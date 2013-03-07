//
//  LAHConstruct.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"

typedef enum {
    LAHConstructTypeAbstract = 0,
    LAHConstructTypeArray,
    LAHConstructTypeDictionary,
    LAHConstructTypeFetcher
}LAHConstructType;

@class LAHRecognizer;
@interface LAHConstruct : LAHNode {
    LAHConstructType _type;
    
    NSString *_key;
    NSArray *_indexes;
}
@property(nonatomic, assign)LAHConstructType type;
@property(nonatomic, copy)NSString *key;
@property(nonatomic, retain)NSArray *indexes;
@property(nonatomic, readonly)id container;

- (id)initWithKey:(NSString*)key children:(LAHNode *)firstChild, ... NS_REQUIRES_NIL_TERMINATION;
- (id)recieveObject:(LAHConstruct*)object;
- (id)newValue;
- (NSUInteger)count;

- (void)saveStateForKey:(id)key;
- (void)restoreStateForKey:(id)key;
@end


