//
//  LAHArray.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHModel.h"

@interface LAHArray : LAHModel {
    NSMutableArray *_array;
}

@property(nonatomic, retain)NSArray *range;

- (id)initWithObjects:(LAHModel *)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
@end

