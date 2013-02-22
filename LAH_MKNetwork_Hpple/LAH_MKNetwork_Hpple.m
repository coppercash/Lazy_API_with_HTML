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
    [_engine cancelAllOperations];
    [_engine release]; _engine = nil;
    [super dealloc];
}

- (void)downloader:(LAHOperation *)operation didFetch:(id)info{
    [_operations removeObject:operation];
}

- (id)downloader:(LAHDownloader*)downloader needFileAtPath:(NSString*)path{
    MKNetworkOperation *op = [[_engine operationWithPath:path] autorelease];
    
    LAHOperation *operation = downloader.recursiveOperation;
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData *rd = [completedOperation responseData];
        TFHpple * doc = [[TFHpple alloc] initWithHTMLData:rd];
        TFHppleElement<LAHHTMLElement> *root = (TFHppleElement<LAHHTMLElement>*)[doc peekAtSearchWithXPathQuery:@"/html/body"];
        [operation awakeDownloaderForKey:op withElement:root];
        
        [doc release];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [operation handleError:error];
    }];
    [_engine enqueueOperation:op];
    
    return op;
}

@end
