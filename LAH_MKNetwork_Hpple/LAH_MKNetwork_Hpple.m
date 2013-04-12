//
//  LAHGreffier+Hpple+MKNetwrokKit.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/6/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAH_MKNetwork_Hpple.h"
#import "LAHOperation.h"
@interface LAH_MKNetworkKit_Hpple ()
@property(nonatomic, retain)MKNetworkEngine *engine;
@property(nonatomic, retain)NSMutableArray *networks;
- (void)addNetwork:(id)network;
- (void)removeNetwork:(id)network;
@end

@implementation LAH_MKNetworkKit_Hpple
@synthesize engine = _engine;
#pragma mark - Life Cycle
- (id)initWithHostName:(NSString *)hostName{
    self = [super init];
    if (self) {
        [self.networks = [[NSMutableArray alloc] init] release];
        [self.engine = [[MKNetworkEngine alloc] initWithHostName:hostName] release];
        [_engine useCache];
    }
    return self;
}

- (void)dealloc{
    [self cancel];
    self.engine = nil;
    self.networks = nil;
    [super dealloc];
}

#pragma mark - Operations Management
- (void)cancel{
    [super cancel];
    [_networks makeObjectsPerformSelector:@selector(cancel)];
    [_networks removeAllObjects];
}

- (NSUInteger)numberOfOperations{
    NSUInteger number = _operations.count + _networks.count;
    return number;
}

- (void)addNetwork:(id)network{
    if (_delegate && [_delegate respondsToSelector:@selector(managerStartRunning:)]
        && self.numberOfOperations == 0){
        [_delegate managerStartRunning:self];
    }
    [_networks addObject:network];
}

- (void)removeNetwork:(id)network{
    [_networks removeObject:network];
    if (_delegate && [_delegate respondsToSelector:@selector(managerStopRunnning:finish:)]
        && self.numberOfOperations == 0){
        [_delegate managerStopRunnning:self finish:YES];
    }
}

#pragma mark - LAHDelegate
- (id)downloader:(LAHDownloader* )operation needFileAtPath:(NSString*)path{
    __block MKNetworkOperation *op = [_engine operationWithPath:path];
    __block LAHOperation *bOperation = operation.recursiveOperation;
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData *rd = [completedOperation responseData];
        TFHpple * doc = [[TFHpple alloc] initWithHTMLData:rd];
        TFHppleElement<LAHHTMLElement> *root = (TFHppleElement<LAHHTMLElement>*)[doc peekAtSearchWithXPathQuery:@"/html/body"];
        [bOperation awakeDownloaderForKey:op withElement:root];
        
        [doc release];
        if (!completedOperation.isCachedResponse) [bOperation removeNetwork:op];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [bOperation handleError:error];
        NSAssert(error == nil, @"%@", error.userInfo);
        if (!completedOperation.isCachedResponse) [bOperation removeNetwork:op];
    }];
    
    [_engine enqueueOperation:op forceReload:YES];
    [bOperation addNetwork:op];
    
    [super downloader:operation needFileAtPath:path];
    return op;  //op is a key for dictionary
}

- (void)operation:(LAHOperation *)operation didFetch:(id)info{
    [super operation:operation didFetch:info];
}

- (void)operation:(LAHOperation *)operation willCancelNetworks:(NSArray *)networks{
    [networks makeObjectsPerformSelector:@selector(cancel)];
}

- (NSString *)operationNeedsHostName:(LAHOperation *)operation{
    return _engine.readonlyHostName;
}

#pragma mark - Enhance
- (void)fetchImage:(NSString *)path completion:(LAHImage)completion corrector:(LAHError)corrector{
    MKNetworkOperation *op = [_engine operationWithURLString:path];
    op.shouldCacheResponseEvenIfProtocolIsHTTPS = YES;
    
    __block LAH_MKNetworkKit_Hpple *bSelf = self;
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        if (completion){
            completion(completedOperation.responseImage);
        }
        if (!completedOperation.isCachedResponse) [bSelf removeNetwork:op];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (corrector) {
            corrector(error);
        }
        if (!completedOperation.isCachedResponse) [bSelf removeNetwork:op];
    }];

    [_engine enqueueOperation:op];
    [self addNetwork:op];
}

- (void)downloadData:(NSString *)path toLocal:(NSString *)localPath completion:(LAHDownload)completion corrector:(LAHError)corrector{
    MKNetworkOperation *op = [_engine operationWithURLString:path];
    
    __block LAH_MKNetworkKit_Hpple *bSelf = self;
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData *data = completedOperation.responseData;
        NSError *dataErr = nil;
        BOOL success = [data writeToFile:localPath options:NSDataWritingAtomic error:&dataErr];
        
        if (success) {
            if (completion)  completion(data);
        }else{
            if (corrector)  corrector(dataErr);
        }
        
        if (!completedOperation.isCachedResponse) [bSelf removeNetwork:op];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (corrector) corrector(error);
        
        if (!completedOperation.isCachedResponse) [bSelf removeNetwork:op];
    }];
    
    [_engine enqueueOperation:op];
    [self addNetwork:op];
}

@end
