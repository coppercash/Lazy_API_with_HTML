//
//  LAHModelsGroupMH.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 4/12/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LMHModelsGroup.h"
#import "LAHPage.h"
#import "MKNetworkEngine.h"
#import "Hpple/TFHpple.h"
#import "LAHInterface.h"

@interface LMHModelsGroup ()
@property(nonatomic, retain)MKNetworkEngine *engine;
@end

@implementation LMHModelsGroup
@synthesize engine = _engine;

- (id)initWithCommand:(NSString *)string key:(NSString *)key{
    self = [super initWithCommand:string key:key];
    if (self) {
        LAHOperation *rootOpe = self.operation;
        
        NSString *link = rootOpe.page.link;
        NSURL *url = [[NSURL alloc] initWithString:rootOpe.page.link];
        NSString *hostStr = url.host;
        NSString *hostName = hostStr ? hostStr : link;
        
        [self.engine = [[MKNetworkEngine alloc] initWithHostName:hostName] release];
        
        [url release];
    }
    return self;
}

- (NSURL *)resourceURLWithOfLink:(NSString *)link{
    NSURL *url = [[NSURL alloc] initWithString:link];
    if (!url.host) {
        //NSString *scheme = @"http";
        NSString *host = _engine.readonlyHostName;
        NSString *path = [host stringByAppendingPathComponent:link];
        url = [[NSURL alloc] initWithString:path];

        //url = [[NSURL alloc] initWithScheme:scheme host:host path:link];
    }
    
    return url;
}

#pragma mark - LAHDelegate
- (NSDictionary *)operation:(LAHOperation *)operation needPageAtLink:(NSString *)link{
    MKNetworkOperation *netOpe = [_engine operationWithLink:link];

    __block LAHOperation *lahOpe = operation;
    [netOpe addCompletionHandler:^(MKNetworkOperation *completedOperation) {

        LAHEle root = [completedOperation htmlWithXPath:@"/html/body"];
        [lahOpe awakePageForKey:completedOperation.url withElement:root];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [lahOpe handleError:error withKey:completedOperation.url];
        
        NSAssert(error == nil, @"%@", error.userInfo);
    }];
    
    [_engine enqueueOperation:netOpe forceReload:YES];
    
    return @{LAHKeyRetNetOpe:netOpe, LAHKeyRetURL:netOpe.url};  //url string is a key for dictionary
}

- (void)operation:(LAHOperation *)operation willCancelNetworks:(NSArray *)networks{
    [networks makeObjectsPerformSelector:@selector(cancel)];
}

- (NSString *)operationNeedsHostName:(LAHOperation *)operation{
    return _engine.readonlyHostName;
}

@end


@implementation MKNetworkOperation (HTML)

- (LAHEle)htmlWithXPath:(NSString *)xpath{
    NSData *rd = self.responseData;
    TFHpple * doc = [[TFHpple alloc] initWithHTMLData:rd];
    TFHppleElement<LAHHTMLElement> *root = (TFHppleElement<LAHHTMLElement>*)[doc peekAtSearchWithXPathQuery:xpath];
    
    [doc release];
    return root;
}

@end

@implementation MKNetworkEngine (LAH)

- (MKNetworkOperation *)operationWithLink:(NSString *)link{
    NSURL *url = [[NSURL alloc] initWithString:link];
    MKNetworkOperation *netOpe = nil;
    if (url.host) {
        netOpe = [self operationWithURLString:link];
    } else {
        netOpe = [self operationWithPath:link];
    }
    [url release];
    NSAssert(netOpe != nil, @"Can't generate Network Operation");
    
    return netOpe;
}

@end