//
//  LAHInterpreterTest.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 4/28/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "LAHParser.h"

@class LAHStmtEntity, LAHStmtAttribute, LAHStmtGain, LAHStmtValue, LAHStmtNumber, LAHStmtMultiple;
@interface LAHParserTest : SenTestCase

@end

@interface LAHParser (Test)
- (LAHStmtEntity *)parseEntity;
- (LAHStmtAttribute *)parseAttribute;
- (LAHStmtGain *)parseGain;
- (LAHStmtValue *)parseValue;
- (LAHStmtNumber *)parseNumber;
- (LAHStmtValue *)parseTransferredValue;
- (LAHStmtMultiple *)parseMultipleWithLeft:(NSString *)left right:(NSString *)right;
- (NSString *)parseRegularExpression;
- (BOOL)isHTMLTagName;
- (BOOL)isAttributeName;
- (BOOL)isNumber;

@end