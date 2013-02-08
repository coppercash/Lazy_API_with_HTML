//
//  LAHContainer.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/7/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHRecognizer.h"

@interface LAHContainer : LAHRecognizer {
    Class _containerClass;
    id _container;
    NSString *_key;
    NSUInteger _index;
    NSMutableDictionary *_states;
}
@property(nonatomic, assign)Class containerClass;
@property(nonatomic, readonly)id container;
@property(nonatomic, copy)NSString *key;
@end

@interface LAHDictionary : LAHContainer
@end

@interface LAHArray : LAHContainer
@end