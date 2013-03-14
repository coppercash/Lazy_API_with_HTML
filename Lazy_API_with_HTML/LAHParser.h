//
//  LAHParser.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 3/9/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LAHStmtSuite, LAHToken;
@interface LAHParser : NSObject {
	NSArray *_tokens;
	NSInteger _index;
    LAHToken *_eof;
}

- (id)initWithTokens:(NSArray *)tokens;
- (LAHStmtSuite *)parse;

@end