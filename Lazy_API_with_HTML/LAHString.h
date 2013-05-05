//
//  LAHFetcher.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHModel.h"

@interface LAHString : LAHModel <LAHFetcher> {
    NSString *_string;
    NSString *_value;
    
    NSString *_re;

    //NSString *_symbol;
    //LAHPropertyFetcher _fetcher;
}
@property(nonatomic, copy)NSString *value;
@property(nonatomic, copy)NSString *re;

//@property(nonatomic, copy)NSString *symbol;
//@property(nonatomic, copy)LAHPropertyFetcher fetcher;
//- (id)initWithFetcher:(LAHPropertyFetcher)property;
//- (id)initWithSymbol:(NSString *)symbol;
//- (void)fetchProperty:(LAHEle)element;
//- (void)fetchSystemInfo:(LAHNode *)node;
@end
