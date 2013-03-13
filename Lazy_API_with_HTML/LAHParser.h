//
//  LAHParser.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 3/9/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LAHStmtSuite;
@interface LAHParser : NSObject {
	NSArray *tokens;
	NSInteger index;
}

- (id)initWithString:(NSString *)source;
- (LAHStmtSuite *)parse;

@end