//
//  LBEHTMLProtocols.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/4/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//


@protocol LAHHTMLElement <NSObject>
- (NSString*)tagName;
- (NSString*)text;
- (NSDictionary*)attributes;
- (NSArray*)children;
- (BOOL)isTextNode;
@end
#define LAHEle id<LAHHTMLElement>

@class LAHOperation, LAHDownloader;
typedef NSString*(^LAHPropertyFetcher)(id<LAHHTMLElement> element);
typedef BOOL(^LAHRule)(id<LAHHTMLElement> element);
typedef void(^LAHCompletion)(LAHOperation *operation);

@protocol LAHDelegate <NSObject>
- (id)downloader:(LAHDownloader*)downloader needFileAtPath:(NSString*)path;
- (void)downloader:(LAHOperation*)operation didFetch:(id)info;
@end

//#define DEBUG_MODE
#ifdef DEBUG_MODE

#define DLogElement(x) NSLog(@"\n%@\t%@\n%@", (x).tagName, (x).text, (x).attributes);
#define DLogFetcher(x) NSLog(@"\n%@\t%@\n%@\n%@", (x).tagName, (x).key, (x).text, (x).attributes);

#else

#define DLogElement(x)
#define DLogFetcher(x)

#endif
