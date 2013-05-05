//
//  LAHCaseTest.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 5/3/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHCaseTest.h"
#import "OCMock.h"
#import "LAHOperation.h"
#import "LAHInterpreter.h"
#import "LMHModelsGroup.h"
#import "LAHPage.h"

@implementation LAHCaseTest {
@private
    NSDictionary *_htmlResource;
    id _networkEngineDummy;
    NSMutableArray *_netOpeDummy;
    NSBundle *_bundle;
    LMHModelsGroup *_group;
}

#pragma mark - Case VOANews

- (void)testOne{
    LAHOperation *ope = _group.operations[1];
    ope.page.link = @"http://www.voanews.com/section/usa/2203.html";
    [ope addCompletion:^(LAHOperation *operation) {
        NSLog(@"%@", operation.data);
    }];
    
    [ope start];
    [self doNetwork];
    [self doNetwork];
}


#pragma mark - Up & Down
- (void)setUp{
    [super setUp];
    
    _bundle = [NSBundle bundleForClass:[self class]];
    
    _htmlResource = @{
                     @"http://www.voanews.com/section/usa/2203.html":@"2203",
                     @"http://www.voanews.com/content/north-korea-sentence-us-prisoner/1653472.html":@"1653472",
                     @"http://www.voanews.com/content/kazakhstan-cooperating-with-un-on-boston-bombings/1653104.html":@"1653104",
                     @"http://www.voanews.com/content/spire-hoisted-atop-new-yorks-one-world-trade-center/1653476.html":@"1653476",
                     @"http://www.voanews.com/content/obama-to-nominate-top-economic-team-positions/1653087.html":@"1653087",
                     @"http://www.voanews.com/content/us-immigration-raids-saudi-diplomats-home/1653213.html":@"1653213"
                     };
    
    
    NSString *cmdPath = [_bundle pathForResource:@"VOANews" ofType:@"lah"];
    NSString *command = [NSString stringWithContentsOfFile:cmdPath encoding:NSASCIIStringEncoding error:nil];
    _group = [[LMHModelsGroup alloc] initWithCommand:command key:@"ope"];
    
    _networkEngineDummy = [OCMockObject partialMockForObject:_group.engine];
    [[[_networkEngineDummy stub]
      andCall:@selector(enqueueOperation:forceReload:) onObject:self]
     enqueueOperation:[OCMArg any] forceReload:YES];
    
    _netOpeDummy = [[NSMutableArray alloc] init];
}

- (void)tearDown{
    [_netOpeDummy release];
    [_group release];
    [_networkEngineDummy stopMocking];
    
    [super tearDown];
}

#pragma mark - Dummy Network
- (void)enqueueOperation:(MKNetworkOperation *)operation forceReload:(BOOL)forceReload{
    [_netOpeDummy addObject:operation];
}

- (void)doNetwork{
    NSArray *thisLoop = [_netOpeDummy copy];
    for (MKNetworkOperation *ope in thisLoop) {
        
        NSString *key = ope.url;
        NSString *dataName = [_htmlResource objectForKey:key];
        NSString *dataPath = [_bundle pathForResource:dataName ofType:@"html"];
        NSData *data = [NSData dataWithContentsOfFile:dataPath];
        NSAssert(data, @"Can't get network resource at link: %@", key);
        if (!data) continue;
        
        id opeMock = [OCMockObject partialMockForObject:ope];
        [[[opeMock stub] andReturn:data] responseData];
        
        for (MKNKResponseBlock res in ope.responseBlocks) {
            res(opeMock);
        }
        
        [opeMock stopMocking];
        [_netOpeDummy removeObject:ope];
    }
    [thisLoop release];
}

@end
