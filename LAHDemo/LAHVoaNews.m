//
//  LAHVoaNews.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/19/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHVoaNews.h"
#import "LAHHeaders.h"

@implementation LAHVoaNews
- (id)init{
    self = [super initWithHostName:@"www.voanews.com"];
    return self;
}

- (LAHOperation*)homePage{
    LAHFetcher *name0 = [[LAHFetcher alloc] initWithKey:@"name" fetcher:^NSString *(id<LAHHTMLElement> element) {
        if (element.text != nil) return element.text;
        LAHEle span = [element.children objectAtIndex:1];
        return span.text;
        return nil;
    }], *name1 = [name0 copy], *name2 = [name0 copy];
    LAHFetcher *link0 = [[LAHFetcher alloc] initWithKey:@"link" fetcher:^NSString *(id<LAHHTMLElement> element) {
        return [element.attributes objectForKey:@"href"];
    }], *link1 = [link0 copy], *link2 = [link0 copy];
    LAHFetcher *imgSrc0 = [[LAHFetcher alloc] initWithKey:@"imgSrc" fetcher:^NSString *(id<LAHHTMLElement> element) {
        return [element.attributes objectForKey:@"src"];
    }], *imgSrc1 = [imgSrc0 copy];
    LAHFetcher *imgSrc2 = [[LAHFetcher alloc] initWithFetcher:^NSString *(id<LAHHTMLElement> element) {
        NSString *style = [element.attributes objectForKey:@"style"];
        NSRange sR = [style rangeOfString:@"url("];
        NSRange eR = [style rangeOfString:@")"];
        NSRange r = NSMakeRange(NSMaxRange(sR), eR.location - NSMaxRange(sR));
        return [style substringWithRange:r];
    }];
    
    LAHArray *arr0 = [[LAHArray alloc] initWithKey:@"imgSrc" children:imgSrc0, nil];
    LAHArray *arr1 = [[LAHArray alloc] initWithKey:@"imgSrc" children:imgSrc1, nil];
    LAHArray *arr2 = [[LAHArray alloc] initWithKey:@"imgSrc" children:imgSrc2, nil];
    LAHDictionary *dic0 = [[LAHDictionary alloc] initWithChildren:name0, link0, arr0, nil];
    LAHDictionary *dic1 = [[LAHDictionary alloc] initWithChildren:name1, link1, arr1, nil];
    LAHDictionary *dic2 = [[LAHDictionary alloc] initWithChildren:name2, link2, arr2, nil];
    LAHArray *items = [[LAHArray alloc] initWithChildren:dic0, dic1, dic2, nil];
    

    LAHRecognizer *aNL0 = [[LAHRecognizer alloc] init]; aNL0.fetchers = @[name0, link0];
    aNL0.tagName = @"a";
    
    LAHRecognizer *h3 = [[LAHRecognizer alloc] initWithChildren:aNL0, nil];
    h3.tagName = @"h3";
    
    LAHRecognizer *img0 = [[LAHRecognizer alloc] init]; img0.fetchers = @[imgSrc0];
    img0.tagName = @"img";
    
    LAHRecognizer *aI0 = [[LAHRecognizer alloc] initWithChildren:img0, nil];
    aI0.tagName = @"a"; aI0.attributes = @{@"id":@"ctl00_ctl00_cpAB_cp1_widgetDeskSection_ctl02_ctl02_ctl00_ImageHyperlink1"};
    
    LAHRecognizer *div0 = [[LAHRecognizer alloc] initWithChildren:h3, aI0, nil];
    div0.tagName = @"div"; div0.attributes = @{@"class":@"columnInner"};
    
    LAHRecognizer *img1 = [[LAHRecognizer alloc] init]; img1.fetchers = @[imgSrc1];
    img1.tagName = @"img"; img1.attributes = @{@"class":@"photo"};
    img1.rule = ^BOOL(id<LAHHTMLElement> element){
        NSString *alt = [element.attributes objectForKey:@"alt"];
        if (alt == nil) return NO;
        return YES;
    };
    
    LAHDownloader *d1 = [[LAHDownloader alloc] initWithLinker:^NSString *(id<LAHHTMLElement> element) {
        return [element.attributes objectForKey:@"href"];
    } children:img1, nil];
    
    LAHRecognizer *aNL1 = [[LAHRecognizer alloc] init]; aNL1.fetchers = @[name1, link1];
    aNL1.tagName = @"a"; aNL1.downloaders = @[d1];

    LAHRecognizer *h4_1 = [[LAHRecognizer alloc] initWithChildren:aNL1, nil];
    h4_1.tagName = @"h4"; h4_1.range = NSMakeRange(1, 3);
    
    LAHRecognizer *div1 = [[LAHRecognizer alloc] initWithChildren:h4_1, nil];
    div1.tagName = @"div";

    LAHRecognizer *divContent = [[LAHRecognizer alloc] initWithChildren:div1, nil];
    divContent.tagName = @"div"; divContent.attributes = @{@"class":@"content_column2_widgethalf secondcolumn"};

    
    LAHRecognizer *aNL2 = [[LAHRecognizer alloc] init]; aNL2.fetchers = @[name2, link2];
    aNL2.tagName = @"a";
    
    LAHRecognizer *h4_2 = [[LAHRecognizer alloc] initWithChildren:aNL2, nil];
    h4_2.tagName = @"h4";

    LAHRecognizer *img2 = [[LAHRecognizer alloc] init]; img2.fetchers = @[imgSrc2];
    img2.tagName = @"img";

    LAHRecognizer *aI2 = [[LAHRecognizer alloc] initWithChildren:img2, nil];
    aI2.tagName = @"a";

    LAHRecognizer *div2 = [[LAHRecognizer alloc] initWithChildren:h4_2, aI2, nil];
    div2.tagName = @"div";

    LAHRecognizer *div2I = [[LAHRecognizer alloc] initWithChildren:div2, nil];
    div2I.tagName = @"div";
    
    LAHRecognizer *divBox = [[LAHRecognizer alloc] initWithChildren:div2I, nil];
    divBox.tagName = @"div";
    
    LAHRecognizer *li = [[LAHRecognizer alloc] initWithChildren:divBox, nil];
    li.tagName = @"li"; [li setIndex:0];

    LAHRecognizer *ul = [[LAHRecognizer alloc] initWithChildren:li, nil];
    ul.tagName = @"ul"; ul.attributes = @{@"class":@"overview"};
    
    dic0.indexSource = div0;
    dic1.indexSource = h4_1;
    dic2.indexSource = div2I;
    
    LAHOperation *op = [self operationWithPath:@"" rootContainer:items children:div0 ,divContent, ul, nil];
    
    
    [name0 release]; [name1 release]; [name2 release]; [link0 release]; [link1 release]; [link2 release];[imgSrc0 release]; [imgSrc1 release]; [imgSrc2 release]; [arr0 release]; [arr1 release]; [arr2 release]; [dic0 release]; [dic1 release]; [dic2 release]; [items release];
    
    [aNL0 release]; [h3 release]; [img0 release]; [aI0 release]; [div0 release]; [img1 release];
    
    [d1 release]; [aNL1 release]; [h4_1 release]; [div1 release]; [divContent release];
    
    [aNL2 release]; [h4_2 release]; [img2 release]; [aI2 release]; [div2 release]; [div2I release]; [divBox release]; [li release]; [ul release];
    return op;
}

@end
