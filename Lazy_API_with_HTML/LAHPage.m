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
- (void)handleAttributes;
@end

@implementation LAHPage
@synthesize link = _link;
@synthesize attributes = _attributes;
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

#pragma mark - Events
- (void)fetchValue:(NSString *)value{
    NSAssert(self.recursiveOperation != nil, @"Can't get recursiveOperation");
    
    //Keep the link has a value
    if (value)
        self.link = value;
    
    //Fetch the attribute of LAHPage
    [self handleAttributes];
    
    //If do not have tags, no necessary to download.
    if (_children.count != 0)
        [self.recursiveOperation downloadPage:self];
}

- (void)handleAttributes{
    for (LAHAttribute *attr in _attributes) {
        NSString *value = nil;
        if ([attr.name isEqualToString:LAHValURL]) {
            value = self.urlString;
        }
        attr.cache = value;
        [attr fetch];
    }
}

- (void)seekWithElement:(LAHEle)element{

    //Make every tag match the root element
    NSInteger index = 0;
    for (LAHTag* tag in _children) {
        [tag handleElement:element atIndex:index];
        index ++;
    }
    
    //Make every element in the DOM be matched by every tag in recursive way
    for (LAHEle subEle in element.children) {
        [self seekWithElement:subEle];
    }

}

#pragma mark - Getter
- (LAHOperation*)recursiveOperation{
    LAHTag *father = (LAHTag*)_father;
    LAHOperation* ope = father.recursiveOperation;
    return ope;
}

- (NSMutableSet *)attributes{
    if (!_attributes) {
        _attributes = [[NSMutableSet alloc] init];
    }
    return _attributes;
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
    return [NSString stringWithFormat:@"%p%@", self, self.urlString];
}

#pragma mark - Log
- (NSString *)tagNameInfo{
    return @"page";
}

- (NSString *)attributesInfo{
    NSMutableString *info = [NSMutableString stringWithString:[super attributesInfo]];
    
    if (_link) [info appendFormat:@"  link=\"%@\"", _link];
    
    if (_attributes && _attributes.count != 0) {
        for (LAHAttribute *attr in _attributes) {
            [info appendFormat:@"  %@", attr.description];
        }
    }
    
    return info;
}

@end
