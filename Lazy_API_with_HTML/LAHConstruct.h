//
//  LAHConstruct.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"
#import "LAHInterface.h"

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
    NSArray *_identifiers;
    
    id _lastFatherContainer;
    LAHEle _lastIdentifierElement;
}
@property(nonatomic, assign)LAHConstructType type;
@property(nonatomic, copy)NSString *key;
@property(nonatomic, retain)NSArray *identifiers;
@property(nonatomic, readonly)id container;

- (BOOL)isIdentifierElementChanged;
- (LAHEle)currentIdentifierElement;

- (BOOL)checkUpate:(LAHConstruct *)object;
- (void)update;
- (void)recieve:(LAHConstruct*)object;
@end

extern NSString * const gKeyLastFatherContainer;
extern NSString * const gKeyLastIdentifierElement;
extern NSString * const gKeyContainer;

