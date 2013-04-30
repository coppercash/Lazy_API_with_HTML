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
@property(nonatomic, retain)NSSet *legalValues;
@property(nonatomic, retain)NSSet *getters;

@property(nonatomic, copy)LAHAttrMethod method;
@property(nonatomic, retain)NSArray *args;

//@property(nonatomic, copy)NSString *re;
- (void)handleValue:(NSString *)value;
@end
