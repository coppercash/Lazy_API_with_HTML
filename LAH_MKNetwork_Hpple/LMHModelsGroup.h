//
//  LAHModelsGroupMH.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 4/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHModelsGroup.h"
#import "MKNetworkOperation.h"
@class MKNetworkEngine;
@interface LMHModelsGroup : LAHModelsGroup {
    MKNetworkEngine *_engine;
}
- (NSURL *)resourceURLWithOfLink:(NSString *)link;
@end

@class TFHppleElement;
@interface MKNetworkOperation (HTML)
- (LAHEle)htmlWithXPath:(NSString *)xpath;
@end