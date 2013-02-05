//
//  LAHElementRecognizer.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/4/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LAHHTMLProtocols.h"

@interface LAHElementRecognizer : NSObject{
    NSString *_tagName;
    NSString *_text;
    NSDictionary *_attributes;
    
    LAHElementRecognizer *_nextRecognizer;
}
@property(nonatomic, copy)NSString *tagName;
@property(nonatomic, copy)NSString *text;
@property(nonatomic, retain)NSDictionary *attributes;
@property(nonatomic, retain)LAHElementRecognizer *nextRecognizer;
- (id)initWithNextRecognizer:(LAHElementRecognizer*)next;
- (BOOL)isMatchedWithElement:(id<LAHHTMLElement>)element;
- (NSUInteger)matchedElements:(NSMutableArray*)container from:(NSArray*)elements;
@end
