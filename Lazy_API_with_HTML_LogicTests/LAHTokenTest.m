//
//  LAHTokenTest.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 4/29/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHTokenTest.h"
#import "LAHToken.h"

@implementation LAHTokenTest

- (void)testIsNumber{
    NSString *qus0 = @"1234567";
    BOOL ans0 = isByRegularExpression(qus0, gNumberEX);
    STAssertTrue(ans0,
                 @"Pure number test");
    
    
    NSString *qus1 = @"12abc7";
    BOOL ans2 = isByRegularExpression(qus1, gNumberEX);
    STAssertFalse(ans2,
                  @"Numbers with letters test");

}

@end
