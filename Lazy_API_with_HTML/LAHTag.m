//
//  LAHRecognizer.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHTag.h"
#import "LAHModel.h"
#import "LAHAttribute.h"
#import "LAHCategories.h"
#import "LAHNote.h"

@interface LAHTag ()
@end

@implementation LAHTag
@synthesize isDemocratic = _isDemocratic, indexes = _indexes;
@synthesize attributes = _attributes;
@dynamic singleRange;

#pragma mark - Life Cycle
- (id)init{
    self = [super init];
    if (self) {
        self.isDemocratic = NO;
    }
    return self;
}

- (void)dealloc{
    self.indexes = nil;
    self.attributes = nil;
    self.indexOf = nil;
    [super dealloc];
}

#pragma mark - Copy
- (id)copyVia:(NSMutableDictionary *)table{
    LAHTag *copy = [super copyVia:table];
    
    copy.indexes = [[NSArray alloc] initWithArray:_indexes copyItems:YES];
    [copy.indexes release];
    
    NSMutableSet *attrClc = [[NSMutableSet alloc] initWithCapacity:_attributes.count];
    for (LAHAttribute *attr in _attributes) {
        LAHAttribute *attrCopy = [attr copyVia:table];
        attrCopy.father = copy;
        
        [attrClc addObject:attrCopy];
        [attrCopy release];
    }
    copy.attributes = [[NSMutableSet alloc] initWithSet:attrClc];
    [copy.attributes release];
    [attrClc release];
    
    copy.isDemocratic = _isDemocratic;
    
    NSMutableSet *indexOfClc = [[NSMutableSet alloc] initWithCapacity:_indexOf.count];
    for (LAHModel *model in _indexOf) {
        
        LAHModel *modelCopy = table[model.identifier];
        [indexOfClc addObject:modelCopy];
    }
    copy.indexOf = [[NSSet alloc] initWithSet:indexOfClc];
    [copy.indexOf release];
    [indexOfClc release];
    
    return copy;
}

#pragma mark - Single Range
- (void)setSingleRange:(NSRange)singleRange{
    NSValue *rangeValue = [NSValue valueWithRange:singleRange];
    self.indexes = @[rangeValue];
}

- (NSRange)singleRange{
    if (_indexes && _indexes.count != 0) {
        NSValue *rangeValue = _indexes[0];
        return rangeValue.rangeValue;
    }
    return NSMakeRange(0, NSUIntegerMax);
}

#pragma mark - Getter
- (NSMutableSet *)attributes{
    if (!_attributes) {
        _attributes = [[NSMutableSet alloc] init];
    }
    return _attributes;
}

#pragma mark - Recursive
- (BOOL)handleElement:(LAHEle)element atIndex:(NSInteger)index{
    LAHNoteOpen(@"%@", self);
    
    BOOL globalIndex = _indexOf && _indexOf.count == 1;
    
    //Step 0, match the index
    
    BOOL isIndexPass = YES;
    
    if (!globalIndex && _indexes.count != 0) {  //count != 0 indicates no limit, the isIndexPass ahould be YES.
        isIndexPass = [_indexes locationInDividedRanges:index];
    }
    LAHNoteAttr(@"index", ([NSString stringWithFormat:@"%d", index]), _indexes.dividedDesc, isIndexPass);
    if ( !isIndexPass ) return NO;
    
    
    
    //Step 1, match the attributes
    
    BOOL isAttrPass = YES;
    for (LAHAttribute *attr in _attributes) {
        
        [attr cacheValueWithElement:element];
        isAttrPass &= attr.isMatched;
        
        if ( !isAttrPass ) return NO;
    }


    
    //Step 2, notification LAHMode in _indexOf to update
    
    for (LAHModel *model in _indexOf) {
        model.needUpdate = YES;
    }

    
    //Step 3, fetch
    BOOL isRangePass = YES;
    if (globalIndex && _indexes.count != 0) {   //count != 0 indicates no limit, the isIndexPass ahould be YES.
        LAHModel *indexSrc = _indexOf.allObjects[0];
        index = indexSrc.index ++;
        isRangePass = [_indexes locationInDividedRanges:index];
    }
    LAHNoteAttr(@"globalIndex", NumberStr(index), _indexes.dividedDesc, isRangePass);
    if (!isRangePass) return NO;
    
    
    
    //Step 4, match the children (is isDemocratic), and let children handle the elements
    //Two iteration in this order, so that the fetcher's fetching sequence depends on the sequence in the HTML.
    
    BOOL isChildrenPass = (!_isDemocratic || (_children.count == 0)) ? YES : NO;    //Indicates at least one child can pass the test
    NSInteger subIndex = 0;
    for (LAHEle subEle in element.children) {
        for (LAHTag *tag in _children) {
            isChildrenPass |= [tag handleElement:subEle atIndex:subIndex];
        }
        subIndex ++;
    }
    LAHNoteAttr(@"isDemocratic", BOOLStr(_isDemocratic), @"", isChildrenPass);
    if (!isChildrenPass) return NO;


    
    //Step 5, fetch
    
    for (LAHAttribute *attr in _attributes) {
        [attr fetch];
    }
    
    LAHNoteClose;
    return YES;
}

#pragma mark - Log
- (NSString *)tagNameInfo{
    NSString *info = nil;
    for (LAHAttribute *attr in _attributes) {
        if ([attr.name isEqualToString:LAHParaTag]){
            info = attr.legalValues.anyObject;
            break;
        }
    }
    return info ? info : LAHParaTag;
}

- (NSString *)attributesInfo{
    NSMutableString *info = [NSMutableString stringWithString:[super attributesInfo]];
    
    if (_attributes && _attributes.count != 0) {
        
        for (LAHAttribute *attr in _attributes) {
            
            if ([attr.name isEqualToString:LAHParaTag]) continue;
            [info appendFormat:@"  %@", attr.description];
        }
    }
    
    if (_isDemocratic) {
        [info appendFormat:@"  _isDem=\"YES\""];
    }
    
    if (_indexes && _indexes.count != 0) {
        [info appendFormat:@"  _indexes=%@", _indexes.dividedDesc];
    }
    
    if (_indexOf && _indexOf.count != 0){
        [info appendFormat:@"  _indexOf=%@", _indexOf.allObjects.lineDesc];
    }
    
    return info;
}

@end

