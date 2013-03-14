//
//  LAHRecognizer.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"
#import "LAHInterface.h"

@class LAHFetcher;
@interface LAHRecognizer : LAHNode {
    NSDictionary *_attributes;
    LAHRule _rule;
    BOOL _isTextNode;
    NSRange _range;
    
    //States
    BOOL _isIndex;
    NSUInteger _numberOfMatched;
    LAHEle _matchingElement;
    
    //Even handlers
    NSArray *_fetchers;
    NSArray *_downloaders;
}
@property(nonatomic, retain)NSDictionary *attributes;
@property(nonatomic, copy)LAHRule rule;
@property(nonatomic, assign)BOOL isTextNode;
@property(nonatomic, assign)NSRange range;
@property(nonatomic, assign)NSUInteger index;

@property(nonatomic, assign)BOOL isIndex;
@property(nonatomic, readonly)NSUInteger numberOfMatched;
@property(nonatomic, readonly)NSUInteger numberInRange; //Elements in range, must be matched first.
@property(nonatomic, readonly)LAHEle matchingElement;

@property(nonatomic, retain)NSArray *fetchers;
@property(nonatomic, retain)NSArray *downloaders;

- (id)initWithFirstFetcher:(LAHFetcher *)firstFetcher variadicFetchers:(va_list)fetchers;
- (id)initWithFetchers:(LAHFetcher *)firstFetcher, ... NS_REQUIRES_NIL_TERMINATION;

- (void)setTagName:(NSString *)tagName;
- (void)setText:(NSString *)text;
- (void)setKey:(NSString *)key firstValue:(NSString *)firstValue variadicValues:(va_list)values;
- (void)setKey:(NSString *)key attributes:(NSString *)firstValue, ... NS_REQUIRES_NIL_TERMINATION;

- (BOOL)handleElement:(LAHEle)element;
- (BOOL)isElementMatched:(LAHEle)element;

- (LAHOperation*)recursiveOperation;
- (void)refreshState;

#pragma mark - Interpreter
- (void)addFetcher:(LAHFetcher *)fetcher;
- (void)addDownloader:(LAHDownloader *)downloader;
- (void)addAttributes:(NSSet *)attributes withKey:(NSString *)key;
@end