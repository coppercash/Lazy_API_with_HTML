//
//  LAHManager.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/8/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHManager.h"
#import "LAHOperation.h"
@implementation LAHManager

#pragma mark - Life Cycle
- (id)init{
    self = [super init];
    if (self) {
        _operations = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc{
    [_operations release]; _operations = nil;
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
- (void)downloader:(LAHOperation *)operation didFetch:(id)info{}

- (id)downloader:(LAHDownloader*)downloader needFileAtPath:(NSString*)path{
    return nil;
}

@end
