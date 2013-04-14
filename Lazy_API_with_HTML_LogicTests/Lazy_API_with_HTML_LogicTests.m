//
//  Lazy_API_with_HTML_LogicTests.m
//  Lazy_API_with_HTML_LogicTests
//
//  Created by William Remaerd on 2/4/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "Lazy_API_with_HTML_LogicTests.h"
#import "LAHHeaders.h"
#import "LMHModelsGroup.h"
@implementation Lazy_API_with_HTML_LogicTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    _bundle = [NSBundle bundleForClass: [self class]];
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testLMHModelsGroup{
    NSString *path = [_bundle pathForResource:@"51VOA" ofType:@"lah"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    LMHModelsGroup *group = [[LMHModelsGroup alloc] initWithCommand:string key:@"ope"];
    NSLog(@"%@", group);
}

@end
