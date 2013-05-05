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
//@property(nonatomic, assign)id lastFatherContainer;
//@property(nonatomic, assign)LAHEle lastIdentifierElement;
@end

@implementation LAHModel
@synthesize type = _type, key = _key, range = _range;//, identifiers = _identifiers;
@synthesize needUpdate = _needUpdate;
//@synthesize lastFatherContainer = _lastFatherContainer, lastIdentifierElement = _lastIdentifierElement;

- (void)dealloc{
    self.key = nil;
    //self.identifiers = nil;
    
    [super dealloc];
}
/*
- (void)setIdentifiers:(NSSet *)indexes{
    [_identifiers release];
    _identifiers = [indexes retain];
    
    for (LAHTag *r in _identifiers) {
        r.isIdentifier = YES;
    }
}*/
/*
- (id)copyWithZone:(NSZone *)zone{
    
    LAHModel *copy = [super copyWithZone:zone];
    
    copy.type = _type;
    copy.key = _key;
    //if (_identifiers) copy.identifiers = [[NSSet alloc] initWithSet:_identifiers copyItems:YES];
    
    copy.lastFatherContainer = _lastFatherContainer;
    copy.lastIdentifierElement = _lastIdentifierElement;
    
    [copy.identifiers release];
    return copy;
     
}
*/
#pragma mark - States
- (void)saveStateForKey:(id)key{
    for (LAHModel *c in _children) {
        [c saveStateForKey:key];
    }
}

- (void)restoreStateForKey:(id)key{
    for (LAHModel *c in _children) {
        [c restoreStateForKey:key];
    }
}

- (void)refresh{
    //self.lastIdentifierElement = nil;
    //self.lastFatherContainer = nil;
    [super refresh];
}
/*
#pragma mark - Identifier
- (LAHEle)currentIdentifierElement{
    for (LAHTag *r in _identifiers) {
        LAHEle matchingElement = r.matchingElement;
        if (matchingElement != nil) return matchingElement;
    }
    return nil;
}

- (BOOL)isIdentifierElementChanged{
    LAHEle current = self.currentIdentifierElement;
    return _lastIdentifierElement != current;
}*/

#pragma mark - recursion
/*
- (BOOL)checkUpate:(LAHModel *)object{
    
    LAHModel *father = (LAHModel *)_father;
    BOOL update =
    [father checkUpate:self] ||
    father.data != _lastFatherContainer ||
    self.data == nil;

    if (update) [self update];
    
    _lastFatherContainer = father.data;
    _lastIdentifierElement = self.currentIdentifierElement;
    return NO;
     
}

- (void)update{}
*/
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


#pragma mark - Interpreter
/*
- (void)addIdentifier:(LAHTag *)identifier{
    if (_identifiers == nil) [self.identifiers = [[NSMutableSet alloc] init] release];
    [(NSMutableSet *)_identifiers addObject:identifier];
    identifier.isIdentifier = YES;
}*/

#pragma mark - Log
/*
- (NSString *)infoProperties{
    NSMutableString *info = [NSMutableString string];
    if (_key) [info appendFormat:@"key=%@, ", _key];
    if (_identifiers) {
        [info appendString:@"id={"];
        for (LAHTag *r in _identifiers) {
            [info appendFormat:@"%@, ", r];
        }
        [info appendString:@"}, "];
    }
    
    return info;
}*/
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

//NSString * const gKeyLastFatherContainer = @"LFC";
//NSString * const gKeyLastIdentifierElement = @"LIE";
NSString * const gKeyContainer = @"Con";
NSString * const gKeyNeedUpdate = @"NUp";


