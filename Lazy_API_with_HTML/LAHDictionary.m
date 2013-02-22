//
//  LAHDictionary.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHDictionary.h"

@interface LAHDictionary ()
@property(nonatomic, retain)NSMutableDictionary *dictionary;
@end

@implementation LAHDictionary
@synthesize dictionary = _dictionary;

- (void)dealloc{
    self.dictionary = nil;
    [super dealloc];
}

- (id)recieveObject:(LAHConstruct*)object{
    NSMutableDictionary *dictionary = nil;
    if (_father == nil) {   //root construct
        if (_dictionary == nil) [self.dictionary = [[NSMutableDictionary alloc] init] release];
        dictionary = _dictionary;
    }else{
        dictionary = [(LAHConstruct*)_father recieveObject:self];   //Assert dictionary never be nil
    }
    
    id value = [dictionary objectForKey:object.key];
    if (value == nil) {
        [dictionary setObject:(value = object.newValue) forKey:object.key];
    }
    
    return value;
}

- (id)newValue{
    [self.dictionary = [[NSMutableDictionary alloc] init] release];
    return _dictionary;
}

- (id)container{
    return _dictionary;
}

@end

