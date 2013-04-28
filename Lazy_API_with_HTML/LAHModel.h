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

@class LAHTag;
@interface LAHModel : LAHNode {
    LAHConstructType _type;
    
    NSString *_key;
    //NSSet *_identifiers;
    
    //id _lastFatherContainer;
    //LAHEle _lastIdentifierElement;
}
@property(nonatomic, assign)LAHConstructType type;
@property(nonatomic, copy)NSString *key;
//@property(nonatomic, retain)NSSet *identifiers;
@property(nonatomic, readonly)id data;

//- (BOOL)isIdentifierElementChanged;
//- (LAHEle)currentIdentifierElement;

- (BOOL)checkUpate:(LAHModel *)object;
- (void)update;
- (void)recieve:(LAHModel*)object;
#pragma mark - Interpreter
//- (void)addIdentifier:(LAHTag *)identifier;
@end

//extern NSString * const gKeyLastFatherContainer;
//extern NSString * const gKeyLastIdentifierElement;
extern NSString * const gKeyContainer;

