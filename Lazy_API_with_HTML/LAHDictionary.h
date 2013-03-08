//
//  LAHDictionary.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHConstruct.h"

@interface LAHDictionary : LAHConstruct {
    NSMutableDictionary *_dictionary;
}
- (id)initWithObjectsAndKeys:(LAHConstruct *)firstObj , ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithFirstObject:(LAHConstruct *)firstObj variadicObjectsAndKeys:(va_list)OtherObjsAndKeys;
@end

