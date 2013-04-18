//
//  LAHFetcher.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHFetcher.h"
#import "LAHRecognizer.h"
#import "LAHDownloader.h"

@interface LAHFetcher ()
@property(nonatomic, copy)NSString *property;
- (void)doFetch;
@end

@implementation LAHFetcher
@synthesize fetcher = _fetcher, property = _property, symbol = _symbol, reg = _reg;
#pragma mark - Life Cycle

- (id)init{
    self = [super init];
    if (self) {
        self.type = LAHConstructTypeFetcher;
    }
    return self;
}

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

- (void)dealloc{
    self.fetcher = nil;
    self.property = nil;
    self.symbol = nil;
    
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone{
    LAHFetcher *copy = [super copyWithZone:zone];
    
    copy.fetcher = _fetcher;
    copy.symbol = _symbol;
    copy.property = _property;
    
    return copy;
}

#pragma mark - Element
- (void)fetchProperty:(LAHEle)element{
    if (_fetcher) {
        self.property = _fetcher(element);
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
        
        if (property && _reg) {
            
            NSError *regError = nil;
            NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:_reg options:0 error:&regError];
            NSTextCheckingResult *match = [regExp firstMatchInString:property options:0 range:NSMakeRange(0, property.length)];
            [regExp release];
            NSAssert(regError == nil, @"%@", regError.userInfo);

            if (match) {
                NSRange resultRange = [match rangeAtIndex:1];
                NSString *result = [property substringWithRange:resultRange];
                self.property = result;
            }
        
        } else {
            
            self.property = property;
        
        }
        
    } else {
        return;
    }
    [self doFetch];
}

- (void)fetchSystemInfo:(LAHNode *)node{
    if ([_symbol isEqualToString:LAHValPath]) {
        LAHDownloader *downloader = (LAHDownloader *)node;
        self.property = downloader.link;
    }else if ([_symbol isEqualToString:LAHValURL]) {
        LAHDownloader *downloader = (LAHDownloader *)node;
        self.property = downloader.absolutePath;
    }else if ([_symbol isEqualToString:LAHValHost]) {
        LAHDownloader *downloader = (LAHDownloader *)node;
        self.property = downloader.hostName;
    }
    [self doFetch];
}

- (void)doFetch{
#ifdef LAH_RULES_DEBUG
    NSMutableString *space = [NSMutableString string];
    for (int i = 0; i < gRecLogDegree; i ++) [space appendString:@"\t"];
    NSMutableString *info = [NSMutableString stringWithFormat:@"%@%@\n%@%@=%@",
                             space, self,
                             space, _symbol, _property];
    printf("\n%s\n", [info cStringUsingEncoding:NSASCIIStringEncoding]);
#endif
    if (_property == nil) return;
    
    LAHConstruct *father = (LAHConstruct *)_father;
    [father checkUpate:self];
    [father recieve:self];
}

- (id)container{
    return _property;
}

- (id)newValue{
    if (_property == nil) return [NSNull null];
    return _property;
}

- (void)refresh{
    self.property = nil;
    [super refresh];
}

#pragma mark - Interpreter
- (NSString *)infoProperties{
    NSMutableString *info = [NSMutableString string];
    if (_symbol) [info appendFormat:@"sym=%@, ", _symbol];
    if (_fetcher) [info appendFormat:@"fet=%@, ", _fetcher];
    [info appendString:[super infoProperties]];
    
    return info;
}

@end

