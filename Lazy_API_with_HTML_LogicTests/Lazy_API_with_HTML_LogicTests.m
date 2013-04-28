//
//  Lazy_API_with_HTML_LogicTests.m
//  Lazy_API_with_HTML_LogicTests
//
//  Created by William Remaerd on 2/4/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "Lazy_API_with_HTML_LogicTests.h"
#import "LAHHeaders.h"

@implementation Lazy_API_with_HTML_LogicTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    _bundle = [NSBundle bundleForClass: [self class]];
    
    NSString *qus09 = @"<img src.re(\"some regular expression\")={\"some href\", 'str1'}>";

}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


@end
