//
//  LAHArray.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHConstruct.h"

@interface LAHArray : LAHConstruct {
    NSMutableArray *_array;
}
- (id)initWithObjects:(LAHConstruct *)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
@end

