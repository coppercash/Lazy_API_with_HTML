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
    NSString *_symbol;
}
@property(nonatomic, copy)LAHPropertyFetcher linker;
@property(nonatomic, copy)NSString *symbol;
- (id)initWithLinker:(LAHPropertyFetcher)linker firstChild:(LAHNode*)firstChild variadicChildren:(va_list)children;
- (id)initWithLinker:(LAHPropertyFetcher)linker children:(LAHNode*)firstChild, ... NS_REQUIRES_NIL_TERMINATION;

- (LAHOperation*)recursiveOperation;

- (void)download:(id<LAHHTMLElement>)element;
- (void)seekWithRoot:(id<LAHHTMLElement>)element;

@end