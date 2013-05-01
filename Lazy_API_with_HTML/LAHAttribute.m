//
//  LAHAttribute.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 4/27/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHAttribute.h"
#import "LAHString.h"

@implementation LAHAttribute
@synthesize name = _name;
@synthesize legalValues = _legalValues, getters = _getters;
@synthesize methodName = _methodName, args = _args;

- (void)handleValue:(NSString *)value{
    
}

- (NSString *)des{
    return [super description];
}

- (NSString *)description{
    NSMutableString *info = [NSMutableString stringWithFormat:@"%@", self.name];
    
    if (_methodName) {
        [info appendFormat:@".%@(", _methodName];
        
        BOOL isFirst = YES;
        for (NSString *arg in _args) {
            
            if (isFirst) {
                isFirst = NO;
            }else{
                [info appendFormat:@", "];
            }
            
            [info appendFormat:@"%@", arg];
        }

        [info appendString:@")"];
    }
    
    [info appendString:@"={"];
    
    BOOL isFirst = YES;
    if (_legalValues && _legalValues.count != 0) {
        for (NSString *value in _legalValues) {
            
            if (isFirst) {
                isFirst = NO;
            }else{
                [info appendFormat:@", "];
            }
            
            [info appendFormat:@"\"%@\"", value];
        }

    }
    if (_getters && _getters.count != 0) {
        for (LAHNode *node in _getters) {
            
            if (isFirst) {
                isFirst = NO;
            }else{
                [info appendFormat:@", "];
            }
            
            [info appendFormat:@"%@", node];
        }
        
    }
    
    [info appendString:@"}"];

    return info;
}

@end

/*

 - (void)extendIntegratedMethods{
 if (_father) return;
 
 LAHAttrMethod re = ^(NSString *value, NSArray *args, LAHTag *tag){
 
 NSString *pattern = args[0];
 NSString *target = value;
 NSString *ret = nil;
 
 NSError *regError = nil;
 NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:&regError];
 NSTextCheckingResult *match = [regExp firstMatchInString:target options:0 range:NSMakeRange(0, target.length)];
 [regExp release];
 NSAssert(regError == nil, @"%@", regError.userInfo);
 
 if (match) {
 NSRange resultRange = [match rangeAtIndex:1];
 ret = [target substringWithRange:resultRange];
 }
 
 return ret;
 };
 [self.references setObject:[re copy] forKey:LAHMethodRE];
 
 LAHAttrMethod joinHost = ^(NSString *value, NSArray *args, LAHTag *tag){
 
 NSString *ret = [tag.recursiveOperation urlStringWith:value];
 return ret;
 
 };
 [self.references setObject:[joinHost copy] forKey:LAHMethodJoinMethod];
 
 }

*/