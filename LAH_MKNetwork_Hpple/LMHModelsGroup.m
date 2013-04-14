//
//  LAHModelsGroupMH.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 4/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LMHModelsGroup.h"

@interface LMHModelsGroup ()
@property(nonatomic, retain)MKNetworkEngine *engine;
@end

@implementation LMHModelsGroup
@synthesize engine = _engine;

- (id)initWithCommand:(NSString *)string key:(NSString *)key{
    self = [super initWithCommand:string key:key];
    if (self) {
        LAHOperation *rootOpe = self.operation;
        
        NSURL *url = [[NSURL alloc] initWithString:rootOpe.link];
        NSString *hostName = url.host;
        
        [self.engine = [[MKNetworkEngine alloc] initWithHostName:hostName] release];
        [_engine useCache];
        
        [url release];
    }
    return self;
}

#pragma mark - LAHDelegate
- (id)downloader:(LAHDownloader* )operation needFileAtPath:(NSString*)path{
    
    NSURL *url = [[NSURL alloc] initWithString:path];
    __block MKNetworkOperation *op = [_engine operationWithPath:url.relativePath];
    __block LAHOperation *bOperation = operation.recursiveOperation;
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSData *rd = [completedOperation responseData];
        TFHpple * doc = [[TFHpple alloc] initWithHTMLData:rd];
        TFHppleElement<LAHHTMLElement> *root = (TFHppleElement<LAHHTMLElement>*)[doc peekAtSearchWithXPathQuery:@"/html/body"];
        
        [bOperation awakeDownloaderForKey:op withElement:root];
        
        if (!completedOperation.isCachedResponse) [bOperation removeNetwork:op];
        
        [doc release];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        NSAssert(error == nil, @"%@", error.userInfo);
        
        [bOperation handleError:error];
        
        if (!completedOperation.isCachedResponse) [bOperation removeNetwork:op];
        
    }];
    
    [_engine enqueueOperation:op forceReload:YES];
    [bOperation addNetwork:op];
    
    [url release];
    
    return op;  //op is a key for dictionary
}

- (void)operation:(LAHOperation *)operation willCancelNetworks:(NSArray *)networks{
    [networks makeObjectsPerformSelector:@selector(cancel)];
}

- (NSString *)operationNeedsHostName:(LAHOperation *)operation{
    return _engine.readonlyHostName;
}

@end
