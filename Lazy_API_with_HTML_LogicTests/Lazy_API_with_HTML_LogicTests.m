//
//  Lazy_API_with_HTML_LogicTests.m
//  Lazy_API_with_HTML_LogicTests
//
//  Created by William Remaerd on 2/4/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "Lazy_API_with_HTML_LogicTests.h"
#import "LAHElementFetcher.h"
#import "LAHElementRecognizer.h"
#import "LAHHTMLProtocols.h"
#import "TFHpple.h"

@implementation Lazy_API_with_HTML_LogicTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    _bundle = [NSBundle bundleForClass: [self class]];
    
    _fetcher = [[LAHElementFetcher alloc] init];
}

- (void)tearDown
{
    [_fetcher release];
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testFetcher{
    NSString *path = [_bundle pathForResource:@"voa" ofType:@"html"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    TFHpple * doc = [[TFHpple alloc] initWithHTMLData:data];
    TFHppleElement<LAHHTMLElement> *root = (TFHppleElement<LAHHTMLElement>*)[doc peekAtSearchWithXPathQuery:@"/html"];

    LAHElementRecognizer *r0 = [[LAHElementRecognizer alloc] init];
    r0.tagName = @"img";
    r0.attributes = @{@"class":@"imgsmall aligned"};
    
    LAHElementRecognizer *r1 = [[LAHElementRecognizer alloc] initWithNextRecognizer:r0];
    r1.tagName = @"a";
    r1.attributes = @{@"id":@"ctl00_ctl00_cpAB_cp1_widgetDeskSection_ctl16_ctl03_ctl00_ImageHyperlink1"};

    LAHElementRecognizer *r2 = [[LAHElementRecognizer alloc] initWithNextRecognizer:r1];
    r2.tagName = @"div";
    r2.attributes = @{@"class":@"photo"};

    LAHElementRecognizer *r3 = [[LAHElementRecognizer alloc] initWithNextRecognizer:r2];
    r3.tagName = @"div";
    r3.attributes = @{@"class":@"boxwidget_part"};
    
    _fetcher.recognizerChain = r2;
    _fetcher.isLazy = NO;
    
    NSArray* melements = [_fetcher fetchElementsWithRootElement:root];
    for (id<LAHHTMLElement> e in melements) {
        NSLog(@"\n%@\n%@\n%@\n", e.tagName, e.text, e.attributes);
    }
}

@end
