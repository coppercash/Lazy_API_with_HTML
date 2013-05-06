//
//  LAHArray.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHArray.h"
#import "LAHTag.h"

@interface LAHArray ()
@property(nonatomic, retain)NSMutableArray *array;
@end

@implementation LAHArray
@synthesize array = _array;

- (id)initWithObjects:(LAHModel *)firstObj, ... {
    va_list objs; va_start(objs, firstObj);
    self = [self initWithFirstChild:firstObj variadicChildren:objs];
    va_end(objs);
    return self;
}

- (void)dealloc{
    self.array = nil;
    [super dealloc];
}

#pragma mark - Fetch Object
- (void)recieve:(LAHModel*)object{
    [super recieve:object];
    [self.array addObject:object.data];
}

- (NSMutableArray *)array{
    if (!_array || self.needUpdate) {
        [_array release];
        _array = [[NSMutableArray alloc] init];
        self.needUpdate = NO;
        [(LAHModel *)_father recieve:self];
    }
    return _array;
}

#pragma mark - Data
- (id)data{
    return _array;
}

- (void)setData:(id)data{
    [_array release];
    _array = [data retain];
}

#pragma mark - States
- (void)refresh{
    self.array = nil;
    [super refresh];
}

#pragma mark - Log
- (NSString *)tagNameInfo{
    return @"arr";
}

@end

