//
//  Lazy_API_with_HTML_LogicTests.m
//  Lazy_API_with_HTML_LogicTests
//
//  Created by William Remaerd on 2/4/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHStatementsTests.h"
#import "LAHStmt.h"
#import "LAHHeaders.h"
#import "LAHAttribute.h"

@implementation LAHStatementsTests {
    @private
    NSBundle *_bundle;
    LAHStmtMultiple *_aRangeQus;
    NSArray *_aRangeAns;
}

- (void)testLAHFrame{
    
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];
    STAssertThrows([frame referObject:nil toKey:@"nilKey"],
                   @"Refer nil");
    
    
    LAHNode *node0 = [[[LAHNode alloc] init] autorelease];
    LAHNode *node1 = [[[LAHNode alloc] init] autorelease];
    [frame.references setObject:node0 forKey:@"same key"];
    STAssertThrows([frame referObject:node1 toKey:@"same key"],
                   @"Find same key");

    
    [frame referObject:node1 toKey:@"different key"];
    LAHNode *node2 = [frame objectForKey:@"different key"];
    STAssertNotNil(node2,
                   @"Get entity normally");
     
    
}

- (void)testLAHFrameEntityInherit{
    
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];
    LAHNode *node0 = [[[LAHNode alloc] init] autorelease];
    [frame referObject:node0 toKey:@"key"];
    LAHFrame *subFrame = [[[LAHFrame alloc] init] autorelease];
    subFrame.father = frame;
    
    LAHNode *node1 = [subFrame objectForKey:@"key"];
    STAssertEquals(node0, node1,
                   @"Get entity from inherit frame.");
    
    LAHNode *node2 = [[[LAHNode alloc] init] autorelease];
    [subFrame referObject:node2 toKey:@"key"];
    LAHNode *node3 = [subFrame objectForKey:@"key"];
    STAssertEquals(node2, node3,
                   @"Get entity from current frame.");

}

- (void)testLAHStmtValue{
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];

    LAHStmtValue *stmt = [[[LAHStmtValue alloc] init] autorelease];
    stmt.value = @"Some Value";
    
    NSString *value = [stmt evaluate:frame];
    
    STAssertEqualObjects(value, @"Some Value",
                         @"LAHStmtValue evaluate");
    
}

- (void)testLAHStmtNumber{
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];

    LAHStmtNumber *stmt = [[LAHStmtNumber alloc] init];
    stmt.value = @"1234567";

    NSNumber *qus0 = [stmt evaluate:frame];
    NSNumber *ans0 = [NSNumber numberWithInteger:1234567];
    STAssertEqualObjects(qus0, ans0,
                         @"LAHStmtValue evaluate normally");

    
    stmt.value = @"123abc67";
    STAssertThrows([stmt evaluate:frame],
                   @"LAHStmtValue throws exception of 'with letters'");
    
}

- (void)testLAHStmtRef{
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];
    
    
    LAHStmtRef *ref0 = [[[LAHStmtRef alloc] init] autorelease];
    ref0.name = @"entity0";
    STAssertThrows([ref0 evaluate:frame],
                   @"LAHStmtRef throws 'Can't get entity'");
    
    
    LAHNode *entity0 = [[[LAHNode alloc] init] autorelease];
    [frame referObject:entity0 toKey:@"entity0"];
    STAssertEquals([ref0 evaluate:frame], entity0,
                   @"LAHStmtRef get entity correctlly");
    
    
    LAHNode *entity1 = [[[LAHNode alloc] init] autorelease];
    [frame.toRefer addObject:entity1];
    LAHStmtRef *ref1 = [[[LAHStmtRef alloc] init] autorelease];
    ref1.name = @"entity1";
    [ref1 evaluate:frame];
    LAHNode *entity2 = [frame objectForKey:@"entity1"];
    STAssertEquals(entity1, entity2,
                   @"LAHStmtRef refer entity correctlly");

}

