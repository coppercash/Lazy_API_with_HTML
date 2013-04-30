//
//  Token.m
//  Pyphon
//
//  Created by Stefan Matthias Aust on 15.01.11.
//  Copyright 2011 I.C.N.H. All rights reserved.
//

#import "LAHToken.h"

//#define RE @"(?m)^ *(?:#.*)?\n|#.*$|(^ +|\n|\\d+|\\w+|[()\\[\\]{}:.,;]|[+\\-*/%<>=]=?|!=|'(?:\\\\[n'\"\\\\]|[^'])*'|\"(?:\\\\[n'\"\\\\]|[^\"])*\")"


static NSString * const re = @"(?m)^ *(?:#.*)?\n|#.*$|(^ +|\n|\\d+|\\w+|[()\\[\\]{}:.,;]|[+\\-*/%<>=]=?|!=|'(?:\\\\[n'\"\\\\]|[^'])*'|\"(?:\\\\[n'\"\\\\]|[^\"])*\")";

@implementation LAHToken

+ (NSArray *)tokenizeString:(NSString *)source {
	NSMutableArray *tokens = [NSMutableArray array];
	__block NSInteger cur_indent = 0;
	__block NSInteger new_indent = 0;
	LAHToken *indent = [[LAHToken alloc] initAsIndentToken];
    LAHToken *dedent = [[LAHToken alloc] initAsDedentToken];
    
	// combine lines with trailing backslashes with following lines
	source = [source stringByReplacingOccurrencesOfString:@"\\\n" withString:@""];
	
	// assure that the source ends with a newline
	source = [source stringByAppendingString:@"\n"];
	
	// compile the regular expression to tokenize the source
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:re options:0 error:nil];
	
	// process matches from source when applying the regular expression
	[regex enumerateMatchesInString:source 
							options:0 
							  range:NSMakeRange(0, [source length]) 
						 usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
							 // did we get a match (empty lines and comments are ignored)?
							 NSRange range = [match rangeAtIndex:1];
							 if (range.location != NSNotFound) {
								 unichar ch = [source characterAtIndex:range.location];
								 if (ch == ' ') {
									 // compute new indentation which is applied before the next non-whitespace token
									 new_indent = range.length / 4;
								 } else {
									 if (ch == '\n') {
										 // reset indentation
										 new_indent = 0;
									 } else {
										 // found a non-whitespace token, apply new indentation
										 while (cur_indent < new_indent) {
											 [tokens addObject:indent];
											 cur_indent += 1;
										 }
										 while (cur_indent > new_indent) {
											 [tokens addObject:dedent];
											 cur_indent -= 1;
										 }
									 }
									 // add newline or non-whitespace token to result
                                     LAHToken *token = [[LAHToken alloc] initWithSource:source range:range];
									 [tokens addObject:token];
                                     [token release];
								 }
							 }
						 }];
	
	// balance pending INDENTs
	while (cur_indent > 0) {
		[tokens addObject:dedent];
		cur_indent -= 1;
	}
	
    [indent release];
    [dedent release];
    
	// return the tokens
	return tokens;
}

- (id)initAsIndentToken{
    return [self initWithSource:gIndent range:NSMakeRange(0, 7)];
}

- (id)initAsDedentToken{
    return [self initWithSource:gDedent range:NSMakeRange(0, 7)];
}

- (id)initAsEOFToken{
    return [self initWithSource:gEof range:NSMakeRange(0, 4)];
}

- (id)initWithSource:(NSString *)source_ range:(NSRange)range_ {
    if ((self = [super init])) {
        self->source = source_;
        self->range = range_;
    }
	return self;
}

- (BOOL)isEqualToString:(NSString *)string {
	return [[self stringValue] isEqualToString:string];
}

- (BOOL)isNumber {
    return isdigit([self firstCharacter]);
}

- (BOOL)isString {
    return '"' == [self firstCharacter] || '\'' == [self firstCharacter];
}

- (NSNumber *)numberValue {
    return [NSNumber numberWithInteger:[[self stringValue] integerValue]];
}

- (NSString *)stringValue {
    NSString *ret = [source substringWithRange:range];
	return ret;
}

- (NSString *)stringByUnescapingStringValue {
    NSUInteger length = range.length - 2;
    NSString *string = [source substringWithRange:NSMakeRange(range.location + 1, length)];
    NSMutableString *buffer = [NSMutableString stringWithCapacity:length];
    for (NSUInteger i = 0; i < length; i++) {
        unichar c = [string characterAtIndex:i];
        if (c == '\\') {
            c = [string characterAtIndex:++i];
            if (c == 'n') {
                c = '\n';
            }
        }
        [buffer appendFormat:@"%c", c];
    }
    return buffer;
}

- (unichar)firstCharacter {
    return [source characterAtIndex:range.location];
}

- (NSUInteger)lineNumber {
	NSUInteger lineNumber = 1;
	NSUInteger start = 0;
	NSRange r;
	while ((r = [source rangeOfString:@"\n" 
							  options:0 
								range:NSMakeRange(start, [source length] - start)]).location != NSNotFound) {
		start = r.location + r.length;
		if (range.location < start) {
			return lineNumber;
		}
		lineNumber += 1;
	}
	return lineNumber;
}

@end


NSString * const gIndent = @"!INDENT";
NSString * const gDedent = @"!DEDENT";
NSString * const gEof = @"!EOF";
NSString * const gNextLine = @"\n";

NSString * const gHtmlEX = @"^[a-zA-Z]+$";
NSString * const gNumberEX = @"^[0-9]+$";

bool isByRegularExpression(NSString *string, NSString *re){
    
    NSError *regError = nil;
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:re options:0 error:&regError];
    NSUInteger numberOfMatches = [regExp numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    [regExp release];
    return numberOfMatches != 0;
}
