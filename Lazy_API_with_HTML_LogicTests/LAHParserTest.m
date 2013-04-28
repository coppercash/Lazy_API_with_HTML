//
//  LAHInterpreterTest.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 4/28/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHParserTest.h"
#import <OCMock.h>

#import "LAHToken.h"
#import "LAHInterpreter.h"
#import "LAHStmt.h"

#import "LAHArray.h"
#import "LAHDictionary.h"
#import "LAHString.h"
#import "LAHOperation.h"
#import "LAHPage.h"
#import "LAHTag.h"

@implementation LAHParserTest {
@private
    NSBundle *_bundle;
    LAHParser *(^_parser)(NSString *);
}

- (void)setUp{
    _bundle = [NSBundle bundleForClass:[self class]];
    _parser = ^(NSString *cmd){
        NSArray *tokens = [LAHToken tokenizeString:cmd];
        LAHParser *parser = [[LAHParser alloc] initWithTokens:tokens];
        return parser;
    };
}

- (void)testParseRegularExpression{
    LAHParser *parser0 = _parser(@"re(\"some regular expression\")");
    STAssertEqualObjects(parser0.parseRegularExpression, @"some regular expression", @"Wrong value of expression");
}

- (void)testIsNumber{
    
    LAHParser *parser0 = _parser(@"0");
    STAssertTrueNoThrow(parser0.isNumber, @"Wrong answer");

    LAHParser *parser1 = _parser(@"123456789");
    STAssertTrueNoThrow(parser1.isNumber, @"Wrong answer");

    LAHParser *parser2 = _parser(@"abc");
    STAssertFalseNoThrow(parser2.isNumber, @"Wrong answer");

}

- (void)testAtHTMLTagName{
    
    LAHParser *parser0 = _parser(@"div");
    STAssertTrueNoThrow(parser0.isHTMLTagName, @"Wrong answer");
    
    LAHParser *parser1 = _parser(@"123");
    STAssertFalseNoThrow(parser1.isHTMLTagName, @"Wrong answer");

}

- (void)testParseTuple{
    LAHStmtMultiple *tuple0 = [_parser(@"(1, 2, 3, 4, 5, 6, 7, )") parseMultipleWithLeft:@"(" right:@")"];
    STAssertEqualObjects(tuple0.class, [LAHStmtMultiple class], @"Wrong type.");
    
    STAssertEquals(tuple0.values.count, 7U, @"Wrong number.");
    
    LAHStmtNumber *the5 = tuple0.values[4];
    STAssertEqualObjects(the5.class, [LAHStmtNumber class], @"Wrong type.");
    STAssertEqualObjects(the5.value, @"5", @"Wrong value.");
    
}

- (void)testParseSet{
    LAHStmtMultiple *tuple0 = [_parser(@"{'gain', _trans, \"string\", 4}") parseMultipleWithLeft:@"{" right:@"}"];
    STAssertEqualObjects(tuple0.class, [LAHStmtMultiple class], @"Wrong type.");
    
    STAssertEquals(tuple0.values.count, 4U, @"Wrong number.");
    
    LAHStmtGain *the0 = tuple0.values[0];
    STAssertEqualObjects(the0.class, [LAHStmtGain class], @"Wrong type.");
    STAssertEqualObjects(the0.name, @"gain", @"Wrong value.");
    
    LAHStmtValue *the1 = tuple0.values[1];
    STAssertEqualObjects(the1.class, [LAHStmtValue class], @"Wrong type.");
    STAssertEqualObjects(the1.string, @"_trans", @"Wrong value.");

    LAHStmtValue *the2 = tuple0.values[2];
    STAssertEqualObjects(the2.class, [LAHStmtValue class], @"Wrong type.");
    STAssertEqualObjects(the2.string, @"string", @"Wrong value.");

    LAHStmtNumber *the3 = tuple0.values[3];
    STAssertEqualObjects(the3.class, [LAHStmtNumber class], @"Wrong type.");
    STAssertEqualObjects(the3.value, @"4", @"Wrong value.");

}

- (void)testParseCommand{
    NSString *path = [_bundle pathForResource:NSStringFromSelector(_cmd) ofType:@"lah"];
    NSString *cmd = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    STAssertTrueNoThrow(cmd != nil, @"Can't get command");
    
    NSArray *tokens = [LAHToken tokenizeString:cmd];
    
    LAHParser *parser = [[LAHParser alloc] initWithTokens:tokens];
    LAHStmtSuite *suite = [parser parseCommand];

    NSArray *statements = suite.statements;
    STAssertEquals(statements.count, 6U, @"Wrong number of statements");
    
    STAssertTrueNoThrow([statements[0] isKindOfClass:[LAHStmtArray class]], @"Wrong type of statement.");
    STAssertTrueNoThrow([statements[1] isKindOfClass:[LAHStmtDictionary class]], @"Wrong type of statement.");
    STAssertTrueNoThrow([statements[2] isKindOfClass:[LAHStmtString class]], @"Wrong type of statement.");
    STAssertTrueNoThrow([statements[3] isKindOfClass:[LAHStmtOperation class]], @"Wrong type of statement.");
    STAssertTrueNoThrow([statements[4] isKindOfClass:[LAHStmtPage class]], @"Wrong type of statement.");
    STAssertTrueNoThrow([statements[5] isKindOfClass:[LAHStmtTag class]], @"Wrong type of statement.");
    
    [parser release];
}

