//
//  LAHFetcher.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHString.h"
#import "LAHTag.h"
#import "LAHPage.h"

@interface LAHString ()
@property(nonatomic, copy)NSString *data;
- (void)doFetch;
@end

@implementation LAHString
@synthesize data = _data, value = _value;
@synthesize re = _re;
#pragma mark - Life Cycle

- (id)init{
    self = [super init];
    if (self) {
        self.type = LAHConstructTypeFetcher;
    }
    return self;
}
/*
- (id)initWithFetcher:(LAHPropertyFetcher)property{
    self = [self init];
    if (self) {
        self.fetcher = property;
    }
    return self;
}

- (id)initWithSymbol:(NSString *)symbol{
    self = [self init];
    if (self) {
        self.symbol = symbol;
    }
    return self;
}
*/
- (void)dealloc{
    //self.fetcher = nil;
    self.data = nil;
    self.value = nil;
    self.re = nil;
    //self.symbol = nil;
    
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone{
    LAHString *copy = [super copyWithZone:zone];
    
    //copy.fetcher = _fetcher;
    //copy.symbol = _symbol;
    //copy.data = _data;
    
    return copy;
}

#pragma mark - Element
/*
- (void)fetchProperty:(LAHEle)element{
    if (_fetcher) {
        self.data = _fetcher(element);
    } else if (_symbol) {
        NSString *property = nil;
        
        if ([_symbol isEqualToString:LAHValTag]) {
            property = element.tagName;
        } else if ([_symbol isEqualToString:LAHValText]) {
            property = element.text;
        } else if ([_symbol isEqualToString:LAHValContent]) {
            property = element.content;
        } else {
            property = [element.attributes objectForKey:_symbol];
        }
        
        if (property && _re) {
            
            NSError *regError = nil;
            NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:_re options:0 error:&regError];
            NSTextCheckingResult *match = [regExp firstMatchInString:property options:0 range:NSMakeRange(0, property.length)];
            [regExp release];
            NSAssert(regError == nil, @"%@", regError.userInfo);

            if (match) {
                NSRange resultRange = [match rangeAtIndex:1];
                NSString *result = [property substringWithRange:resultRange];
                self.data = result;
            }
        
        } else {
            
            self.data = property;
        
        }
        
    } else {
        return;
    }
    [self doFetch];
}

- (void)fetchSystemInfo:(LAHNode *)node{
    if ([_symbol isEqualToString:LAHValPath]) {
        LAHPage *downloader = (LAHPage *)node;
        self.data = downloader.link;
    }else if ([_symbol isEqualToString:LAHValURL]) {
        LAHPage *downloader = (LAHPage *)node;
        self.data = downloader.urlString;
    }else if ([_symbol isEqualToString:LAHValHost]) {
        LAHPage *downloader = (LAHPage *)node;
        self.data = downloader.hostName;
    }
    [self doFetch];
}
*/
/*
- (void)doFetch{
#ifdef LAH_RULES_DEBUG
    NSMutableString *space = [NSMutableString string];
    for (int i = 0; i < gRecLogDegree; i ++) [space appendString:@"\t"];
    NSMutableString *info = [NSMutableString stringWithFormat:@"%@%@\n%@%@=%@",
                             space, self,
                             space, _symbol, _data];
    printf("\n%s\n", [info cStringUsingEncoding:NSASCIIStringEncoding]);
#endif
    if (_data == nil) return;
    
    LAHModel *father = (LAHModel *)_father;
    [father checkUpate:self];
    [father recieve:self];
}
 */

- (id)data{
    return _data;
}

- (id)newValue{
    if (_data == nil) return [NSNull null];
    return _data;
}

- (void)refresh{
    self.data = nil;
    [super refresh];
}

#pragma mark - Interpreter
/*
- (NSString *)infoProperties{
    NSMutableString *info = [NSMutableString string];
    if (_symbol) [info appendFormat:@"sym=%@, ", _symbol];
    if (_fetcher) [info appendFormat:@"fet=%@, ", _fetcher];
    [info appendString:[super infoProperties]];
    
    return info;
}
*/
@end

