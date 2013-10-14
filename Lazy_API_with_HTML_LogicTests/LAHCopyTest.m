//
//  LAHCopyTest.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 5/6/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHCopyTest.h"
#import "LAHHeaders.h"
#import "LAHAttribute.h"

@implementation LAHCopyTest{
    NSBundle *_bundle;
}

- (void)testIntoTable{
    NSString *cmdPath = [_bundle pathForResource:@"VOANews" ofType:@"lah"];;
    LAHDictionary *root = (LAHDictionary *)[LAHInterpreter interpretFile:cmdPath forKey:@"sectionModel"];
    
    NSMutableDictionary *table = [NSMutableDictionary dictionary];
    LAHDictionary *rootCopy = [root copyVia:table];
    
    STAssertEquals(table.count, 7U, @"Test model being copied in table, the amount of models in it.");
    
    [rootCopy release];
}

- (void)testOutFromTable{
    NSString *cmdPath = [_bundle pathForResource:@"CopyTest" ofType:@"lah"];;
    LAHOperation *root = (LAHOperation *)[LAHInterpreter interpretFile:cmdPath forKey:@"root"];
    LAHOperation *rootCopy = root.copy;
    
    LAHPage *page = rootCopy.page;
    LAHTag *div0 = page.children[0];
    LAHDictionary *indexedDic = div0.indexOf.allObjects[0];
    LAHTag *div1 = div0.children[0];
    LAHAttribute *class = nil;
    for (class in div1.attributes) {
        if ([class.name isEqualToString:@"class"]) {
            break;
        }
    }
    LAHString *getterStr = class.getters.allObjects[0];
    
    LAHArray *array0 = (LAHArray *)rootCopy.model;
    LAHDictionary *dic1 = array0.children[0];
    LAHString *str2 = dic1.children[0];
    
    STAssertEquals(dic1, indexedDic, @"Copy, link indexOf model.");
    STAssertEquals(str2, getterStr, @"Copy, link getter model.");
    
    LAHArray *superFather = (LAHArray *)getterStr.father.father;
    STAssertEquals(rootCopy.model, superFather, @"Copy, root model.");
    
    [rootCopy release];
}

- (void)setUp{
    [super setUp];
    
    _bundle = [NSBundle bundleForClass:[self class]];
    
}

@end
