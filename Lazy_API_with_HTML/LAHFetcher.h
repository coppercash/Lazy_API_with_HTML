//
//  LAHFetcher.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHConstruct.h"

@interface LAHFetcher : LAHConstruct {
    LAHPropertyFetcher _fetcher;
    NSString *_symbol;
    NSString *_property;
}
@property(nonatomic, copy)LAHPropertyFetcher fetcher;
@property(nonatomic, copy)NSString *symbol;
- (id)initWithFetcher:(LAHPropertyFetcher)property;
- (id)initWithSymbol:(NSString *)symbol;
- (void)fetchProperty:(LAHEle)element;
- (void)fetchSystemInfo:(LAHNode *)node;
@end
