//
//  LAHGreffier+Hpple+MKNetwrokKit.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/6/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHGreffier.h"
@class MKNetworkEngine;
@interface LAHGreffier_Hpple_MKNetwrokKit : NSObject <LAHDataSource, LAHDelegate> {
    LAHGreffier *_greffier;
    MKNetworkEngine *_engine;
    NSMutableArray *_trees;
}
@property(nonatomic, retain)LAHGreffier *greffier;
@property(nonatomic, retain)MKNetworkEngine *engine;
- (id)initWithHostName:(NSString*)hostName;
- (void)startWithTreeRoot:(LAHDownloader *)root;
@end
