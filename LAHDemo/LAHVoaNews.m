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
    LAHFetcher *name0 = [[LAHFetcher alloc] initWithSymbol:LAHValText];
    LAHFetcher *link0 = [[LAHFetcher alloc] initWithSymbol:@"href"];
    LAHFetcher *imgSrc0 = [[LAHFetcher alloc] initWithSymbol:@"src"];
    LAHFetcher *imgSrc2 = [[LAHFetcher alloc] initWithFetcher:^NSString *(LAHEle element) {
        NSString *style = [element.attributes objectForKey:@"style"];
        NSRange sR = [style rangeOfString:@"url("];
        NSRange eR = [style rangeOfString:@")"];
        NSRange r = NSMakeRange(NSMaxRange(sR), eR.location - NSMaxRange(sR));
        return [style substringWithRange:r];
    }];
    
    LAHArray *arr0 = [[LAHArray alloc] initWithObjects:imgSrc0, imgSrc2, nil];
    LAHDictionary *dic0 = [[LAHDictionary alloc] initWithObjectsAndKeys:
                           name0, @"name", link0, @"link", arr0, @"imgSrc", nil];
    LAHArray *items = [[LAHArray alloc] initWithObjects:dic0, nil];
    
    LAHRecognizer *span = [[LAHRecognizer alloc] init];
    span.fetchers = @[name0];
    span.tagName = @"span";
    [span setKey:@"class" attributes:@"underlineLink", nil];
    
    LAHRecognizer *aNL0 = [[LAHRecognizer alloc] initWithChildren:span, nil];
    aNL0.fetchers = @[name0, link0];
    aNL0.tagName = @"a";
    
    LAHRecognizer *h3 = [[LAHRecognizer alloc] initWithChildren:aNL0, nil];
    h3.tagName = @"h3";
    
    LAHRecognizer *img0 = [[LAHRecognizer alloc] init]; img0.fetchers = @[imgSrc0];
    img0.tagName = @"img";
    
    LAHRecognizer *aI0 = [[LAHRecognizer alloc] initWithChildren:img0, nil];
    aI0.tagName = @"a";
    [aI0 setKey:@"id" attributes:@"ctl00_ctl00_cpAB_cp1_widgetDeskSection_ctl02_ctl02_ctl00_ImageHyperlink1", nil];
    
    LAHRecognizer *div0 = [[LAHRecognizer alloc] initWithChildren:h3, aI0, nil];;
    div0.tagName = @"div"; div0.range = NSMakeRange(0, 1);
    [div0 setKey:@"class" attributes:@"columnInner", nil];
    
    
    
    LAHRecognizer *img1 = [[LAHRecognizer alloc] init]; img1.fetchers = @[imgSrc0];
    img1.tagName = @"img"; //img1.attributes = @{@"class":@"photo"};
    [img1 setKey:@"class" attributes:@"photo", nil];
    [img1 setKey:@"alt" attributes:LAHValAll, nil];
    
    LAHDownloader *d1 = [[LAHDownloader alloc] initWithChildren:img1, nil];
    d1.symbol = @"href";
    
    LAHRecognizer *aNL1 = [[LAHRecognizer alloc] initWithChildren:span, nil]; aNL1.fetchers = @[name0, link0];
    aNL1.tagName = @"a"; aNL1.downloaders = @[d1];

    LAHRecognizer *h4_1 = [[LAHRecognizer alloc] initWithChildren:aNL1, nil];
    h4_1.tagName = @"h4"; h4_1.range = NSMakeRange(3, 3);
    
    LAHRecognizer *div1 = [[LAHRecognizer alloc] initWithChildren:h4_1, nil];
    div1.tagName = @"div";

    LAHRecognizer *divContent = [[LAHRecognizer alloc] initWithChildren:div1, nil];
    divContent.tagName = @"div"; 
    [divContent setKey:@"class" attributes:@"content_column2_widgethalf secondcolumn", nil];
    
    
    LAHRecognizer *aNL2 = [[LAHRecognizer alloc] initWithChildren:span, nil]; aNL2.fetchers = @[name0, link0];
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
    div2I.tagName = @"div"; div2I.range = NSMakeRange(0, 5);
    
    LAHRecognizer *divBox = [[LAHRecognizer alloc] initWithChildren:div2I, nil];
    divBox.tagName = @"div";
    
    LAHRecognizer *li = [[LAHRecognizer alloc] initWithChildren:divBox, nil];
    li.tagName = @"li"; [li setIndex:0];

    LAHRecognizer *ul = [[LAHRecognizer alloc] initWithChildren:li, nil];
    [ul setKey:@"class" attributes:@"overview", nil];
    
    dic0.identifiers = @[div0, h4_1, div2I];
    
    LAHOperation *op = [self operationWithPath:@"" rootContainer:items children:div0 ,divContent, ul, nil];
    
    [name0 release]; [link0 release]; [imgSrc0 release]; [imgSrc2 release]; [arr0 release];[dic0 release]; [items release]; [span release];
    
    [aNL0 release]; [h3 release]; [img0 release]; [aI0 release]; [div0 release]; [img1 release];
    
    [d1 release]; [aNL1 release]; [h4_1 release]; [div1 release]; [divContent release];
    
    [aNL2 release]; [h4_2 release]; [img2 release]; [aI2 release]; [div2 release]; [div2I release]; [divBox release]; [li release]; [ul release];
    return op;
}

@end
