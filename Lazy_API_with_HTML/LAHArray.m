//
//  LAHArray.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHArray.h"

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
    
    id value = nil;
    if (object.indexSource == nil) {
        [array addObject:(value = object.newValue)];
    }else{
        NSRange rBO = NSMakeRange(0, [_children indexOfObject:object]); //range before object
        NSArray *subArray = [_children subarrayWithRange:rBO]; //child brefore object
        
        NSUInteger index = object.index;    //sub index
        for (LAHConstruct *c in subArray) index += c.count; //index is legal across all children
        
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
    _count ++;
    return _array;
}

- (id)container{
    return _array;
}

@end

