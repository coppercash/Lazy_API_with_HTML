//
//  Token.h
//  Pyphon
//
//  Created by Stefan Matthias Aust on 15.01.11.
//  Copyright 2011 I.C.N.H. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LAHToken : NSObject {
	NSString *source;
	NSRange range;
}

+ (NSArray *)tokenizeString:(NSString *)string;

- (id)initWithSource:(NSString *)source range:(NSRange)range;
- (id)initAsEOFToken;
- (BOOL)isEqualToString:(NSString *)string;
- (BOOL)isNumber;
- (BOOL)isString;
- (NSNumber *)numberValue;
- (NSString *)stringValue;
- (NSString *)stringByUnescapingStringValue;
- (unichar)firstCharacter;
- (NSUInteger)lineNumber;

@end

extern NSString * const gIndent;
extern NSString * const gDedent;
extern NSString * const gEof;
extern NSString * const gNextLine;