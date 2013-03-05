//
//  LAHGreffier+Hpple+MKNetwrokKit.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/6/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAH_MKNetwork_Hpple.h"
#import "LAHOperation.h"

@implementation LAH_MKNetworkKit_Hpple
- (id)initWithHostName:(NSString *)hostName{
    self = [super init];
    if (self) {
        _engine = [[MKNetworkEngine alloc] initWithHostName:hostName];
        [_engine useCache];
    }
    return self;
}

- (void)dealloc{
    [self cancel];
    [_engine release]; _engine = nil;
    [super dealloc];
}

- (void)cancel{
    //[_engine cancelAllOperations];
    [self cancelAllNetworks];
    [_operations removeAllObjects];
}
/*
- (void)downloader:(LAHOperation *)operation didFetch:(id)info{
    [_operations removeObject:operation];
}*/

- (id)downloader:(LAHDownloader*)downloader needFileAtPath:(NSString*)path{
    MKNetworkOperation *op = [[_engine operationWithPath:path] autorelease];
    
    LAHOperation *operation = downloader.recursiveOperation;
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [self removeNetwork:op];
        NSData *rd = [completedOperation responseData];
        TFHpple * doc = [[TFHpple alloc] initWithHTMLData:rd];
        TFHppleElement<LAHHTMLElement> *root = (TFHppleElement<LAHHTMLElement>*)[doc peekAtSearchWithXPathQuery:@"/html/body"];
        [operation awakeDownloaderForKey:op withElement:root];
        
        [doc release];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self removeNetwork:op];
        [operation handleError:error];
    }];
    
    [_engine enqueueOperation:op];
    [self addNetwork:op];
    
    return op;  //op is a key for dictionary
}

- (void)cancelAllNetworks{
    [_networks makeObjectsPerformSelector:@selector(cancel)];
    [super cancelAllNetworks];
}

#pragma mark - Enhance
- (void)fetchImage:(NSString *)path completion:(LAHImage)completion corrector:(LAHError)corrector{
    MKNetworkOperation *op = [_engine operationWithURLString:path];
    op.shouldCacheResponseEvenIfProtocolIsHTTPS = YES;
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [self removeNetwork:op];
        if (completion){
            completion(completedOperation.responseImage);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self removeNetwork:op];
        if (corrector) {
            corrector(error);
        }
    }];

    [_engine enqueueOperation:op];
    [self addNetwork:op];
}

- (void)downloadData:(NSString *)path toLocal:(NSString *)localPath completion:(LAHDownload)completion corrector:(LAHError)corrector{
    MKNetworkOperation *op = [_engine operationWithURLString:path];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [self removeNetwork:op];
        
        NSData *data = completedOperation.responseData;
        NSError *dataErr = nil;
        BOOL success = [data writeToFile:localPath options:NSDataWritingAtomic error:&dataErr];
        
        if (success) {
            if (completion)  completion(data);
        }else{
            if (corrector)  corrector(dataErr);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self removeNetwork:op];
        if (corrector) corrector(error);
    }];
    
    [_engine enqueueOperation:op];
    [self addNetwork:op];
}

@end
