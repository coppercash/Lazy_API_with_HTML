//
//  LAHDictionary.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHDictionary.h"
#import "LAHTag.h"
#import "LAHNote.h"

@interface LAHDictionary ()
@property(nonatomic, retain)NSMutableDictionary *dictionary;
@end

@implementation LAHDictionary
@synthesize dictionary = _dictionary;

#pragma mark - Class Basic
- (id)initWithObjectsAndKeys:(LAHModel *)firstObj , ... {
    va_list other; va_start(other, firstObj);
    self = [self initWithFirstObject:firstObj variadicObjectsAndKeys:other];
    va_end(other);
    return self;
}

- (id)initWithFirstObject:(LAHModel *)firstObj variadicObjectsAndKeys:(va_list)OtherObjsAndKeys{
    self = [super init];
    if (self) {
        
        [self.children = [[NSMutableArray alloc] initWithObjects:firstObj, nil] release];
        firstObj.father = self;
        
        LAHModel *child = firstObj;
        NSMutableArray *collector = [[NSMutableArray alloc] init];
        BOOL isObj = NO;
        id objOrKey;
        while ((objOrKey = va_arg(OtherObjsAndKeys, id)) != nil){
            if (isObj) {
                child = (LAHModel *)objOrKey;
                [collector addObject:child];
                child.father = self;
                isObj = NO;
            }else{
                NSString *key = (NSString *)objOrKey;
                child.key = key;
                isObj = YES;
            }
        }
        _children = collector;
        [collector release];
    }
    return self;
}

- (void)dealloc{
    self.dictionary = nil;
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone{
    LAHDictionary *copy = [super copyWithZone:zone];
    
    if (_dictionary) copy.dictionary = [[NSMutableDictionary alloc] initWithDictionary:_dictionary copyItems:YES];
    
    [copy.dictionary release];
    
    return copy;
}

#pragma mark - Getter
- (id)data{
    return _dictionary;
}

- (NSMutableDictionary *)dictionary{
    if (!_dictionary || self.needUpdate) {
        [_dictionary release];
        _dictionary = [[NSMutableDictionary alloc] init];
        self.needUpdate = NO;
        [(LAHModel *)_father recieve:self];
    }
    return _dictionary;
}

- (void)recieve:(LAHModel*)object{
    [super recieve:object];
    [self.dictionary setObject:object.data forKey:object.key];
}

#pragma mark - States
- (void)saveStateForKey:(id)key{
    NSAssert(_states[key] == nil, @"Will overwrite state for key '%@'", key);
    
    NSMutableDictionary *state = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (_dictionary) state[gKeyContainer] = _dictionary;
    state[gKeyNeedUpdate] = [NSNumber numberWithBool:_needUpdate];
    
    _states[key] = state;
    [state release];
    
    [super saveStateForKey:key];
}

- (void)restoreStateForKey:(id)key{
    NSDictionary *state = _states[key];
    self.dictionary = state[gKeyContainer];
    self.needUpdate = [state[gKeyNeedUpdate] boolValue];
    
    [_states removeObjectForKey:key];
    
    [super restoreStateForKey:key];
}

- (void)refresh{
    self.dictionary = nil;
    [super refresh];
}

#pragma mark - Log
- (NSString *)tagNameInfo{
    return @"dic";
}

@end

