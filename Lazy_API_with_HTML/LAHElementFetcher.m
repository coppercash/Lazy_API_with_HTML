//
//  LAHElementFetcher.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/4/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHElementFetcher.h"
#import "LAHElementRecognizer.h"
#import "LAHHTMLProtocols.h"

@implementation LAHElementFetcher
@synthesize isLazy = _isLazy;
@synthesize recognizerChain = _recognizerChain;
@synthesize matchedElements = _matchedElements;

- (id)init{
    self = [super init];
    if (self) {
        self.isLazy = YES;
    }
    return self;
}

- (void)dealloc{
    SafeMemberRelease(_recognizerChain);
    SafeMemberRelease(_matchedElements);
    [super dealloc];
}

- (NSArray*)fetchElementsWithRootElement:(id<LAHHTMLElement>)rootElement{
    SafeRetain(rootElement);
    NSMutableArray *mEC = [[NSMutableArray alloc] initWithCapacity:1];    //matched elements container
    BOOL hasFound;
    [self matchedElements:mEC from:rootElement.children hasFound:&hasFound];
    
    if (_matchedElements != nil) SafeMemberRelease(_matchedElements);
    _matchedElements = [[NSArray alloc] initWithArray:mEC];
    SafeRelease(mEC);
    return _matchedElements;
}

- (void)matchedElements:(NSMutableArray*)container from:(NSArray*)elements hasFound:(BOOL*)refHasFound{
    if (_isLazy && *refHasFound) return;
    NSUInteger nME = [_recognizerChain matchedElements:container from:elements];    //number of matched elements
    if (nME == 0) {
        for (id<LAHHTMLElement> element in elements) {
            [self matchedElements:container from:element.children hasFound:refHasFound];
        }
    }else if (_isLazy){
        *refHasFound = YES;
    }
}

@end