- (void)testLAHStmtMultiple{
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];

    LAHStmtMultiple *multiple = [[[LAHStmtMultiple alloc] init] autorelease];
    
    LAHStmtValue *value = [[[LAHStmtValue alloc] init] autorelease];
    value.value = @"Some Value";
    
    LAHStmtNumber *number = [[LAHStmtNumber alloc] init];
    number.value = @"1234567";

    LAHNode *entity0 = [[[LAHNode alloc] init] autorelease];
    [frame referObject:entity0 toKey:@"entity0"];
    LAHStmtRef *ref0 = [[[LAHStmtRef alloc] init] autorelease];
    ref0.name = @"entity0";
    
    multiple.values = @[value, number, ref0];
    
    NSArray *values = [multiple evaluate:frame];
    NSArray *ans = @[@"Some Value", [NSNumber numberWithInteger:1234567], entity0];
    STAssertEqualObjects(values, ans,
                         @"LAHStmtMultiple evaluate correctly");
}

- (void)testLAHStmtEntity{
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];
    
    LAHStmtEntity *entityStmt = [[[LAHStmtEntity alloc] init] autorelease];
    
    LAHStmtAttribute *attrStmt = [[[LAHStmtAttribute alloc] init] autorelease];
    attrStmt.name = LAHParaRef;
    LAHStmtRef *ref = [[[LAHStmtRef alloc] init] autorelease];
    ref.name = @"a ref";
    attrStmt.value = ref;
    [entityStmt.attributes addObject:attrStmt];

    LAHStmtEntity *childStmt = [[[LAHStmtEntity alloc] init] autorelease];
    [entityStmt.children addObject:childStmt];
    
    LAHNode *entity0 = [entityStmt evaluate:frame];
    
    LAHNode *entity1 = [frame objectForKey:@"a ref"];
    STAssertNotNil(entity1,
                   @"Ref an entity using attribute");
    STAssertEquals(entity0, entity1,
                   @"Ref an entity using attribute");
    
    STAssertEquals(entity1.children.count, 1U,
                   @"Generate a child");
}

- (void)testLAHStmtModel{
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];

    LAHStmtModel *modelStmt = [[[LAHStmtModel alloc] init] autorelease];

    LAHStmtAttribute *refAttrStmt = [[[LAHStmtAttribute alloc] init] autorelease];
    refAttrStmt.name = LAHParaRef;
    LAHStmtRef *ref = [[[LAHStmtRef alloc] init] autorelease];
    ref.name = @"a ref";
    refAttrStmt.value = ref;
    [modelStmt.attributes addObject:refAttrStmt];

    LAHStmtAttribute *keyAttrStmt = [[[LAHStmtAttribute alloc] init] autorelease];
    keyAttrStmt.name = LAHParaKey;
    LAHStmtValue *value = [[[LAHStmtValue alloc] init] autorelease];
    value.value = @"a key";
    keyAttrStmt.value = value;
    [modelStmt.attributes addObject:keyAttrStmt];
    
    LAHStmtAttribute *rangeAttrStmt = [[[LAHStmtAttribute alloc] init] autorelease];
    rangeAttrStmt.name = LAHParaRange;
    rangeAttrStmt.value = _aRangeQus;
    [modelStmt.attributes addObject:rangeAttrStmt];
    
    LAHModel *model = [modelStmt evaluate:frame];
    
    LAHModel *model0 = (LAHModel *)[frame objectForKey:@"a ref"];
    STAssertNotNil(model0,
                   @"Inherit ability to using ref");
    
    STAssertEqualObjects(model.key, @"a key",
                         @"Get key");
    
    STAssertEqualObjects(model.range, _aRangeAns,
                         @"Get range");

}

- (void)testLAHStmtArray{
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];
    LAHStmtArray *arrayStmt = [[[LAHStmtArray alloc] init] autorelease];
    LAHArray *array = [arrayStmt evaluate:frame];
    STAssertEqualObjects(array.class, [LAHArray class],
                         @"Generate LAHArray correctlly");
}

