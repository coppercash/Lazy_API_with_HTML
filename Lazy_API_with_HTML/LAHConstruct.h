//
//  LAHConstruct.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"
#import "LAHProtocols.h"

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
    
    id _lastFather;
    LAHEle _lastElement;
}
@property(nonatomic, assign)LAHConstructType type;
@property(nonatomic, copy)NSString *key;
@property(nonatomic, retain)NSArray *indexes;
@property(nonatomic, readonly)id container;

- (id)initWithKey:(NSString*)key children:(LAHNode *)firstChild, ... NS_REQUIRES_NIL_TERMINATION;
- (BOOL)isIdentifierChanged;
- (LAHEle)currentRecognizer;

- (BOOL)checkUpate:(LAHConstruct *)object;
- (void)recieve:(LAHConstruct*)object;
@end

extern NSString * const gKeyLastFatherContainer;
extern NSString * const gKeyLastIdentifierElement;
extern NSString * const gKeyContainer;

