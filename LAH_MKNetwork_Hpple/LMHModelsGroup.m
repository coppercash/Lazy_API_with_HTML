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
#import "LAHOperation.h"

@interface LMHModelsGroup ()
@property(nonatomic, retain)MKNetworkEngine *engine;
@property(nonatomic, retain)NSMutableArray *copiedOpes;
@end

@implementation LMHModelsGroup
@synthesize engine = _engine;
@synthesize copiedOpes;

- (id)initWithCommand:(NSString *)string key:(NSString *)key{
    self = [super initWithCommand:string key:key];
    if (self) {
        
        for (LAHOperation *ope in _operations) {
            ope.delegate = self;
        }
        
        LAHOperation *rootOpe = _operations[0];
        
        NSString *link = rootOpe.page.link;
        NSURL *url = [[NSURL alloc] initWithString:rootOpe.page.link];
        NSString *hostStr = url.host;
        NSString *hostName = hostStr ? hostStr : link;
        
        [self.engine = [[MKNetworkEngine alloc] initWithHostName:hostName] release];
        
        [url release];
    }
    return self;
}

- (void)dealloc{
    
    [super dealloc];
}

- (NSURL *)resourceURLWithOfLink:(NSString *)link{
    NSURL *url = [[NSURL alloc] initWithString:link];
    if (!url.host) {
        NSString *host = _engine.readonlyHostName;
        NSString *path = [host stringByAppendingPathComponent:link];
        url = [[NSURL alloc] initWithString:path];
    }
    
    return url;
}

- (NSMutableArray *)copiedOpes{
    if (!_copiedOpes) {
        _copiedOpes = [[NSMutableArray alloc] init];
    }
    return _copiedOpes;
}

- (LAHOperation *)operationAtIndex:(NSInteger)index{
    LAHOperation *copied = [super operationAtIndex:index];
    
    [self.copiedOpes addObject:copied];
    
    return copied;
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
        NSLog(@"%@", error.userInfo);
        
    }];
    
    [_engine enqueueOperation:netOpe forceReload:YES];
    
    //LAHKeyRetNetOpe used to cancel ALHOperation, url is a key for awaking the page when request return.
    return @{LAHKeyRetNetOpe:netOpe, LAHKeyRetURL:netOpe.url};  
}

- (void)operation:(LAHOperation *)operation willCancelNetworks:(NSArray *)networks{
    [networks makeObjectsPerformSelector:@selector(cancel)];
}

- (NSString *)operationNeedsHostName:(LAHOperation *)operation{
    return _engine.readonlyHostName;
}

- (void)operationFinished:(LAHOperation *)operation{
    [self.copiedOpes removeObject:operation];
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