- (void)testLAHStmtDictionary{
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];
    LAHStmtDictionary *dictionaryStmt = [[[LAHStmtDictionary alloc] init] autorelease];
    LAHDictionary *dcitionary = [dictionaryStmt evaluate:frame];
    STAssertEqualObjects(dcitionary.class, [LAHDictionary class],
                         @"Generate LAHDictionary correctlly");
}

- (void)testLAHStmtString{
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];
    LAHStmtString *stringStmt = [[[LAHStmtString alloc] init] autorelease];
    LAHString *string = [stringStmt evaluate:frame];
    STAssertEqualObjects(string.class, [LAHString class],
                         @"Generate LAHString correctlly");
}

- (void)testLAHStmtOperation{
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];
    
    LAHStmtModel *modelStmt = [[[LAHStmtModel alloc] init] autorelease];
    LAHStmtPage *pageStmt = [[[LAHStmtPage alloc] init] autorelease];
    
    LAHStmtOperation *opeStmt0 = [[[LAHStmtOperation alloc] init] autorelease];
    [opeStmt0.children addObject:modelStmt];
    [opeStmt0.children addObject:pageStmt];
    LAHOperation *ope0 = [opeStmt0 evaluate:frame];
    STAssertEqualObjects(ope0.class, [LAHOperation class],
                         @"Generate LAHOperation correctlly");
    STAssertEqualObjects(ope0.model.class, [LAHModel class],
                         @"Get model of operation by child");
    STAssertEqualObjects(ope0.page.class, [LAHPage class],
                         @"Get page of operation by child");

    LAHModel *model = [[[LAHModel alloc] init] autorelease];
    [frame referObject:model toKey:@"a model"];
    LAHPage *page = [[[LAHPage alloc] init] autorelease];
    [frame referObject:page toKey:@"a page"];
    
    LAHStmtOperation *opeStmt1 = [[[LAHStmtOperation alloc] init] autorelease];
    
    LAHStmtAttribute *modelAttrStmt = [[[LAHStmtAttribute alloc] init] autorelease];
    modelAttrStmt.name = LAHParaModel;
    LAHStmtRef *modelRefStmt = [[[LAHStmtRef alloc] init] autorelease];
    modelRefStmt.name = @"a model";
    modelAttrStmt.value = modelRefStmt;
    [opeStmt1.attributes addObject:modelAttrStmt];
    
    LAHStmtAttribute *pageAttrStmt = [[[LAHStmtAttribute alloc] init] autorelease];
    pageAttrStmt.name = LAHParaPage;
    LAHStmtRef *pageRefStmt = [[[LAHStmtRef alloc] init] autorelease];
    pageRefStmt.name = @"a page";
    pageAttrStmt.value = pageRefStmt;
    [opeStmt1.attributes addObject:pageAttrStmt];

    LAHOperation *ope1 = [opeStmt1 evaluate:frame];
    STAssertEqualObjects(ope1.model.class, [LAHModel class],
                         @"Get model of operation by attribute");
    STAssertEqualObjects(ope1.page.class, [LAHPage class],
                         @"Get page of operation by attribute");
}

- (void)testLAHStmtPage{
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];

    LAHStmtPage *pageStmt = [[[LAHStmtPage alloc] init] autorelease];

    LAHStmtAttribute *linkAttrStmt = [[[LAHStmtAttribute alloc] init] autorelease];
    linkAttrStmt.name = LAHParaLink;
    LAHStmtValue *valueStmt = [[[LAHStmtValue alloc] init] autorelease];
    valueStmt.value = @"some link";
    linkAttrStmt.value = valueStmt;
    
    [pageStmt.attributes addObject:linkAttrStmt];
    
    LAHPage *page = [pageStmt evaluate:frame];
    STAssertEqualObjects(page.class, [LAHPage class],
                         @"Generate LAHPage");
    STAssertEqualObjects(page.link, @"some link",
                         @"Get link of LAHPage by attribute");

}

