//
//  LAHRecognizer.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHTag.h"
//#import "LAHConstruct.h"
//#import "LAHFetcher.h"
#import "LAHPage.h"
#import "LAHString.h"
#import "LAHAttribute.h"
#import "LAHCategories.h"
#import "LAHOperation.h"
#import "LAHNote.h"

@interface LAHTag ()
@end

@implementation LAHTag
@synthesize isDemocratic = _isDemocratic, indexes = _indexes;
@synthesize attributes = _attributes;

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
    [super dealloc];
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
#ifdef LAH_RULES_DEBUG
    [LAHNote openNote:@"%@", self.des];
#endif
    
    
    
    //Step 0, match the index
    
    BOOL isIndexPass = YES;
    if (_indexes.count != 0) {
        isIndexPass = [_indexes locationInDividedRanges:index];
    }

#ifdef LAH_RULES_DEBUG
    [LAHNote noteAttr:@"index" d:[NSString stringWithFormat:@"%d", index] s:_indexes.dividedDescription pass:isIndexPass];
#endif
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

    
    
    //Step 3, match the children (is isDemocratic), and let children handle the elements
    //Two iteration in this order, so that the fetcher's fetching sequence depends on the sequence in the HTML.
    
    BOOL isChildrenPass = (_children.count == 0) ? YES : NO;    //Indicates at least one child can pass the test
    NSInteger subIndex = 0;
    for (LAHEle subEle in element.children) {
        for (LAHTag *tag in _children) {
            isChildrenPass |= [tag handleElement:subEle atIndex:subIndex];
        }
        subIndex ++;
    }

#ifdef LAH_RULES_DEBUG
    [LAHNote noteAttr:@"isDemocratic" d:BOOLStr(_isDemocratic) s:@"" pass:isChildrenPass];
#endif
    if (_isDemocratic && !isChildrenPass) return NO;


    
    //Step 4, fetch
    
    for (LAHAttribute *attr in _attributes) {
        [attr fetch];
    }
    
#ifdef LAH_RULES_DEBUG
    //[LAHNote closeNote];
    if (isChildrenPass) [LAHNote closeNote];
#endif
    return YES;
}

#pragma mark - State
- (void)saveStateForKey:(id)key{
    for (LAHModel *model in _children) {
        [model saveStateForKey:key];
    }
}

- (void)restoreStateForKey:(id)key{
    for (LAHModel *c in _children) {
        [c restoreStateForKey:key];
    }
}

- (void)refresh{
    [super refresh];
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
        [info appendFormat:@"  _indexes=("];
        
        BOOL isFirst = YES;
        for (NSValue *value in _indexes) {
            
            if (isFirst) {
                isFirst = NO;
            }else{
                [info appendFormat:@", "];
            }
            NSRange range = value.rangeValue;
            [info appendFormat:@"%d...%d", range.location, NSMaxRange(range) - 1];
        }
        
        [info appendFormat:@")"];
    }
    
    if (_indexOf && _indexOf.count != 0){
        [info appendFormat:@"  _indexOf={"];
        
        BOOL isFirst = YES;
        for (LAHString *string in _indexOf) {
            
            if (isFirst) {
                isFirst = NO;
            }else{
                [info appendFormat:@", "];
            }
            [info appendFormat:@"%@", string];
        }
        
        [info appendFormat:@"}"];
    }
    
    return info;
}

@end

