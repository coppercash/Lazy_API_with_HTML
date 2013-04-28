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
@property (nonatomic, assign)NSInteger currentIndex;
- (void)setupOperationWithString:(NSString *)string key:(NSString *)key;
@end

@implementation LAHModelsGroup
@synthesize operations = _operations, currentIndex = _currentIndex;
@dynamic operation;

#pragma mark - Class Basic
- (id)initWithCommand:(NSString *)string key:(NSString *)key{
    NSAssert(string != nil && key != nil, @"%@ can't work without LAHString or key.", NSStringFromClass(self.class));
    if (!string || !key) return nil;
    
    self = [super init];
    if (self) {
        [self setupOperationWithString:string key:key];
        
        if (_operations.count <= 0) return nil;
       
        self.currentIndex = 0;
    }
    return self;
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

#pragma mark - Operations
- (void)setupOperationWithString:(NSString *)string key:(NSString *)key{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [LAHInterpreter interpretString:string intoDictionary:dictionary];
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:dictionary.count];
    
    NSString *keyWord = key.copy;
    LAHOperation *ope = nil;
    do {
        
        NSString *iteration = [keyWord stringByAppendingFormat:@"%d", collector.count];
        ope = [dictionary objectForKey:iteration];
        if (!ope) continue;

        ope.delegate = self;
        [collector addObject:ope];
        
    } while (ope);
    
    NSAssert(collector.count > 0, @"%@ needs at least 1 %@", NSStringFromClass(self.class), key);
    
    self.operations = [[NSArray alloc] initWithArray:collector];
    
    [self.operations release];
    [keyWord release];
    [dictionary release];
}

- (LAHOperation *)operationAtIndex:(NSInteger)index{
    NSAssert(NSLocationInRange(index, NSMakeRange(0, _operations.count)), @"Operation at %d out of range.", index);
    if ( !NSLocationInRange(index, NSMakeRange(0, _operations.count)) ) return nil;

    LAHOperation *ope = [_operations objectAtIndex:index];
    [ope refresh];
    return ope;
}

- (LAHOperation *)operation{
    LAHOperation *operation = [self operationAtIndex:_currentIndex];
    return operation;
}

#pragma mark - Push & Pop
- (void)pushWithLink:(NSString *)link{
    NSInteger target = _currentIndex + 1;
    LAHOperation *ope = [self operationAtIndex:target];
    if (ope) {
        self.currentIndex = target;
        if (link) ope.page.link = link;
    }
}

- (void)popNumberOfDegree:(NSUInteger)number{
    NSInteger target = _currentIndex - number;
    LAHOperation *ope = [self operationAtIndex:target];
    if (ope) {
        self.currentIndex = target;
    }
}

- (void)pop{
    [self popNumberOfDegree:1];
}

@end
