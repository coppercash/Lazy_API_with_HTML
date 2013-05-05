//
//  LAHCaseTest.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 5/3/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "MKNetworkKit.h"
#import "LMHModelsGroup.h"

@interface LAHCaseTest : SenTestCase
@end

@interface LMHModelsGroup (LMHModelsGroupTest)
@property(nonatomic, strong)MKNetworkEngine *engine;
@end

@interface MKNetworkOperation (MKNetworkOperationTest)
@property(nonatomic, strong)NSMutableArray *responseBlocks;
@end