- (void)testParseEntity{
    NSString *path = [_bundle pathForResource:NSStringFromSelector(_cmd) ofType:@"lah"];
    NSString *cmd = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    STAssertTrueNoThrow(cmd != nil, @"Can't get command");
    
    NSArray *tokens = [LAHToken tokenizeString:cmd];
    
    //Array
    LAHParser *parser0 = [[LAHParser alloc] initWithTokens:tokens];
    LAHStmtEntity *entity0 = [parser0 parseEntity];
    
    STAssertEqualObjects(entity0.class, [LAHStmtArray class], @"Wrong type of statement.");
    STAssertEquals(entity0.properties.count, 1U, @"Wrong number of properties");
    STAssertEquals(entity0.children.count, 0U, @"Wrong number of children");

    //Dictionary
    LAHStmtEntity *entity1 = [parser0 parseEntity];
    
    STAssertEqualObjects(entity1.class, [LAHStmtDictionary class], @"Wrong type of statement.");
    STAssertEquals(entity1.properties.count, 1U, @"Wrong number of properties");
    STAssertEquals(entity1.children.count, 0U, @"Wrong number of children");
    
    //String
    LAHStmtEntity *entity2 = [parser0 parseEntity];
    
    STAssertEqualObjects(entity2.class, [LAHStmtString class], @"Wrong type of statement.");
    STAssertEquals(entity2.properties.count, 1U, @"Wrong number of properties");
    STAssertEquals(entity2.children.count, 0U, @"Wrong number of children");

    //Operation
    LAHStmtEntity *entity3 = [parser0 parseEntity];
    
    STAssertEqualObjects(entity3.class, [LAHStmtOperation class], @"Wrong type of statement.");
    STAssertEquals(entity3.properties.count, 2U, @"Wrong number of properties");
    STAssertEquals(entity3.children.count, 0U, @"Wrong number of children");

    //Page
    LAHStmtEntity *entity4 = [parser0 parseEntity];
    
    STAssertEqualObjects(entity4.class, [LAHStmtPage class], @"Wrong type of statement.");
    STAssertEquals(entity4.properties.count, 1U, @"Wrong number of properties");
    STAssertEquals(entity4.children.count, 2U, @"Wrong number of children");

    LAHStmtEntity *firstChild = entity4.children[0];
    STAssertEquals(firstChild.children.count, 1U, @"Wrong number of children");
    
    //Tag
    LAHStmtEntity *entity5 = [parser0 parseEntity];
    
    STAssertEqualObjects(entity5.class, [LAHStmtTag class], @"Wrong type of statement.");
    STAssertEquals(entity5.properties.count, 1U, @"Wrong number of properties");
    STAssertEquals(entity5.children.count, 0U, @"Wrong number of children");

    //div
    LAHStmtEntity *entity6 = [parser0 parseEntity];
    STAssertEqualObjects(entity6.class, [LAHStmtTag class], @"Wrong type of statement.");
    STAssertEquals(entity6.properties.count, 2U, @"Wrong number of properties.");
    STAssertEquals(entity6.children.count, 0U, @"Wrong number of children.");

    LAHStmtAttribute *pro6_0 = entity6.properties[0];
    STAssertEqualObjects(pro6_0.name, LAHParaTag, @"Wrong value tagName name.");
    STAssertEqualObjects(pro6_0.value.string, @"div", @"Wrong value tagName value");
    
    LAHStmtAttribute *pro6_1 = entity6.properties[1];
    LAHStmtMultiple *values = (LAHStmtMultiple *)pro6_1.value;
    STAssertEquals(values.values.count, 2U, @"Wrong number of properties' values");
    
    LAHStmtValue *class = values.values[0];
    STAssertEqualObjects(class.class, [LAHStmtValue class], @"Wrong type of statement.");
    STAssertEqualObjects(class.string, @"class", @"Wrong value of propertie's value.");

    LAHStmtGain *gain = values.values[1];
    STAssertEqualObjects(gain.class, [LAHStmtGain class], @"Wrong type of statement.");
    STAssertEqualObjects(gain.name, @"gain", @"Wrong value of propertie's value.");

    //_content
    LAHStmtEntity *entity7 = [parser0 parseEntity];
    STAssertEqualObjects(entity7.class, [LAHStmtTag class], @"Wrong type of statement.");
    STAssertEquals(entity7.properties.count, 2U, @"Wrong number of properties.");

    LAHStmtAttribute *pro7_0 = entity7.properties[0];
    STAssertEqualObjects(pro7_0.name, LAHParaTag, @"Wrong value tagName name.");
    STAssertEqualObjects(pro7_0.value.string, LAHEntTextTag, @"Wrong value tagName value");
    
    LAHStmtAttribute *pro7_1 = entity7.properties[1];
    STAssertEqualObjects(pro7_1.class, [LAHStmtAttribute class], @"Wrong type of statement.");
    STAssertEqualObjects(pro7_1.name, @"_content", @"Wrong value of property name.");
    STAssertEqualObjects(pro7_1.re, @"regular expression", @"Wrong value of property re.");
    
    LAHStmtGain *gain7 = (LAHStmtGain *)pro7_1.value;
    STAssertEqualObjects(gain7.class, [LAHStmtGain class], @"Wrong type of statement.");
    STAssertEqualObjects(gain7.name, @"gain", @"Wrong value of statement.");

    [parser0 release];
}

@end
