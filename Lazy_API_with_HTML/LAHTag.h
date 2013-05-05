//
//  LAHRecognizer.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"
#import "LAHInterface.h"

@class LAHString;
@interface LAHTag : LAHNode {
    NSArray *_indexes;
    NSMutableSet *_attributes;
    
    NSSet *_indexOf;
    
    BOOL _isDemocratic;

    
    LAHRule _rule;

    
    //NSDictionary *_attributes;
    //BOOL _isTextNode;
    //NSRange _range;
    
    //States
    //BOOL _isIdentifier;
    //NSUInteger _numberOfMatched;
    //LAHEle _matchingElement;
    
    //Events handlers
    //NSArray *_fetchers;
    //NSArray *_downloaders;
}
@property(nonatomic, copy)LAHRule rule;
@property(nonatomic, assign)BOOL isDemocratic;
@property(nonatomic, retain)NSArray *indexes;
@property(nonatomic, retain)NSMutableSet *attributes;
@property(nonatomic, retain)NSSet *indexOf;

- (BOOL)handleElement:(LAHEle)element atIndex:(NSInteger)index;


//@property(nonatomic, assign)BOOL isTextNode;
//@property(nonatomic, assign)NSRange range;

//@property(nonatomic, assign)BOOL isIdentifier;
//@property(nonatomic, readonly)NSUInteger numberOfMatched;
//@property(nonatomic, readonly)NSUInteger numberInRange; //Elements in range, must be matched first.
//@property(nonatomic, assign)LAHEle matchingElement;


//@property(nonatomic, retain)NSArray *fetchers;
//@property(nonatomic, retain)NSArray *downloaders;

//- (id)initWithFirstFetcher:(LAHString *)firstFetcher variadicFetchers:(va_list)fetchers;
//- (id)initWithFetchers:(LAHString *)firstFetcher, ... NS_REQUIRES_NIL_TERMINATION;

//- (void)setTagName:(NSString *)tagName;
//- (void)setText:(NSString *)text;
//- (void)setKey:(NSString *)key firstValue:(NSString *)firstValue variadicValues:(va_list)values;
//- (void)setKey:(NSString *)key attributes:(NSString *)firstValue, ... NS_REQUIRES_NIL_TERMINATION;

//- (BOOL)isElementMatched:(LAHEle)element;

//- (void)refreshState;

#pragma mark - Interpreter
//- (void)addFetcher:(LAHString *)fetcher;
//- (void)addDownloader:(LAHPage *)downloader;
//- (void)addAttributes:(NSSet *)attributes withKey:(NSString *)key;
@end