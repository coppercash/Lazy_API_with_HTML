//
//  LAHCategories.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 5/2/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LAHFrame;

@interface NSArray (LAHArray)
- (NSArray *)dividedRangesWithFrame:(LAHFrame *)frame;
- (BOOL)locationInDividedRanges:(NSUInteger)location;
- (NSString *)dividedDesc;
- (NSString *)lineDesc;
@end

@interface NSString (LAHString)
- (void)log;
@end

