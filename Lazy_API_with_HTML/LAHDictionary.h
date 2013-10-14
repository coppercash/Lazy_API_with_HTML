//
//  LAHDictionary.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHModel.h"

@interface LAHDictionary : LAHModel {
    NSMutableDictionary *_dictionary;
}
- (id)initWithObjectsAndKeys:(LAHModel *)firstObj , ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithFirstObject:(LAHModel *)firstObj variadicObjectsAndKeys:(va_list)OtherObjsAndKeys;
@end

