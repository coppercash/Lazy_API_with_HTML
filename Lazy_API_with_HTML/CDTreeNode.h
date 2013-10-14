//
//  CDTreeNode.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 5/6/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDTreeNode : NSObject {
    CDTreeNode *_father;
    NSArray *_children;
}
@property(nonatomic, assign)CDTreeNode *father;
@property(nonatomic, retain)NSArray *children;

#pragma mark - Init
- (id)initWithFirstChild:(CDTreeNode *)firstChild variadicChildren:(va_list)children;
- (id)initWithChildren:(CDTreeNode *)firstChild, ... NS_REQUIRES_NIL_TERMINATION;

@end
