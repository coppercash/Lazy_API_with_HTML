//
//  LAHModelsGroup.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 4/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHModelsGroup.h"
#import "LAHInterpreter.h"
#import "LAHOperation.h"
#import "LAHPage.h"

@interface LAHModelsGroup ()
@property(nonatomic, retain)NSDictionary *containerCache;
- (void)cacheContainerWithCommand:(NSString *)command;
@end

@implementation LAHModelsGroup
@synthesize operations = _operations;
@synthesize containerCache = _containerCache;
@dynamic operation;

#pragma mark - Class Basic
- (id)initWithCommand:(NSString *)command key:(NSString *)key{
    NSAssert(command != nil && key != nil, @"%@ can't work without LAHString or key.", NSStringFromClass(self.class));
    if (!command || !key) return nil;
    
    self = [super init];
    if (self) {
        [self cacheContainerWithCommand:command];
        [self setupOperationWithKey:key];
        self.containerCache = nil;
        
        if (_operations.count <= 0) return nil;
       
    }
    return self;
}

- (void)dealloc{
    self.containerCache = nil;
    self.operations = nil;
    
    [super dealloc];
}

- (NSString *)description{
    NSMutableString *description = [[NSMutableString alloc] init];
    for (LAHOperation *ope in _operations) {
        [description appendString:@"\n"];
        [description appendString:ope.description];
        [description appendString:@"\n"];
    }
    return description;
}

#pragma mark - Interpret
- (void)cacheContainerWithCommand:(NSString *)command{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [LAHInterpreter interpretString:command intoDictionary:dictionary];
    self.containerCache = dictionary;
    [dictionary release];
}

- (void)setupOperationWithKey:(NSString *)key{
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:_containerCache.count];

    NSString *keyWord = key.copy;
    LAHOperation *ope = nil;
    do {
        
        NSString *iteration = [keyWord stringByAppendingFormat:@"%d", collector.count];
        ope = _containerCache[iteration];
        
        if (!ope) continue;
        [collector addObject:ope];
        
    } while (ope);
    
    NSAssert(collector.count > 0, @"%@ needs at least 1 %@", NSStringFromClass(self.class), key);
    
    self.operations = [[NSArray alloc] initWithArray:collector];
    [self.operations release];
    [keyWord release];
}


#pragma mark - Operations
- (LAHOperation *)operationAtIndex:(NSInteger)index{
    NSAssert(NSLocationInRange(index, NSMakeRange(0, _operations.count)), @"Operation at %d out of range.", index);
    if ( !NSLocationInRange(index, NSMakeRange(0, _operations.count)) ) return nil;

    LAHOperation *ope = [_operations objectAtIndex:index];
    [ope refresh];
    return ope;
}

@end