- (void)testLAHStmtTag{
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];

    LAHStmtTag *tagStmt = [[[LAHStmtTag alloc] init] autorelease];
    LAHStmtAttribute *rangeAttrStmt = [[[LAHStmtAttribute alloc] init] autorelease];
    rangeAttrStmt.name = LAHParaIndexes;
    rangeAttrStmt.value = _aRangeQus;
    [tagStmt.attributes addObject:rangeAttrStmt];
    LAHTag* tag = [tagStmt evaluate:frame];
    STAssertEqualObjects(tag.class, [LAHTag class],
                         @"Generate LAHTag");
    STAssertEqualObjects(tag.indexes, _aRangeAns,
                         @"Get range of LHATag by attribute");

}

- (void)testLAHStmtTagIndexOf{
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];
    
    LAHModel *model = [[[LAHModel alloc] init] autorelease];
    [frame referObject:model toKey:@"a model"];
    LAHStmtRef *modelRef = [[[LAHStmtRef alloc] init] autorelease];
    modelRef.name = @"a model";

    LAHPage *page = [[[LAHPage alloc] init] autorelease];
    [frame referObject:page toKey:@"a page"];
    LAHStmtRef *pageRef = [[[LAHStmtRef alloc] init] autorelease];
    pageRef.name = @"a page";

    
    LAHStmtTag *tagStmt = [[[LAHStmtTag alloc] init] autorelease];
    
    LAHStmtAttribute *indexAttrStmt0 = [[[LAHStmtAttribute alloc] init] autorelease];
    [tagStmt.attributes addObject:indexAttrStmt0];
    indexAttrStmt0.name = LAHParaIndexOf;
    indexAttrStmt0.value = modelRef;
    
    LAHTag* tag0 = [tagStmt evaluate:frame];
    STAssertEqualObjects(tag0.indexOf.anyObject, model,
                         @"Get single indexOf of LHATag by attribute");
    
    indexAttrStmt0.value = pageRef;
    STAssertThrows([tagStmt evaluate:frame],
                   @"Throws, single indexOf only accept LAHModel");
    
    
    LAHStmtAttribute *indexAttrStmt1 = [[[LAHStmtAttribute alloc] init] autorelease];
    [tagStmt.attributes removeAllObjects];
    [tagStmt.attributes addObject:indexAttrStmt1];
    LAHStmtMultiple *multiple1 = [[[LAHStmtMultiple alloc] init] autorelease];
    multiple1.values = @[modelRef];
    indexAttrStmt1.name = LAHParaIndexOf;
    indexAttrStmt1.value = multiple1;

    LAHTag* tag1 = [tagStmt evaluate:frame];
    STAssertEqualObjects(tag1.indexOf.anyObject, model,
                         @"Get multiple indexOf of LHATag by attribute");

    /*
    multiple1.values = @[pageRef];
    STAssertThrows([tagStmt evaluate:frame],
                   @"Throws, multiple indexOf only accept LAHModel");
     */

}

