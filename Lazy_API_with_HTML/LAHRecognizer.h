//
//  LAHRecognizer.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"

@interface LAHRecognizer : LAHNode {
    NSString *_tagName;
    NSString *_text;
    NSDictionary *_attributes;
    NSRange _range;
}
@property(nonatomic, copy)NSString *tagName;
@property(nonatomic, copy)NSString *text;
@property(nonatomic, retain)NSDictionary *attributes;
@property(nonatomic, assign)NSRange range;
- (BOOL)isElementMatched:(id<LAHHTMLElement>)element atIndex:(NSUInteger)index;
- (void)setIndex:(NSUInteger)index;
@end