//
//  LAH_MKNetwork_Hpple.h
//  LAH_MKNetwork_Hpple
//
//  Created by William Remaerd on 2/8/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHManager.h"
#import "LAHManagerEnhance.h"

@class MKNetworkEngine;
@interface LAH_MKNetworkKit_Hpple : LAHManager {
    MKNetworkEngine *_engine;
    NSMutableArray* _networks;
}
@property(nonatomic, readonly)NSMutableArray *networks;
- (id)initWithHostName:(NSString*)hostName;
- (void)cancel;
@end
