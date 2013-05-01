//
//  LAHDownloader.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHPage.h"
#import "LAHOperation.h"
#import "LAHAttribute.h"
#import "LAHTag.h"

@interface LAHPage ()
@end

@implementation LAHPage
@synthesize link = _link;
@dynamic recursiveOperation;
@dynamic identifier;
@dynamic hostName, urlString;

#pragma mark - Life Cycle
- (void)dealloc{
    self.link = nil;
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone{
    LAHPage *copy = [super copyWithZone:zone];
    copy.link = _link;
    
    return copy;
}

#pragma mark - Getter
- (LAHOperation*)recursiveOperation{
    LAHTag *father = (LAHTag*)_father;
    LAHOperation* ope = father.recursiveOperation;
    return ope;
}

#pragma mark - Info
- (NSString *)urlString{
    LAHOperation *ope = self.recursiveOperation;
    NSString * url = [ope urlStringWith:_link];  //absolute path
    return url;
}

- (NSString *)hostName{
    NSString *host = self.recursiveOperation.hostName;
    return host;
}

- (NSString *)identifier{
    return [NSString stringWithFormat:@"%p", self];
}

#pragma mark - Seek
- (void)download{
    NSAssert(_link != nil, @"Can't get link.");
    if (!_link) return;

#ifdef LAH_RULES_DEBUG
    NSMutableString *space = [NSMutableString string];
    for (int i = 0; i < gRecLogDegree; i ++) [space appendString:@"\t"];
    //NSMutableString *info = [NSMutableString stringWithFormat:@"%@%@\n%@'symbol'=%@\n'link'=%@",
                             //space, self,
                             //space, _symbol, _link];
    //printf("\n%s\n", [info cStringUsingEncoding:NSASCIIStringEncoding]);
    
    gRecLogDegree += 1;
#endif
    
//    for (LAHAttribute *attr in _attributes) {
//        NSString *value = nil;
//        if ([attr.name isEqualToString:LAHValURL]) {
//            value = self.urlString;
//        }
//        [attr handleValue:value];
//    }

#ifdef LAH_RULES_DEBUG
    gRecLogDegree -= 1;
#endif
    
    if (_children.count == 0) return;   //If do not have tags, no necessary to download.
    LAHOperation *operation = self.recursiveOperation;
    NSAssert(operation != nil, @"Can't get recursiveOperation");
    
    [operation downloadPage:self];
    
}

- (void)seekWithElement:(LAHEle)element{
/*
#ifdef LAH_RULES_DEBUG
    NSMutableString *space = [NSMutableString string];
    for (int i = 0; i < gRecLogDegree; i ++) [space appendString:@"\t"];
    NSMutableString *info = [NSMutableString stringWithFormat:@"%@%@", space, self];
    printf("\n%s\n", [info cStringUsingEncoding:NSASCIIStringEncoding]);
    gRecLogDegree += 1;
#endif
*/
    for (LAHTag* tag in _children) {
        [tag handleElement:element];
    }
    
    for (LAHEle subEle in element.children) {
        [self seekWithElement:subEle];
    }
/*
#ifdef LAH_RULES_DEBUG
    gRecLogDegree -= 1;
#endif
 */
}


#pragma mark - Status

#pragma mark - Interpreter

#pragma mark - Log

- (NSString *)tagNameInfo{
    return @"page";
}

- (NSString *)attributesInfo{
    NSMutableString *info = [NSMutableString stringWithString:[super attributesInfo]];
    if (_link) [info appendFormat:@"  link=\"%@\"", _link];
    return info;
}
/*
- (NSString *)debugDescription{
    
}

- ()

- (NSString *)infoProperties{
    NSMutableString *info = [NSMutableString string];
    //if (_symbol) [info appendFormat:@"sym=%@, ", _symbol];
    return info;
}*/

@end
