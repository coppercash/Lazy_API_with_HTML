//
//  LAH51voa.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/8/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAH51voa.h"
#import "LAHHeaders.h"

@implementation LAH51voa
- (id)init{
    self = [super initWithHostName:@"www.51voa.com"];
    return self;
}

- (LAHOperation*)homePage{
    LAHFetcher *type = [[LAHFetcher alloc] initWithKey:@"type" fetcher:^NSString *(id<LAHHTMLElement> element) {
        return element.text;
    }];
    LAHFetcher *typeLink = [[LAHFetcher alloc] initWithKey:@"typelink" fetcher:^NSString *(id<LAHHTMLElement> element) {
        return [element.attributes objectForKey:@"href"];
    }];
    LAHFetcher *name = [[LAHFetcher alloc] initWithKey:@"name" fetcher:^NSString *(id<LAHHTMLElement> element) {
        return element.text;
    }];
    LAHFetcher *link = [[LAHFetcher alloc] initWithKey:@"link" fetcher:^NSString *(id<LAHHTMLElement> element) {
        return [element.attributes objectForKey:@"href"];
    }];
    LAHFetcher *imgSrc = [[LAHFetcher alloc] initWithKey:@"imgSrc" fetcher:^NSString *(id<LAHHTMLElement> element) {
        return [element.attributes objectForKey:@"src"];
    }];
    LAHDictionary *item = [[LAHDictionary alloc] initWithChildren:name, link, type, typeLink, imgSrc, nil]; 
    LAHArray *items = [[LAHArray alloc] initWithChildren:item, nil];
    
    
    LAHRecognizer *img = [[LAHRecognizer alloc] initWithFetchers:imgSrc, nil]; img.tagName = @"img";
    
    LAHRecognizer *div = [[LAHRecognizer alloc] initWithChildren:img, nil]; div.tagName = @"div"; div.attributes = @{@"class":@"contentImage"};
    
    LAHDownloader *d = [[LAHDownloader alloc] initWithLinker:^NSString *(id<LAHHTMLElement> element) {
        NSString *imgSrc = [element.attributes objectForKey:@"href"];
        return imgSrc;
    } children:div, nil];
    
    LAHRecognizer *font = [[LAHRecognizer alloc] initWithFetchers:type, nil]; font.tagName = @"font";
    
    LAHRecognizer *a0 = [[LAHRecognizer alloc] initWithChildren:font, nil]; a0.tagName = @"a"; [a0 setIndex:0];
    a0.fetchers = @[typeLink];
    
    LAHRecognizer *a1 = [[LAHRecognizer alloc] initWithFetchers:name, link , nil]; a1.tagName = @"a";
    a1.rule = ^BOOL(id<LAHHTMLElement> element){
        id<LAHHTMLElement> fC = [element.children objectAtIndex:0]; //first child
        if (![fC.tagName isEqualToString:@"text"]) return NO;
        return YES;
    };
    a1.downloaders = @[d];

    LAHRecognizer *li = [[LAHRecognizer alloc] initWithChildren:a0, a1, nil]; li.tagName = @"li"; li.range = NSMakeRange(0, 7); item.indexSource = li;
    
    LAHRecognizer *ul = [[LAHRecognizer alloc] initWithChildren:li, nil]; ul.tagName = @"ul";
    
    LAHRecognizer *span = [[LAHRecognizer alloc] initWithChildren:ul, nil]; span.tagName = @"span"; span.attributes = @{@"id":@"list"};

    LAHOperation *op = [self operationWithPath:@"" rootContainer:items children:span, nil];
    
    [type release]; [typeLink release]; [name release]; [link release]; [imgSrc release]; [item release]; [items release];
    
    [img release]; [div release]; [d release]; [font release]; [a0 release]; [a1 release]; [li release]; [ul release]; [span release];
    
    return op;
}
 
@end