//
//  LAHDictionary.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHDictionary.h"
#import "LAHTag.h"

@interface LAHDictionary ()
@property(nonatomic, retain)NSMutableDictionary *dictionary;
@end

@implementation LAHDictionary
@synthesize dictionary = _dictionary;

- (id)init{
    self = [super init];
    if (self) {
        self.type = LAHConstructTypeDictionary;
    }
    return self;
}

- (id)initWithObjectsAndKeys:(LAHModel *)firstObj , ... NS_REQUIRES_NIL_TERMINATION{
    va_list other; va_start(other, firstObj);
    self = [self initWithFirstObject:firstObj variadicObjectsAndKeys:other];
    va_end(other);
    return self;
}

- (id)initWithFirstObject:(LAHModel *)firstObj variadicObjectsAndKeys:(va_list)OtherObjsAndKeys{
    self = [self init];
    if (self) {
        self.type = LAHConstructTypeDictionary;
        
        [self.children = [[NSMutableArray alloc] initWithObjects:firstObj, nil] release];
        firstObj.father = self;
        
        LAHModel *child = firstObj;
        BOOL isObj = NO;
        id objOrKey;
        while ((objOrKey = va_arg(OtherObjsAndKeys, id)) != nil){
            if (isObj) {
                child = (LAHModel *)objOrKey;
                [_children addObject:child];
                child.father = self;
                isObj = NO;
            }else{
                NSString *key = (NSString *)objOrKey;
                child.key = key;
                isObj = YES;
            }
        }
    }
    return self;
}

- (id)initWithFirstChild:(LAHNode *)firstChild variadicChildren:(va_list)children{
    self = [self initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        self.type = LAHConstructTypeDictionary;
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

#pragma mark - recursion
- (void)update{
    [self.dictionary = [[NSMutableDictionary alloc] init] release];
    [(LAHModel *)_father recieve:self];
}

- (void)recieve:(LAHModel*)object{
    [_dictionary setObject:object.data forKey:object.key];
}

- (id)data{
    return _dictionary;
}

#pragma mark - States
- (void)saveStateForKey:(id)key{
    NSMutableDictionary *collector = [[NSMutableDictionary alloc] initWithCapacity:3];
    //if (_lastFatherContainer) [collector setObject:_lastFatherContainer forKey:gKeyLastFatherContainer];
    //if (_lastIdentifierElement) [collector setObject:_lastIdentifierElement forKey:gKeyLastIdentifierElement];
    if (_dictionary) [collector setObject:_dictionary forKey:gKeyContainer];
    
    [_states setObject:collector forKey:key];
    [collector release];
    
    [super saveStateForKey:key];
}

- (void)restoreStateForKey:(id)key{
    NSDictionary *state = [_states objectForKey:key];
    //_lastFatherContainer = [state objectForKey:gKeyLastFatherContainer];
    //_lastIdentifierElement = [state objectForKey:gKeyLastIdentifierElement];
    self.dictionary = [state objectForKey:gKeyContainer];
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

