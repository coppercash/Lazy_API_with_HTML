//
//  LAHElementFetcher.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/4/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol LAHHTMLElement;
@class LAHElementRecognizer;
@interface LAHElementFetcher : NSObject {
    BOOL _isLazy;
    LAHElementRecognizer *_recognizerChain;
    NSArray *_matchedElements;
}
@property(nonatomic, assign)BOOL isLazy;
@property(nonatomic, retain)LAHElementRecognizer *recognizerChain;
@property(nonatomic, readonly)NSArray *matchedElements;
- (NSArray*)fetchElementsWithRootElement:(id<LAHHTMLElement>)rootElement;
@end
