//
//  LAHManager.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/8/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHManager.h"
#import "LAHOperation.h"

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

#pragma mark - LAHDelegate
- (void)downloader:(LAHOperation *)operation didFetch:(id)info{
    [_operations removeObject:operation];
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
}

@end

NSString * const gLAHImg = @"img";
NSString * const gLAHSrc = @"src";
NSString * const gLAHP = @"p";
NSString * const gLAHSpan = @"span";
NSString * const gLAHDiv = @"div";



