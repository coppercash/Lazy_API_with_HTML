//
//  LAHInterpreter.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 3/8/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LAHNode;
@interface LAHInterpreter : NSObject
+ (LAHNode *)interpretFile:(NSString *)path forKey:(NSString *)key;
+ (void)interpretFile:(NSString *)path intoDictionary:(NSMutableDictionary *)dictionary;
+ (void)interpretString:(NSString *)string intoDictionary:(NSMutableDictionary *)dictionary;
+ (void)interpretIntoDictionary:(NSMutableDictionary *)dictionary fromFiles:(NSString *)firstFile, ... NS_REQUIRES_NIL_TERMINATION;
@end
