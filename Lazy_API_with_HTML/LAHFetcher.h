//
//  LAHFetcher.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHConstruct.h"
#import "LAHProtocols.h"

@interface LAHFetcher : LAHConstruct <NSCopying> {
    LAHPropertyFetcher _fetcher;
    NSString *_property;
    NSString *_symbol;
}
@property(nonatomic, copy)LAHPropertyFetcher fetcher;
@property(nonatomic, copy)NSString *symbol;
- (id)initWithFetcher:(LAHPropertyFetcher)property;
- (id)initWithSymbol:(NSString *)symbol;
- (void)fetchProperty:(id<LAHHTMLElement>)element;
@end
