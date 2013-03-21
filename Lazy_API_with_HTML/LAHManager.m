//
//  LAHManager.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/8/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHManager.h"
#import "LAHOperation.h"
#import "LAHInterpreter.h"

@interface LAHManager ()
@property(nonatomic, retain)NSMutableArray *operations;
- (void)addOperation:(LAHOperation *)operation;
- (void)removeOperation:(LAHOperation *)operation;
@end

@implementation LAHManager
@synthesize operations = _operations, delegate = _delegate;
#pragma mark - Life Cycle
- (id)init{
    self = [super init];
    if (self) {
        [self.operations = [[NSMutableArray alloc] init] release];
    }
    return self;
}

- (void)dealloc{
    [self cancel];
    self.operations = nil;
    [super dealloc];
}

#pragma mark - Operation
- (LAHOperation*)operationWithPath:(NSString*)path rootContainer:(LAHConstruct*)rootContainer firstChild:(LAHRecognizer*)firstChild variadicChildren:(va_list)children{
    LAHOperation *operation = [[LAHOperation alloc] initWithPath:path construct:rootContainer firstChild:firstChild variadicChildren:children];
    [self addOperation:operation];
    operation.delegate = self;
    
    [operation release];
    return operation;
}

- (LAHOperation*)operationWithPath:(NSString*)path rootContainer:(LAHConstruct*)rootContainer children:(LAHRecognizer*)firstChild, ...{
    va_list children;
    va_start(children, firstChild);
    LAHOperation *operaton = [self operationWithPath:path rootContainer:rootContainer firstChild:firstChild variadicChildren:children];
    va_end(children);
    return operaton;
}

- (LAHOperation *)operationWithFile:(NSString *)path key:(NSString *)key dictionary:(NSMutableDictionary *)dictionary{
    [LAHInterpreter interpretFile:path intoDictionary:dictionary];
    
    LAHOperation *operation = [dictionary objectForKey:key];
    NSAssert(operation != nil, @"Can't find LAOperation named \"%@\".", key);
    if (operation) {
        [self addOperation:operation];
        operation.delegate = self;
    }
    
    return operation;
}

- (LAHOperation *)operationWithFile:(NSString *)path key:(NSString *)key{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    LAHOperation *operation = [self operationWithFile:path key:key dictionary:dictionary];
    [dictionary release];
    return operation;
}

#pragma mark - Operations Management
- (void)addOperation:(LAHOperation *)operation{
    if (_delegate && [_delegate respondsToSelector:@selector(managerStartRunning:)] &&
        self.numberOfOperations == 0) {
        [_delegate managerStartRunning:self];
    }
    
#ifdef LAH_OPERATION_DEBUG
    NSUInteger c = _operations.count;
#endif
    [_operations addObject:operation];
#ifdef LAH_OPERATION_DEBUG
    NSString *opeInfo = [NSString stringWithFormat:@"%@\tOperations %d -> %d ADD %@",
                         self, c, _operations.count, operation];
    printf("\n%s\n", [opeInfo cStringUsingEncoding:NSASCIIStringEncoding]);
#endif
}

- (void)removeOperation:(LAHOperation *)operation{
    [operation retain];
    
#ifdef LAH_OPERATION_DEBUG
    NSUInteger c = _operations.count;
#endif
    [_operations removeObject:operation];
#ifdef LAH_OPERATION_DEBUG
    NSString *opeInfo = [NSString stringWithFormat:@"%@\tOperations %d -> %d REM %@",
                         self, c, _operations.count, operation];
    printf("\n%s\n", [opeInfo cStringUsingEncoding:NSASCIIStringEncoding]);
#endif
    
    if (_delegate && [_delegate respondsToSelector:@selector(managerStopRunnning:finish:)] &&
        self.numberOfOperations == 0) {
        [_delegate managerStopRunnning:self finish:YES];
    }
    [operation release];
}

- (NSUInteger)numberOfOperations{
    return _operations.count;
}

- (void)cancel{
    if (_delegate && [_delegate respondsToSelector:@selector(managerStopRunnning:finish:)] &&
        self.numberOfOperations != 0) {
        [_delegate managerStopRunnning:self finish:NO];
    }
    [_operations makeObjectsPerformSelector:@selector(cancel)];
    [_operations removeAllObjects];
}

#pragma mark - LAHDelegate
- (void)operation:(LAHOperation *)operation didFetch:(id)info{
    [self removeOperation:operation];
}

- (id)downloader:(LAHDownloader*)downloader needFileAtPath:(NSString*)path{
    return nil;
}

/*
- (void)addNetwork:(id)network{
    if (_networks.count == 0 && _delegate
        && [_delegate respondsToSelector:@selector(managerStartRunning:)]){
        [_delegate managerStartRunning:self];
    }
    [_networks addObject:network];
}

- (void)removeNetwork:(id)network{
    [_networks removeObject:network];
    if (_networks.count == 0
        && _delegate && [_delegate respondsToSelector:@selector(managerStopRunnning:finish:)]){
        [_delegate managerStopRunnning:self finish:YES];
    }
}

- (void)cancelAllNetworks{
    //Do cancel to every network
    [_networks removeAllObjects];
    if (_delegate && [_delegate respondsToSelector:@selector(managerStopRunnning:finish:)]){
        [_delegate managerStopRunnning:self finish:NO];
    }
}*/

@end