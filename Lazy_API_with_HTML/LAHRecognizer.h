//
//  LAHRecognizer.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"
#import "LAHProtocols.h"

@class LAHFetcher;
@interface LAHRecognizer : LAHNode {
    //Matching inforamtion
    NSString *_tagName;
    NSString *_text;
    NSDictionary *_attributes;
    LAHRule _rule;
    BOOL _isTextNode;
    NSRange _range;
    
    //States
    NSMutableDictionary *_states;
    NSUInteger _numberOfMatched;
    
    //Even handlers
    NSArray *_fetchers;
    NSArray *_downloaders;
}
@property(nonatomic, copy)NSString *tagName;
@property(nonatomic, copy)NSString *text;
@property(nonatomic, retain)NSDictionary *attributes;
@property(nonatomic, copy)LAHRule rule;
@property(nonatomic, assign)BOOL isTextNode;
@property(nonatomic, assign)NSRange range;
@property(nonatomic, assign)NSUInteger numberOfMatched;
@property(nonatomic, retain)NSArray *fetchers;
@property(nonatomic, retain)NSArray *downloaders;

- (id)initWithFirstFetcher:(LAHFetcher *)firstFetcher variadicFetchers:(va_list)fetchers;
- (id)initWithFetchers:(LAHFetcher *)firstFetcher, ... NS_REQUIRES_NIL_TERMINATION;

- (BOOL)handleElement:(id<LAHHTMLElement>)element;
- (BOOL)isElementMatched:(id<LAHHTMLElement>)element;
- (void)setIndex:(NSUInteger)index;

- (LAHOperation*)recursiveGreffier;
- (void)saveStateForKey:(id)key;
- (void)restoreStateForKey:(id)key;
@end