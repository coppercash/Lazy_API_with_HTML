//
//  LAHInteface.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 3/8/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

@protocol LAHHTMLElement <NSObject>
- (NSString*)tagName;
- (NSString*)text;
- (NSDictionary*)attributes;
- (NSArray*)children;
- (BOOL)isTextNode;
@end

@class LAHOperation, LAHDownloader;
typedef NSString*(^LAHPropertyFetcher)(id<LAHHTMLElement> element);
typedef BOOL(^LAHRule)(id<LAHHTMLElement> element);
typedef void(^LAHCompletion)(LAHOperation *operation);
typedef void(^LAHCorrector)(LAHOperation *operation, NSError* error);
typedef id<LAHHTMLElement> LAHEle;

@protocol LAHDelegate <NSObject>
- (id)downloader:(LAHDownloader*)downloader needFileAtPath:(NSString*)path;
- (void)downloader:(LAHOperation*)operation didFetch:(id)info;
@end

extern NSString * const gLAHImg;
extern NSString * const gLAHSrc;
extern NSString * const gLAHP;
extern NSString * const gLAHA;
extern NSString * const gLAHSpan;
extern NSString * const gLAHDiv;
extern NSString * const gLAHHref;
