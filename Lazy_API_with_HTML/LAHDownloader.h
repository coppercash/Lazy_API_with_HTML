//
//  LAHDownloader.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHProtocols.h"
#import "LAHRecognizer.h"
@interface LAHDownloader : LAHNode {
    LAHPropertyFetcher _linker;
}
@property(nonatomic, copy)LAHPropertyFetcher linker;
- (id)initWithLinker:(LAHPropertyFetcher)linker firstChild:(LAHNode*)firstChild variadicChildren:(va_list)children;
- (id)initWithLinker:(LAHPropertyFetcher)linker children:(LAHNode*)firstChild, ... NS_REQUIRES_NIL_TERMINATION;

- (void)saveStateForKey:(id)key;
- (void)restoreStateForKey:(id)key;
- (LAHOperation*)recursiveOperation;

- (void)download:(id<LAHHTMLElement>)element;
- (void)seekWithRoot:(id<LAHHTMLElement>)element;

@end