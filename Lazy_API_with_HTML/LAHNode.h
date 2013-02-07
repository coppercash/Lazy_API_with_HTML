//
//  LAHNode.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LAHGreffier;
@protocol LAHHTMLElement, LAHDownloaderDataSource, LAHDownloaderDelegate;
@interface LAHNode : NSObject {
    LAHNode *_father;
    NSMutableArray *_children;
    //NSMutableArray *_garbageBin;
}
@property(nonatomic, assign)LAHNode *father;
@property(nonatomic, retain)NSMutableArray *children;
- (id)initWithFirstChild:(LAHNode*)firstChild variadicChildren:(va_list)children;
- (id)initWithChildren:(LAHNode*)firstChild, ... NS_REQUIRES_NIL_TERMINATION;
#pragma mark - Recursive
- (void)handleElement:(id<LAHHTMLElement>)element atIndex:(NSUInteger)index;
- (LAHGreffier*)recursiveGreffier;
- (id)recursiveContainer;
- (void)releaseChild:(LAHNode*)child;
@end
