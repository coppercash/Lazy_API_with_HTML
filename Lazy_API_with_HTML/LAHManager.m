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
@property(nonatomic, retain)NSMutableArray *networks;
@end

@implementation LAHManager
@synthesize operations = _operations, delegate = _delegate;
#pragma mark - Life Cycle
- (id)init{
    self = [super init];
    if (self) {
        [self.operations = [[NSMutableArray alloc] init] release];
        [self.networks = [[NSMutableArray alloc] init] release];
    }
    return self;
}

- (void)dealloc{
    self.operations = nil;
    self.networks = nil;
    [super dealloc];
}

#pragma mark - Operation
- (LAHOperation*)operationWithPath:(NSString*)path rootContainer:(LAHConstruct*)rootContainer firstChild:(LAHRecognizer*)firstChild variadicChildren:(va_list)children{
    LAHOperation *operation = [[LAHOperation alloc] initWithPath:path rootContainer:rootContainer firstChild:firstChild variadicChildren:children];
    [_operations addObject:operation];
    operation.delegate = self;
    
    [operation release];
    return operation;
}

- (LAHOperation*)operationWithPath:(NSString*)path rootContainer:(LAHConstruct*)rootContainer children:(LAHRecognizer*)firstChild, ... NS_REQUIRES_NIL_TERMINATION{
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
        [_operations addObject:operation];
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

#pragma mark - LAHDelegate
- (void)downloader:(LAHOperation *)operation didFetch:(id)info{
    
    NSUInteger c =  _operations.count;
    [_operations removeObject:operation];
    NSLog(@"+operations:\t%d\t->\t%d", c, _operations.count);
     
}

- (id)downloader:(LAHDownloader*)downloader needFileAtPath:(NSString*)path{
    return nil;
}

#pragma mark - Network Management
- (void)addNetwork:(id)network{
    if (_networks.count == 0 && _delegate
        && [_delegate respondsToSelector:@selector(managerStartRunning:)]){
        [_delegate managerStartRunning:self];
    }
    NSUInteger c =  _networks.count;
    [_networks addObject:network];
    NSLog(@"+networks<%p>:\t%d\t->\t%d",network, c, _networks.count);
}

- (void)removeNetwork:(id)network{
    NSUInteger c =  _networks.count;
    [_networks removeObject:network];
    NSLog(@"-networks<%p>:\t%d\t->\t%d",network, c, _networks.count);
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
}

@end