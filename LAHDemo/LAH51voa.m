//
//  LAH51voa.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/8/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAH51voa.h"
#import "LAHContainer.h"

@implementation LAH51voa
- (LAHOperation*)homePage{
    LAHFetcher *type = [[LAHFetcher alloc] initWithKey:@"type" property:^NSString *(id<LAHHTMLElement> element) {
        return element.text;
    }];
    type.tagName = @"font";
    
    LAHFetcher *typeLink = [[LAHFetcher alloc] initWithKey:@"typeLink" property:^NSString *(id<LAHHTMLElement> element) {
        return [element.attributes objectForKey:@"href"];
    } children:type, nil];
    typeLink.tagName = @"a";[typeLink setIndex:0];
    
    LAHFetcher *name = [[LAHFetcher alloc] initWithKey:@"name" property:^NSString *(id<LAHHTMLElement> element) {
        return element.text;
    }];
    name.tagName = @"a"; [name setIndex:2];
    
    LAHFetcher *link = [[LAHFetcher alloc] initWithKey:@"link" property:^NSString *(id<LAHHTMLElement> element) {
        return [element.attributes objectForKey:@"href"];
    }];
    link.tagName = @"a"; [link setIndex:2];
    
    LAHFetcher *imgSrc = [[LAHFetcher alloc] initWithKey:@"imgSrc" property:^NSString *(id<LAHHTMLElement> element) {
        return [element.attributes objectForKey:@"src"];
    }];
    imgSrc.tagName = @"img";
    
    LAHRecognizer *div = [[LAHRecognizer alloc] initWithChildren:imgSrc, nil];
    div.tagName = @"div"; div.attributes = @{@"class":@"contentImage"};
    
    LAHDownloader *imgDown = [[LAHDownloader alloc] initWithProperty:^NSString *(id<LAHHTMLElement> element) {
        return [element.attributes objectForKey:@"href"];
    } children:div, nil];
    imgDown.tagName = @"a"; [imgDown setIndex:2];
    
    LAHContainer *item = [[LAHDictionary alloc] initWithChildren:name, link, typeLink, type, imgDown, nil];
    item.tagName = @"li"; item.range = NSMakeRange(0, 7);
    
    LAHContainer *array = [[LAHArray alloc] initWithChildren:item, nil];
    array.tagName = @"ul";
    
    LAHRecognizer *span = [[LAHRecognizer alloc] initWithChildren:array, nil];
    span.tagName = @"span"; span.attributes = @{@"id":@"list"};
    
    LAHOperation *op = [self operationWithPath:@"/index.html" rootContainer:array children:span, nil];
    
    [type release]; [typeLink release]; [name release]; [link release]; [imgSrc release]; [div release]; [imgDown release]; [item release]; [array release]; [span release];
    
    return op;

}
@end
