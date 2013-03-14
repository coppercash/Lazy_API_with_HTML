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

extern NSString * const LAHEntArr;
extern NSString * const LAHEntDic;
extern NSString * const LAHEntFet;
extern NSString * const LAHEntOpe;
extern NSString * const LAHEntRec;
extern NSString * const LAHEntDow;

extern NSString * const LAHParaId;
extern NSString * const LAHParaKey;
extern NSString * const LAHParaSym;
extern NSString * const LAHParaRoot;
extern NSString * const LAHParaPath;
extern NSString * const LAHParaTag;
extern NSString * const LAHParaClass;
extern NSString * const LAHParaText;
extern NSString * const LAHParaRange;
extern NSString * const LAHParaIndex;
extern NSString * const LAHParaIsText;

extern NSString * const LAHValText;
extern NSString * const LAHValTag;
extern NSString * const LAHValNone;
extern NSString * const LAHValAll;
extern NSString * const LAHParaDefault;

extern NSString * const gLAHImg;
extern NSString * const gLAHSrc;
extern NSString * const gLAHP;
extern NSString * const gLAHA;
extern NSString * const gLAHSpan;
extern NSString * const gLAHDiv;
extern NSString * const gLAHHref;