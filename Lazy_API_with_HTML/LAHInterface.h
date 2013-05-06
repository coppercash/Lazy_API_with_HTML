//
//  LAHInteface.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 3/8/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#define LAH_RULES_DEBUG
//#define LAH_OPERATION_DEBUG

#ifdef LAH_RULES_DEBUG
extern NSUInteger gRecLogDegree;
#endif

@protocol LAHHTMLElement <NSObject>
- (NSString*)tagName;
- (NSString*)text;
- (NSString*)content;
- (NSDictionary*)attributes;
- (NSArray*)children;
- (BOOL)isTextNode;
@end

@class LAHOperation, LAHPage, LAHTag;
typedef NSString *(^LAHAttrMethod)(NSString *value, NSArray *args, LAHTag *tag);
typedef NSString *(^LAHPropertyFetcher)(id<LAHHTMLElement> element);
typedef void(^LAHCompletion)(LAHOperation *operation);
typedef void(^LAHCorrector)(LAHOperation *operation, NSError* error);
typedef id<LAHHTMLElement> LAHEle;

@protocol LAHDelegate <NSObject>
- (id)operation:(LAHOperation *)operation needPageAtLink:(NSString *)link;
- (void)operation:(LAHOperation *)operation willCancelNetworks:(NSArray *)networks;
- (NSString *)operationNeedsHostName:(LAHOperation *)operation;
- (LAHAttrMethod)operation:(LAHOperation *)operation needsMethodNamed:(NSString *)methodName;

- (void)operation:(LAHOperation *)operation didFetch:(id)info;
@end

@protocol LAHFetcher <NSObject>
- (void)fetchValue:(NSString *)value;
@end

extern NSString * const LAHEntArr;
extern NSString * const LAHEntDic;
extern NSString * const LAHEntStr;
extern NSString * const LAHEntOpe;
extern NSString * const LAHEntPage;
extern NSString * const LAHEntTag;
extern NSString * const LAHEntTextTag;

extern NSString * const LAHParaTag;
extern NSString * const LAHParaRef;
extern NSString * const LAHParaKey;
extern NSString * const LAHParaRE;
extern NSString * const LAHParaPage;
extern NSString * const LAHParaModel;
extern NSString * const LAHParaLink;
extern NSString * const LAHParaRange;
extern NSString * const LAHParaIndexes;
extern NSString * const LAHParaIndexOf;
extern NSString * const LAHParaContent;
extern NSString * const LAHParaIsDemocratic;

extern NSString * const LAHMethodRE;
extern NSString * const LAHMethodJoinMethod;

extern NSString * const LAHValYES;
extern NSString * const LAHValNO;
extern NSString * const LAHValNone;
extern NSString * const LAHValAll;

extern NSString * const LAHParaId;
extern NSString * const LAHParaSym;
extern NSString * const LAHParaRoot;
extern NSString * const LAHParaPath;
extern NSString * const LAHParaClass;
extern NSString * const LAHParaText;
extern NSString * const LAHParaIndex;
extern NSString * const LAHParaIsText;
extern NSString * const LAHParaDefault;

extern NSString * const LAHValContent;
extern NSString * const LAHValText;
extern NSString * const LAHValTag;

extern NSString * const LAHValPath;
extern NSString * const LAHValURL;
extern NSString * const LAHValHost;

extern NSString * const gLAHImg;
extern NSString * const gLAHSrc;
extern NSString * const gLAHP;
extern NSString * const gLAHA;
extern NSString * const gLAHSpan;
extern NSString * const gLAHDiv;
extern NSString * const gLAHHref;