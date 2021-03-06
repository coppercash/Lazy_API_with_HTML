//
//  LAHModelsGroupMH.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 4/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHModelsGroup.h"
#import "MKNetworkKit.h"
#import "LAHInterface.h"

@interface LMHModelsGroup : LAHModelsGroup <LAHDelegate> {
    MKNetworkEngine *_engine;
    NSMutableArray *_copiedOpes;
}
- (NSURL *)resourceURLWithOfLink:(NSString *)link;
@end

@interface MKNetworkOperation (HTML)
- (LAHEle)htmlWithXPath:(NSString *)xpath;
@end

@interface MKNetworkEngine (LAH)
- (MKNetworkOperation *)operationWithLink:(NSString *)link;
@end