//
//  LAH51voa.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/8/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAH_MKNetwork_Hpple.h"

@interface LAH51voa : LAH_MKNetworkKit_Hpple
- (LAHOperation*)homePage;
- (LAHOperation *)itemAtPath:(NSString *)path;
@end
