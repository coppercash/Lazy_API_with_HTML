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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"51VOA" ofType:@"lah"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    LAHOperation *operation = [self operationWithFile:path key:@"ope" dictionary:dic];
    LAHRecognizer *a = [dic objectForKey:@"a"];
    a.rule = ^BOOL(id<LAHHTMLElement> element){
        id<LAHHTMLElement> fC = [element.children objectAtIndex:0]; //first child
        if (![fC.tagName isEqualToString:@"text"]) return NO;
        return YES;
    };
    
    [dic release];
    return operation;
}

/*
- (LAHOperation*)homePage{
    LAHFetcher *type = [[LAHFetcher alloc] initWithSymbol:LAHValText]; type.key = @"type";
    LAHFetcher *typeLink = [[LAHFetcher alloc] initWithSymbol:@"href"];  typeLink.key = @"typelink";
    LAHFetcher *name = [[LAHFetcher alloc] initWithSymbol:LAHValText]; name.key = @"name";
    LAHFetcher *link = [[LAHFetcher alloc] initWithSymbol:@"href"]; link.key = @"link";
    LAHFetcher *imgSrc = [[LAHFetcher alloc] initWithSymbol:@"src"]; imgSrc.key = @"imgSrc";
    
    LAHDictionary *item = [[LAHDictionary alloc] initWithChildren:name, link, type, typeLink, imgSrc, nil]; 
    LAHArray *items = [[LAHArray alloc] initWithObjects:item, nil];
    
    
    LAHRecognizer *img = [[LAHRecognizer alloc] initWithFetchers:imgSrc, nil]; img.tagName = @"img";
    
    LAHRecognizer *div = [[LAHRecognizer alloc] initWithChildren:img, nil]; div.tagName = @"div";
    [div setKey:@"class" attributes:@"contentImage", nil];
    
    LAHDownloader *d = [[LAHDownloader alloc] initWithChildren:div, nil];
    d.symbol = @"href";
    
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

    LAHRecognizer *li = [[LAHRecognizer alloc] initWithChildren:a0, a1, nil]; li.tagName = @"li"; li.range = NSMakeRange(10, 7); //item.indexSource = li;
    item.identifiers = @[li];
    
    LAHRecognizer *ul = [[LAHRecognizer alloc] initWithChildren:li, nil]; ul.tagName = @"ul";
    
    LAHRecognizer *span = [[LAHRecognizer alloc] initWithChildren:ul, nil]; span.tagName = @"span";
    [span setKey:@"id" attributes:@"list", nil];
    
    LAHOperation *op = [self operationWithPath:@"" rootContainer:items children:span, nil];
    
    [type release]; [typeLink release]; [name release]; [link release]; [imgSrc release]; [item release]; [items release];
    
    [img release]; [div release]; [d release]; [font release]; [a0 release]; [a1 release]; [li release]; [ul release]; [span release];
    
    return op;
}
*/
@end
