//
//  LAHAttribute.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 4/27/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHAttribute.h"
#import "LAHString.h"
#import "LAHTag.h"
#import "LAHOperation.h"
#import "LAHCategories.h"
#import "LAHNote.h"
#import "LAHPage.h"

@interface LAHAttribute ()
@end

@implementation LAHAttribute
@synthesize name = _name;
@synthesize legalValues = _legalValues, getters = _getters;
@synthesize methodName = _methodName, args = _args;
@synthesize cache = _cache;
@dynamic isMatched;

#pragma mark - Class Basic
- (void)dealloc{
    
    self.name = nil;
    self.legalValues = nil;
    self.getters = nil;
    self.methodName = nil;
    self.args = nil;
    self.cache = nil;
    
    [super dealloc];
}

#pragma mark - Copy
- (id)copyVia:(NSMutableDictionary *)table{
    LAHAttribute *copy = [super copyVia:table];
    
    copy.name = _name;
    
    copy.legalValues = [[NSSet alloc] initWithSet:_legalValues copyItems:YES];
    [copy.legalValues release];
    
    NSMutableSet *gettersClc = [[NSMutableSet alloc] initWithCapacity:_getters.count];
    for (LAHNode *getter in _getters) {
        
        if ([getter isKindOfClass:[LAHPage class]]) {
            
            LAHPage *pageCopy = [getter copyVia:table];
            [gettersClc addObject:pageCopy];
            [pageCopy release];
            
            pageCopy.father = copy;
            
        } else if ([getter isKindOfClass:[LAHModel class]]) {
            
            LAHModel *modelCopy = table[((LAHModel *)getter).identifier];
            [gettersClc addObject:modelCopy];
        }
    }
    copy.getters = [[NSSet alloc] initWithSet:gettersClc];
    [copy.getters release];
    [gettersClc release];
    
    copy.methodName = _methodName;
    
    copy.args = [[NSArray alloc] initWithArray:_args copyItems:YES];
    [copy.args release];
        
    return copy;
}

#pragma mark - Integrated methods
+ (NSDictionary *)methods{
    static NSDictionary *methods = nil;
    if (!methods) {
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
        LAHAttrMethod re_c = [re copy];
        
        LAHAttrMethod joinHost = ^(NSString *value, NSArray *args, LAHTag *tag){
            
            NSString *ret = [tag.recursiveOperation urlStringWith:value];
            return ret;
            
        };
        LAHAttrMethod joinHost_c = [joinHost copy];
        
        methods = [[NSDictionary alloc] initWithObjectsAndKeys:
                   re_c, @"re",
                   joinHost_c, @"joinHost",
                   nil];
        [re release];
        [joinHost release];
    }
    return methods;

}

#pragma mark - Events
- (void)cacheValueWithElement:(LAHEle)element{
    NSAssert(element != nil, @"Can't cache without element.");
    if (!element) return;

    
    NSString *value = nil;  //Keep the value reflects the real occasion
    if ([_name isEqualToString:LAHParaTag]) {
        value = element.tagName;
    } else if ([_name isEqualToString:LAHParaContent]) {
        value = element.content;
    } else {
        value = element.attributes[_name];
    }
    
    if (_methodName && value) {
        LAHAttrMethod method = LAHAttribute.methods[_methodName];
        if (!method) {
            method = [self.recursiveOperation methodWithName:_methodName];
        }
        if (method) {
            LAHTag *tag = (LAHTag *)_father;
            value = method(value, _args, tag);
        }
    }

    self.cache = value;
}

- (BOOL)isMatched{
    BOOL isMatched = (_legalValues.count == 0); //No legal values meas no limit to the value, even value is nil
    for (NSString *legal in _legalValues) {
        if ( [legal isEqualToString:LAHValNone] ) {
            
            isMatched = _cache == nil;
            break;
        
        } else if ( [legal isEqualToString:LAHValAll] ) {
            
            isMatched = _cache != nil;
            break;

        } else if ( [legal isEqualToString:_cache] ){
            
            isMatched = YES;
            break;

        }
    }

    LAHNoteAttr(_name, _cache, _legalValues.allObjects.lineDesc, isMatched);
    return isMatched;
}

- (void)fetch{
    if (!_cache) return;
    
    for (LAHNode<LAHFetcher> *fetcher in _getters) {       
        [fetcher fetchValue:_cache];
    }
}

#pragma mark - Log
- (NSString *)desc{
    return [super description];
}

- (NSString *)description{
    NSMutableString *info = [NSMutableString stringWithFormat:@"%@", self.name];
    
    if (_methodName) {
        [info appendFormat:@".%@(%@)", _methodName, _args.lineDesc];
    }
    
    [info appendString:@"={"];
    
    if (_legalValues && _legalValues.count != 0) {
        [info appendString:_legalValues.allObjects.lineDesc];
    }
    
    if (_getters && _getters.count != 0) {
        [info appendString:_getters.allObjects.lineDesc];
    }
    
    [info appendString:@"}"];

    return info;
}


@end

