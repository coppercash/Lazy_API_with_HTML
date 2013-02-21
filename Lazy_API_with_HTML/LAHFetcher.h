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
    NSString* _property;
}
@property(nonatomic, copy)LAHPropertyFetcher fetcher;
- (id)initWithKey:(NSString*)key fetcher:(LAHPropertyFetcher)fetcher;
- (id)initWithFetcher:(LAHPropertyFetcher)property;
- (void)fetchProperty:(id<LAHHTMLElement>)element;
@end
