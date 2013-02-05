//
//  LAHElementRecognizer.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/4/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHElementRecognizer.h"

@implementation LAHElementRecognizer
@synthesize tagName = _tagName, text = _text, attributes = _attributes;
@synthesize nextRecognizer = _nextRecognizer;

- (id)initWithNextRecognizer:(LAHElementRecognizer*)next{
    self = [super init];
    if (self) {
        _nextRecognizer = SafeRetain(next);
    }
    return self;
}

- (void)dealloc{
    SafeMemberRelease(_tagName);
    SafeMemberRelease(_text);
    SafeMemberRelease(_attributes);
    SafeMemberRelease(_nextRecognizer);
    [super dealloc];
}

- (BOOL)isMatchedWithElement:(id<LAHHTMLElement>)element{
    if (_tagName != nil) {
        if (![_tagName isEqualToString:element.tagName]) return NO;
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

- (NSUInteger)matchedElements:(NSMutableArray*)container from:(NSArray*)elements{
    NSUInteger nME = 0; //number of matched elements
    for (id<LAHHTMLElement> element in elements) {
        if (![self isMatchedWithElement:element]) continue;
        if (_nextRecognizer == nil) {
            //current element is the target element
            [container addObject:element];
            nME += 1;
        }else{
            //target element may in the children
            nME += [_nextRecognizer matchedElements:container from:element.children];
        }
    }
    return nME;
}

@end
