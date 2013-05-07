//
//  LAHConstruct.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHModel.h"
#import "LAHTag.h"
#import "LAHOperation.h"
#import "LAHNote.h"
#import "LAHCategories.h"

@interface LAHModel ()
@property(nonatomic, retain)id data;
@end

@implementation LAHModel
@synthesize key = _key, range = _range;
@synthesize needUpdate = _needUpdate;
@dynamic data;
@synthesize states = _states;

- (void)dealloc{
    self.key = nil;
    self.range = nil;
    
    [super dealloc];
}

#pragma mark - Copy
@dynamic identifier;

- (NSString *)identifier{
    return [NSString stringWithFormat:@"%p", self];
}

- (id)copyVia:(NSMutableDictionary *)table{
    LAHModel *copy = [super copyVia:table];
    table[self.identifier] = copy;

    copy.key = _key;
    
    copy.range = [[NSArray alloc] initWithArray:_range copyItems:YES];
    [copy.range release];
    
    return copy;
}

#pragma mark - States
- (void)saveStateForKey:(id)key{
    NSAssert(_states[key] == nil, @"Will overwrite state for key '%@'", key);
    
    //New state
    NSMutableDictionary *state = [[NSMutableDictionary alloc] initWithCapacity:3];
    self.states[key] = state;
    [state release];
    
    //Setup state content
    if (self.data) state[gKeyContainer] = self.data;
    state[gKeyNeedUpdate] = [NSNumber numberWithBool:_needUpdate];
    
    //Children states
    for (LAHModel *child in _children) {
        [child saveStateForKey:key];
    }
}

- (void)restoreStateForKey:(id)key{
    NSDictionary *state = _states[key];
    self.needUpdate = [state[gKeyNeedUpdate] boolValue];
    self.data = state[gKeyContainer];

    [_states removeObjectForKey:key];
    
    //Children states
    for (LAHModel *child in _children) {
        [child restoreStateForKey:key];
    }
}

- (NSMutableDictionary *)states{
    if (!_states) {
        _states = [[NSMutableDictionary alloc] init];
    }
    return _states;
}

- (void)refresh{
    [super refresh];
}

#pragma mark - recursion
- (void)recieve:(LAHModel*)object{
    LAHNoteQuick(@"%@\tneedUpdate %@\tdata %p", self.desc, BOOLStr(_needUpdate), self.data);
}

- (BOOL)needUpdate{
    LAHModel *father = (LAHModel *)_father;
    BOOL needUpdate = father.needUpdate || _needUpdate;
    return needUpdate;
}

#pragma mark - Log
- (NSString *)tagNameInfo{
    return @"model";
}

- (NSString *)attributesInfo{
    NSMutableString *info = [NSMutableString stringWithString:[super attributesInfo]];
    if (_key) [info appendFormat:@"  key=\"%@\"", _key];
    if (_range && _range.count != 0) {
        [info appendFormat:@"  range=%@", _range.dividedDesc];
    }
    return info;
}

@end

NSString * const gKeyContainer = @"Con";
NSString * const gKeyNeedUpdate = @"NUp";


