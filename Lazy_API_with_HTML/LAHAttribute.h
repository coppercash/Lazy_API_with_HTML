//
//  LAHAttribute.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 4/27/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LAHAttribute : NSObject
@property(nonatomic, copy)NSString *name;
- (void)handleValue:(NSString *)value;
@end
