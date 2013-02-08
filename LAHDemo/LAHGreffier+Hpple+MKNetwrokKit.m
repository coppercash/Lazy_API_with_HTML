//
//  LAHGreffier+Hpple+MKNetwrokKit.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/6/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHGreffier+Hpple+MKNetwrokKit.h"
#import "LAHGreffier.h"
#import "TFHpple.h"
#import "TFHppleElement.h"

@implementation LAHGreffier_Hpple_MKNetwrokKit
@synthesize greffier = _greffier, engine = _engine;
/*
- (id)initWithRootDownloader:(LAHDownloader *)root{
    self = [super initWithRootDownloader:root];
    if (self) {        
        _engine = [[MKNetworkEngine alloc] initWithHostName:@"www.51voa.com"];
        [_engine useCache];

        _rootDownloader.dataSource = self;
        _rootDownloader.delegate = self;
    }
    return self;
}*/

- (id)initWithHostName:(NSString *)hostName{
    self = [super init];
    if (self) {
        _trees = [[NSMutableArray alloc] init];
        //_greffier = [[LAHGreffier alloc] init];
        _engine = [[MKNetworkEngine alloc] initWithHostName:hostName];
        [_engine useCache];
    }
    return self;
}

- (void)dealloc{
    [_trees release]; _trees = nil;
    [_greffier release]; _greffier = nil;
    //[_engine cancelAllOperations];
    [_engine release]; _engine = nil;
    [super dealloc];
}

- (void)startWithTreeRoot:(LAHDownloader *)root{
    if (root == nil) return;
    [_trees addObject:root];
    root.greffier = _greffier;
    //root.dataSource = self;
    //root.delegate = self;
    [root handleElement:nil atIndex:0];
}

- (void)downloader:(LAHDownloader *)downloader didFetch:(id)info{
    NSLog(@"%@", info);
}

- (id)downloader:(LAHDownloader*)downloader needFileAtPath:(NSString*)path{
    MKNetworkOperation *op = [[_engine operationWithPath:path] autorelease];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSData *rd = [completedOperation responseData];
        TFHpple * doc = [[TFHpple alloc] initWithHTMLData:rd];
        TFHppleElement<LAHHTMLElement> *root = (TFHppleElement<LAHHTMLElement>*)[doc peekAtSearchWithXPathQuery:@"/html/body"];
        [doc release];

        //LAHDownloader *downloader = [_greffier downloaderForKey:op];
        //[downloader continueHandlingElement:root];
        
        [_greffier awakeDownloaderForKey:op withElement:root];
        
        [_trees removeObject:downloader];
    } errorHandler:nil];
    [_engine enqueueOperation:op];
    
    return op;
}

@end
