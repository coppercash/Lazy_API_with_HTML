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
@end

typedef NSString*(^LAHPropertyGetter)(id<LAHHTMLElement> element);

#define DEBUG_MODE
#ifdef DEBUG_MODE

#define DLogElement(x) NSLog(@"\n%@\t%@\n%@", (x).tagName, (x).text, (x).attributes);
#define DLogFetcher(x) NSLog(@"\n%@\t%@\n%@\n%@", (x).tagName, (x).key, (x).text, (x).attributes);

#else

#define DLogElement(x)
#define DLogFetcher(x)

#endif
