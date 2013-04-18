//
//  LAHFetcher.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHConstruct.h"

@interface LAHFetcher : LAHConstruct {
    NSString *_property;

    NSString *_symbol;
    NSString *_reg;
    LAHPropertyFetcher _fetcher;
}
@property(nonatomic, copy)NSString *symbol;
@property(nonatomic, copy)NSString *reg;
@property(nonatomic, copy)LAHPropertyFetcher fetcher;
- (id)initWithFetcher:(LAHPropertyFetcher)property;
- (id)initWithSymbol:(NSString *)symbol;
- (void)fetchProperty:(LAHEle)element;
- (void)fetchSystemInfo:(LAHNode *)node;
@end
