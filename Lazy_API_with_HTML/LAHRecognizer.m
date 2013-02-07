//
//  LAHRecognizer.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHRecognizer.h"
#import "LAHProtocols.h"

@implementation LAHRecognizer
#pragma mark - Life Cycle
- (id)init{
    self = [super init];
    if (self) {
        self.range = NSMakeRange(0, NSUIntegerMax);
    }
    return self;
}

- (id)initWithFirstChild:(LAHNode*)firstChild variadicChildren:(va_list)children{
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        self.range = NSMakeRange(0, NSUIntegerMax);
    }
    return self;
}

- (void)dealloc{
    [_tagName release]; _tagName = nil;
    [_text release]; _text = nil;
    [_attributes release]; _attributes = nil;

    [super dealloc];
}

#pragma mark - Setter
- (void)setIndex:(NSUInteger)index{
    _range = NSMakeRange(index, 1);
}

#pragma mark - Recursive
- (BOOL)isElementMatched:(id<LAHHTMLElement>)element atIndex:(NSUInteger)index{
    if (index < _range.location || _range.location + _range.length <= index) {
        return NO;
    }
    if (_tagName != nil) {
        NSString *tagName = element.tagName;
        if (![_tagName isEqualToString:tagName]) return NO;
    }
    if (_text != nil) {
        if (![_text isEqualToString:element.text]) return NO;
    }
    if (_attributes != nil) {
        if (element.attributes == nil) return NO;
        for (NSString *key in _attributes.allKeys) {
            NSString *rAV = [_attributes valueForKey:key];   //recognizer attribute value
            NSString *eAV = [element.attributes valueForKey:key];   //element attribute value
            if (eAV == nil || ![rAV isEqualToString:eAV]) return NO;
        }
    }
    return YES;
}

- (void)handleElement:(id<LAHHTMLElement>)element atIndex:(NSUInteger)index{
    if (![self isElementMatched:element atIndex:index]) return;
    DLogElement(element)
    
    NSArray *fakeChildren = [[NSArray alloc] initWithArray:_children];
    for (LAHNode *node in fakeChildren) {
        NSUInteger index = 0;
        for (id<LAHHTMLElement> e in element.children) {
            [node handleElement:e atIndex:index];
            index++;
        }
    }
    [fakeChildren release];
}

@end