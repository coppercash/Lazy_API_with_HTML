//
//  LAHArray.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHArray.h"
#import "LAHRecognizer.h"

@interface LAHArray ()
@property(nonatomic, retain)NSMutableArray *array;
@end

@implementation LAHArray
@synthesize array = _array;

- (void)dealloc{
    self.array = nil;
    [super dealloc];
}


- (id)recieveObject:(LAHConstruct*)object{
    NSMutableArray *array = nil;
    if (_father == nil) { //root construct
        if (_array == nil) [self.array = [[NSMutableArray alloc] init] release];
        array = _array;
    }else{
        array = [(LAHConstruct*)_father recieveObject:self];    //Assert array never be nil
    }
    /*
    NSUInteger count = 0;
    for (LAHConstruct *c in _children)  count += c.count;
    id value = nil;
    NSUInteger index = count - 1;
    if (count == array.count) {
        value = [array objectAtIndex:index];
    }else{
        for (int i = array.count; i <= index; i++) [array addObject:(value = object.newValue)];
    }*/
    
    id value = nil;

    NSArray *indexes = object.indexes;
    if (indexes == nil || indexes.count == 0) {
        [array addObject:(value = object.newValue)];
    }else{
        NSUInteger count = object.count;
        
        NSUInteger index = count - 1;
        if (index < array.count) {
            value = [array objectAtIndex:index];
        }else{
            for (int i = array.count; i <= index; i++) [array addObject:(value = object.newValue)];
        }
    }
    
    return value;
}

- (id)newValue{
    [self.array = [[NSMutableArray alloc] init] release];
    return _array;
}

- (id)container{
    return _array;
}

@end

