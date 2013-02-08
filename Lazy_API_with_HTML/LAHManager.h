//
//  LAHManager.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/8/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LAHOperation.h"
@class LAHOperation, LAHContainer, LAHNode;
@interface LAHManager : NSObject <LAHDelegate>{
    NSMutableArray* _operations;
}
- (LAHOperation*)operationWithPath:(NSString*)path rootContainer:(LAHContainer*)rootContainer firstChild:(LAHNode*)firstChild variadicChildren:(va_list)children;
- (LAHOperation*)operationWithPath:(NSString*)path rootContainer:(LAHContainer*)rootContainer children:(LAHNode*)firstChild, ... NS_REQUIRES_NIL_TERMINATION;

@end
