//
//  LAHDownloader.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHFetcher.h"
@interface LAHDownloader : LAHFetcher
- (id)initWithProperty:(LAHPropertyGetter)property firstChild:(LAHNode*)firstChild variadicChildren:(va_list)children;
- (id)initWithProperty:(LAHPropertyGetter)property children:(LAHNode*)firstChild, ... NS_REQUIRES_NIL_TERMINATION;
- (void)fetchWithRoot:(id<LAHHTMLElement>)element;
//- (void)continueHandlingElement:(id<LAHHTMLElement>)element;
@end