- (void)testLAHStmtTagHTMLTag{
    
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];

    LAHStmtTag *tagStmt = [[[LAHStmtTag alloc] init] autorelease];
    
    LAHString *string = [[[LAHString alloc] init] autorelease];
    [frame referObject:string toKey:@"a string"];
    LAHStmtRef *stringRef = [[[LAHStmtRef alloc] init] autorelease];
    stringRef.name = @"a string";

    LAHStmtAttribute *tagAttrStmt = [[[LAHStmtAttribute alloc] init] autorelease];
    [tagStmt.attributes addObject:tagAttrStmt];
    tagAttrStmt.name = @"div";
    tagAttrStmt.value = stringRef;

    LAHTag *tag0 = [tagStmt evaluate:frame];
    LAHAttribute *attr0 = tag0.attributes.anyObject;
    STAssertEqualObjects(attr0.name, @"div",
                         @"Get single HTML tag attributes name");
    STAssertEqualObjects(attr0.getters.anyObject, string,
                         @"Get single HTML tag attributes LAHString getter");

    
    LAHPage *page = [[[LAHPage alloc] init] autorelease];
    [frame referObject:page toKey:@"a page"];
    LAHStmtRef *pageRef = [[[LAHStmtRef alloc] init] autorelease];
    pageRef.name = @"a page";

    LAHStmtValue *value = [[[LAHStmtValue alloc] init] autorelease];
    value.value = @"some value";
    
    LAHStmtMultiple *multiple1 = [[[LAHStmtMultiple alloc] init] autorelease];
    multiple1.values = @[stringRef, pageRef, value];
    tagAttrStmt.value = multiple1;

    LAHTag *tag1 = [tagStmt evaluate:frame];
    LAHAttribute *attr1 = tag1.attributes.anyObject;
    STAssertEqualObjects(attr1.name, @"div",
                         @"Get multiple HTML tag attributes name");
    STAssertEqualObjects(attr1.legalValues.anyObject, @"some value",
                         @"Get multiple HTML tag attributes legal value");
    for (id getter in attr1.getters) {
        if ([getter isKindOfClass:[LAHString class]]) {
            STAssertEqualObjects(getter, string,
                                 @"Get multiple HTML tag attributes LAHString getter");
        } else if ([getter isKindOfClass:[LAHPage class]]){
            STAssertEqualObjects(getter, page,
                                 @"Get multiple HTML tag attributes LAHPage getter");
        }
    }

    
    LAHModel *model = [[[LAHModel alloc] init] autorelease];
    [frame referObject:model toKey:@"a model"];
    LAHStmtRef *modelRef = [[[LAHStmtRef alloc] init] autorelease];
    modelRef.name = @"a model";

    tagAttrStmt.value = modelRef;
    STAssertThrows([tagStmt evaluate:frame],
                   @"Throws, single Tag attribute only accept LAHString, LAHPage, NSString");

    /*
    LAHStmtMultiple *multiple2 = [[[LAHStmtMultiple alloc] init] autorelease];
    multiple2.values = @[modelRef];
    tagAttrStmt.value = multiple2;
    STAssertThrows([tagStmt evaluate:frame],
                   @"Throws, multiple Tag attribute only accept LAHString, LAHPage, NSString");
     */
    
}

- (void)testLAHStmtTagHTMLTagMethodRE{
    LAHFrame *frame = [[[LAHFrame alloc] init] autorelease];

    LAHStmtTag *tagStmt = [[[LAHStmtTag alloc] init] autorelease];

    LAHStmtValue *value = [[[LAHStmtValue alloc] init] autorelease];
    value.value = @"some value";
    
    LAHStmtValue *arg0 = [[[LAHStmtValue alloc] init] autorelease];
    arg0.value = @"some arg";
    LAHStmtMultiple *multiple = [[[LAHStmtMultiple alloc] init] autorelease];
    multiple.values = @[arg0];
    
    LAHStmtAttribute *tagAttrStmt = [[[LAHStmtAttribute alloc] init] autorelease];
    [tagStmt.attributes addObject:tagAttrStmt];
    tagAttrStmt.name = @"div";
    tagAttrStmt.value = value;
    tagAttrStmt.methodName = @"re";
    tagAttrStmt.args = multiple;
    
    LAHTag *tag = [tagStmt evaluate:frame];
    LAHAttribute *attr0 = tag.attributes.anyObject;
    STAssertEqualObjects(attr0.methodName, @"re",
                         @"Get method name of a LAHAttribute");
    STAssertEqualObjects(attr0.args, @[@"some arg"],
                         @"Get method args of a LAHAttribute");

}


- (void)setUp{
    [super setUp];
    
    // Set-up code here.
    LAHStmtNumber * (^quichNumber) (NSString *) = ^(NSString *string){
        LAHStmtNumber *number = [[[LAHStmtNumber alloc] init] autorelease];
        number.value = string;
        return number;
    };
    
    _aRangeQus = [[LAHStmtMultiple alloc] init];
    _aRangeQus.values = @[quichNumber(@"1"), quichNumber(@"10"), quichNumber(@"11")];
    _aRangeAns = @[
                   [NSNumber numberWithInteger:1],
                   [NSNumber numberWithInteger:10],
                   [NSNumber numberWithInteger:11]
                   ];
}

- (void)tearDown{
    [_aRangeQus release];
    // Tear-down code here.
    
    [super tearDown];
}


@end

