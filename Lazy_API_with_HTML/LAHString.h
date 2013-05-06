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
}
@property(nonatomic, copy)NSString *value;
@property(nonatomic, copy)NSString *re;

@end
