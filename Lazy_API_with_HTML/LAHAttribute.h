//
//  LAHAttribute.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 4/27/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LAHAttribute : NSObject{
    NSString *_name;
    
    NSSet *_legalValues;
    NSSet *_getters;
    
    NSString *_methodName;
    NSArray *_args;
}
@property(nonatomic, copy)NSString *name;

@property(nonatomic, retain)NSSet *legalValues;
@property(nonatomic, retain)NSSet *getters;

@property(nonatomic, copy)NSString *methodName;
@property(nonatomic, retain)NSArray *args;

- (void)handleValue:(NSString *)value;
- (NSString *)des;
@end
