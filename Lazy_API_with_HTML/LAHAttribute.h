//
//  LAHAttribute.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 4/27/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"

@class LAHTag;

@interface LAHAttribute : LAHNode{
    NSString *_name;
    
    NSSet *_legalValues;
    NSSet *_getters;
    
    NSString *_methodName;
    NSArray *_args;
    
    NSString *_cache;
    
}
@property(nonatomic, copy)NSString *name;

@property(nonatomic, retain)NSSet *legalValues;
@property(nonatomic, retain)NSSet *getters;
@property(nonatomic, copy)NSString *cache;

@property(nonatomic, copy)NSString *methodName;
@property(nonatomic, retain)NSArray *args;

@property(nonatomic, assign)LAHTag *tag;

@property(nonatomic, readonly)BOOL isMatched;

- (void)cacheValueWithElement:(LAHEle)element;
- (void)fetch;

- (NSString *)desc;

+ (NSDictionary *)methods;

@end
