//
//  LAHConstruct.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHModel.h"
#import "LAHTag.h"
#import "LAHOperation.h"
#import "LAHNote.h"

@interface LAHModel ()
@end

@implementation LAHModel
@synthesize key = _key, range = _range;
@synthesize needUpdate = _needUpdate;

- (void)dealloc{
    self.key = nil;
    self.range = nil;
    
    [super dealloc];
}

#pragma mark - States
- (void)saveStateForKey:(id)key{
    for (LAHModel *child in _children) {
        [child saveStateForKey:key];
    }
}

- (void)restoreStateForKey:(id)key{
    for (LAHModel *child in _children) {
        [child restoreStateForKey:key];
    }
}

- (void)refresh{
    [super refresh];
}

#pragma mark - recursion
- (void)recieve:(LAHModel*)object{
#ifdef LAH_RULES_DEBUG
    [LAHNote quickNote:@"%@\tneedUpdate %@\tdata %p", self.des, BOOLStr(_needUpdate), self.data];
#endif
}

- (BOOL)needUpdate{
    LAHModel *father = (LAHModel *)_father;
    BOOL needUpdate = father.needUpdate || _needUpdate;
    return needUpdate;
}

#pragma mark - Log
- (NSString *)tagNameInfo{
    return @"model";
}

- (NSString *)attributesInfo{
    NSMutableString *info = [NSMutableString stringWithString:[super attributesInfo]];
    if (_key) [info appendFormat:@"  key=\"%@\"", _key];
    if (_range && _range.count != 0) {
        [info appendFormat:@"  range=("];

        BOOL isFirst = YES;
        for (NSNumber *number in _range) {
            
            if (isFirst) {
                isFirst = NO;
            }else{
                [info appendFormat:@", "];
            }

            [info appendFormat:@"%d", number.integerValue];
        }
        
        [info appendFormat:@")"];
    }
    return info;
}

@end

NSString * const gKeyContainer = @"Con";
NSString * const gKeyNeedUpdate = @"NUp";


