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

}

@end
