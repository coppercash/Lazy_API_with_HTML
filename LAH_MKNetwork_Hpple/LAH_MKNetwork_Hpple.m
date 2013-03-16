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
@end

@implementation LAH_MKNetworkKit_Hpple
@synthesize engine = _engine;
- (id)initWithHostName:(NSString *)hostName{
    self = [super init];
    if (self) {
        [self.engine = [[MKNetworkEngine alloc] initWithHostName:hostName] release];
        [_engine useCache];
    }
    return self;
}

- (void)dealloc{
    [self cancel];
    self.engine = nil;
    [super dealloc];
}

- (void)cancel{
    [self cancelAllNetworks];
    [_operations removeAllObjects];
}

- (void)cancelAllNetworks{
    [_networks makeObjectsPerformSelector:@selector(cancel)];
    [super cancelAllNetworks];
}

- (void)downloader:(LAHOperation *)operation didFetch:(id)info{
    [self cancelAllNetworks];
    [super downloader:operation didFetch:info];
}

- (id)downloader:(LAHDownloader*)downloader needFileAtPath:(NSString*)path{
    __block MKNetworkOperation *op = [_engine operationWithPath:path];
    __block LAH_MKNetworkKit_Hpple *bSelf = self;
    __block LAHOperation *operation = downloader.recursiveOperation;
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData *rd = [completedOperation responseData];
        TFHpple * doc = [[TFHpple alloc] initWithHTMLData:rd];
        TFHppleElement<LAHHTMLElement> *root = (TFHppleElement<LAHHTMLElement>*)[doc peekAtSearchWithXPathQuery:@"/html/body"];
        [operation awakeDownloaderForKey:op withElement:root];
        
        if (!completedOperation.isCachedResponse) [bSelf removeNetwork:op];
        [doc release];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [operation handleError:error];
        if (!completedOperation.isCachedResponse) [bSelf removeNetwork:op];
    }];
    
    [_engine enqueueOperation:op];
    [self addNetwork:op];
    
    return op;  //op is a key for dictionary
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
