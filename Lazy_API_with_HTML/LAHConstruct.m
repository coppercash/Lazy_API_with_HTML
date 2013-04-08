//
//  LAHConstruct.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHConstruct.h"
#import "LAHRecognizer.h"
#import "LAHOperation.h"

@interface LAHConstruct ()
@property(nonatomic, assign)id lastFatherContainer;
@property(nonatomic, assign)LAHEle lastIdentifierElement;
@end

@implementation LAHConstruct
@synthesize type = _type, key = _key, identifiers = _identifiers;
@synthesize lastFatherContainer = _lastFatherContainer, lastIdentifierElement = _lastIdentifierElement;

- (void)dealloc{
    self.key = nil;
    self.identifiers = nil;
    
    [super dealloc];
}

- (void)setIdentifiers:(NSSet *)indexes{
    [_identifiers release];
    _identifiers = [indexes retain];
    
    for (LAHRecognizer *r in _identifiers) {
        r.isIdentifier = YES;
    }
}

- (id)copyWithZone:(NSZone *)zone{
    LAHConstruct *copy = [super copyWithZone:zone];
    
    copy.type = _type;
    copy.key = _key;
    //if (_identifiers) copy.identifiers = [[NSSet alloc] initWithSet:_identifiers copyItems:YES];
    
    copy.lastFatherContainer = _lastFatherContainer;
    copy.lastIdentifierElement = _lastIdentifierElement;
    
    [copy.identifiers release];
    return copy;
}

#pragma mark - States
- (void)saveStateForKey:(id)key{
    for (LAHConstruct *c in _children) {
        [c saveStateForKey:key];
    }
}

- (void)restoreStateForKey:(id)key{
    for (LAHConstruct *c in _children) {
        [c restoreStateForKey:key];
    }
}

#pragma mark - Identifier
- (LAHEle)currentIdentifierElement{
    for (LAHRecognizer *r in _identifiers) {
        LAHEle matchingElement = r.matchingElement;
        if (matchingElement != nil) return matchingElement;
    }
    return nil;
}

- (BOOL)isIdentifierElementChanged{
    LAHEle current = self.currentIdentifierElement;
    return _lastIdentifierElement != current;
}

#pragma mark - recursion
- (BOOL)checkUpate:(LAHConstruct *)object{
    LAHConstruct *father = (LAHConstruct *)_father;
    BOOL update =
    [father checkUpate:self] ||
    father.container != _lastFatherContainer ||
    self.container == nil;

    if (update) [self update];
    
    _lastFatherContainer = father.container;
    _lastIdentifierElement = self.currentIdentifierElement;
    return NO;
}

- (void)update{}

- (void)recieve:(LAHConstruct*)object{}

#pragma mark - Interpreter
- (void)addIdentifier:(LAHRecognizer *)identifier{
    if (_identifiers == nil) [self.identifiers = [[NSMutableSet alloc] init] release];
    [(NSMutableSet *)_identifiers addObject:identifier];
    identifier.isIdentifier = YES;
}

#pragma mark - Log
- (NSString *)infoProperties{
    NSMutableString *info = [NSMutableString string];
    if (_key) [info appendFormat:@"key=%@, ", _key];
    if (_identifiers) {
        [info appendString:@"id={"];
        for (LAHRecognizer *r in _identifiers) {
            [info appendFormat:@"%@, ", r];
        }
        [info appendString:@"}, "];
    }
    
    return info;
}
@end

NSString * const gKeyLastFatherContainer = @"LFC";
NSString * const gKeyLastIdentifierElement = @"LIE";
NSString * const gKeyContainer = @"Con";


