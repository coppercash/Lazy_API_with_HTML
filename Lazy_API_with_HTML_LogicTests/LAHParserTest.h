//
//  LAHInterpreterTest.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 4/28/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "LAHParser.h"

@interface LAHParserTest : SenTestCase

@end

@class LAHStmtEntity, LAHStmtAttribute, LAHStmtRef, LAHStmtValue, LAHStmtNumber, LAHStmtMultiple;

@interface LAHParser (Test)
- (LAHStmtEntity *)parseEntity;
- (LAHStmtAttribute *)parseAttribute;
- (LAHStmtRef *)parseReference;
- (LAHStmtValue *)parseValue;
- (LAHStmtNumber *)parseNumber;
- (LAHStmtValue *)parseTransferredValue;
- (LAHStmtMultiple *)parseMultipleWithLeft:(NSString *)left right:(NSString *)right;
- (BOOL)isHTMLTagName;
- (BOOL)isAttributeName;
- (BOOL)isNumber;

@end