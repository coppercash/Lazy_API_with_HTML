//
//  LAHManagerEnhance.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 3/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHManagerEnhance.h"
@implementation LAHManager (LAHManagerEnhance)
- (void)fetchImage:(NSString *)path completion:(LAHImage)completion corrector:(LAHError)corrector{}
- (void)downloadData:(NSString *)path toLocal:(NSString *)localPath completion:(LAHDownload)completion corrector:(LAHError)corrector{}
@end
