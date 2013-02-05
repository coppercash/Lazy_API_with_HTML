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