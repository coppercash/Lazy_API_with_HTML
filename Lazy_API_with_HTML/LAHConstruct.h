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
    LAHRecognizer *_indexSource;
    NSUInteger _count;  //times of newValue being called
}
@property(nonatomic, assign)LAHConstructType type;
@property(nonatomic, copy)NSString *key;
@property(nonatomic, assign)LAHRecognizer *indexSource;
@property(nonatomic, readonly)NSUInteger count;
@property(nonatomic, readonly)NSUInteger index;
@property(nonatomic, readonly)id container;

- (id)initWithKey:(NSString*)key children:(LAHNode *)firstChild, ... NS_REQUIRES_NIL_TERMINATION;
- (id)recieveObject:(LAHConstruct*)object;
- (id)newValue;

@end

@interface LAHDictionary : LAHConstruct {
    NSMutableDictionary *_dictionary;
}
@property(nonatomic, readonly)NSMutableDictionary *dictionary;
@end

@interface LAHArray : LAHConstruct {
    NSMutableArray *_array;
}
@property(nonatomic, readonly)NSMutableArray *array;
@end

#import "LAHProtocols.h"
@interface LAHFetcher : LAHConstruct <NSCopying> {
    LAHPropertyFetcher _fetcher;
    NSString* _property;
}
@property(nonatomic, copy)LAHPropertyFetcher fetcher;
@property(nonatomic, readonly)NSString *property;
- (id)initWithKey:(NSString*)key fetcher:(LAHPropertyFetcher)fetcher;
- (id)initWithFetcher:(LAHPropertyFetcher)property;
- (void)fetchProperty:(id<LAHHTMLElement>)element;
@end