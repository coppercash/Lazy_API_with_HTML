//
//  LAHInterpreterTest.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 5/1/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHInterpreterTest.h"
#import "LAHInterpreter.h"
#import "LAHOperation.h"

@implementation LAHInterpreterTest {
@private
    NSBundle *_bundle;
}

- (void)testCase{
    NSString *path = [_bundle pathForResource:@"51VOA" ofType:@"lah"];
    NSString *cmd = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    NSMutableDictionary *container = [NSMutableDictionary dictionary];
    [LAHInterpreter interpretString:cmd intoDictionary:container];
    
    LAHOperation *ope0 = container[@"ope0"];
    LAHOperation *ope1 = container[@"ope1"];
    LAHOperation *ope2 = container[@"ope2"];

    NSLog(@"%@", ope0.debugDescription);
    NSLog(@"%@", ope1.debugDescription);
    NSLog(@"%@", ope2.debugDescription);

}

- (void)setUp{
    [super setUp];
    _bundle = [NSBundle bundleForClass:[self class]];
}

@end
