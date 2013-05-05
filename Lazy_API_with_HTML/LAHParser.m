//
//  LAHParser.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 3/9/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHParser.h"
#import "LAHStmt.h"
#import "LAHToken.h"

@interface LAHParser ()
@property(nonatomic, retain)NSArray *tokens;
@property(nonatomic, retain)LAHToken *eof;
@property(nonatomic, readonly)LAHToken *token;

- (LAHStmtEntity *)parseEntity;
- (LAHStmtAttribute *)parseAttribute;
- (LAHStmtRef *)parseReference;
- (LAHStmtValue *)parseValue;
- (LAHStmtValue *)parseTagName;
- (LAHStmtNumber *)parseNumber;
- (LAHStmtValue *)parseTransferredValue;
- (LAHStmtMultiple *)parseMultipleWithLeft:(NSString *)left right:(NSString *)right;

- (BOOL)isHTMLTagName;
- (BOOL)isTextTag;
- (BOOL)isAttributeName;
- (BOOL)isNumber;
- (BOOL)isMethodName;

- (void)advance;
- (BOOL)at:(NSString *)token;
- (void)expect:(NSString *)token;
- (id)error:(NSString *)message;

@end

@implementation LAHParser
@synthesize tokens = _tokens, eof = _eof;
@dynamic token;

#pragma mark - Class Basic
- (id)initWithTokens:(NSArray *)tokens{
    if (self = [self init]) {
        self.tokens = tokens;
        _index = 0;
        [self.eof = [[LAHToken alloc] initAsEOFToken] release];
    }
    return self;
}

- (void)dealloc{
    self.tokens = nil;
    self.eof = nil;
    [super dealloc];
}

#pragma mark Suite parsing
- (LAHStmtSuite *)parseCommand{
    LAHStmtSuite *suite = [[LAHStmtSuite alloc] init];

	while (![self at:gEof]) {
        LAHStmtEntity *entity = nil;
        if ( (entity = [self parseEntity]) ) {
            [suite.statements addObject:entity];
        }
	}
    
	return [suite autorelease];
}

#pragma mark - Parse Entity
- (LAHStmtEntity *)parseEntity{
    if (![self at:@"<"]) return nil;
    
    //Entity name or HTML tag name
    LAHStmtEntity *entity = nil;
    if ([self at:LAHEntArr]) {
        
        entity = [[LAHStmtArray alloc] init];
    
    }else if ([self at:LAHEntDic]) {
        
        entity = [[LAHStmtDictionary alloc] init];
    
    }else if ([self at:LAHEntStr]) {
        
        entity = [[LAHStmtString alloc] init];
    
    }else if ([self at:LAHEntOpe]) {
        
        entity = [[LAHStmtOperation alloc] init];
    
    }else if ([self at:LAHEntPage]) {
        
        entity = [[LAHStmtPage alloc] init];
    
    }else if ([self at:LAHEntTag]) {
        
        entity = [[LAHStmtTag alloc] init];

    }else if ([self isTextTag] || [self isHTMLTagName]) {
        
        entity = [[LAHStmtTag alloc] init];
    
        LAHStmtAttribute *attribute = [[LAHStmtAttribute alloc] init];
        attribute.name = LAHParaTag;
        attribute.value = [self parseTagName];

        [entity.attributes addObject:attribute];
        
    } else if ([self.token.stringValue isEqualToString:@"{"]) {
        
        entity = [[LAHStmtTag alloc] init];
        
        LAHStmtAttribute *attribute = [[LAHStmtAttribute alloc] init];
        attribute.name = LAHParaTag;
        
        LAHStmtMultiple *tagNames = [self parseMultipleWithLeft:@"{" right:@"}"];
        attribute.value = tagNames;
        
        [entity.attributes addObject:attribute];
        
    } else {
        
        [self expect:@"Entity Name (e.x. arr, dic, str, ope, page, tag)"];
        return nil;
        
    }
    
    
    //Attributes
    while ( ![self at:@">"] ) {
        LAHStmtAttribute *attribute = nil;
        
        if ( (attribute = [self parseAttribute]) ) {
            
            [entity.attributes addObject:attribute];

        } else {
            
            [self expect:@"Attribute Name"];
            
        }
 
    };
    
    
    //Next Line
    [self expect:gNextLine];
    
    
    //Children entity
    if ([self at:gIndent]) {
        while (![self at:gDedent]) {
            
            LAHStmt *stmt = nil;
            if ( (stmt = [self parseEntity]) ) {
                
                [entity.children addObject:stmt];
                
            } else if ( (stmt = [self parseReferenceAsChild]) ) {
                
                [entity.children addObject:stmt];
                
            }
        }
    }
    
    return [entity autorelease];
}

#pragma mark - Parse Attribute
- (LAHStmtAttribute *)parseAttribute{
    
    //Name
    if ( ![self isAttributeName] ) return nil;
    
    LAHStmtAttribute *attribute = [[LAHStmtAttribute alloc] init];
    attribute.name = self.token.stringValue;
    [self advance];
    
    
    //Regular Expression
    if ( [self at:@"."] ) {
    
        if ([self isMethodName]) {
            
            attribute.methodName = self.token.stringValue;
            [self advance];
            attribute.args = [self parseMultipleWithLeft:@"(" right:@")"];
        
        }else{
            
            [self expect:@"Method name"];
        
        }

    }
    
    
    //Assignment operator
    [self expect:@"="];
    
    
    //Value
    LAHStmtValue *value = nil;
    if ( (value = [self parseSingleValue]) ) {
        
        attribute.value = value;
        
    }else if ( (value = [self parseMultipleWithLeft:@"(" right:@")"]) ) {
        
        attribute.value = value;
        
    }else if ( (value = [self parseMultipleWithLeft:@"{" right:@"}"]) ) {
        
        attribute.value = value;
        
    }else{
        
        [self expect:@"Attribute Value (e.x. \"string\", 'gain', _transferedValue, number, (tuple), {set})"];
        return nil;
        
    }
    
    return [attribute autorelease];
}

#pragma mark - Parse Value
- (LAHStmtValue *)parseValue{
    unichar ch = self.token.firstCharacter;
    if (ch != '"') return nil;

    LAHStmtValue *value = [[LAHStmtValue alloc] init];
    value.value = self.token.stringByUnescapingStringValue;
    [self advance];
    
    return [value autorelease];
}

- (LAHStmtValue *)parseTransferredValue{
    unichar ch = self.token.firstCharacter;
    if (ch != '_') return nil;
    
    LAHStmtValue *value = [[LAHStmtValue alloc] init];
    value.value = self.token.stringValue;
    [self advance];

    return [value autorelease];
}

- (LAHStmtValue *)parseTagName{
    if (![self isHTMLTagName]) return nil;
    
    LAHStmtValue *value = [[LAHStmtValue alloc] init];
    value.value = self.token.stringValue;
    [self advance];

    return [value autorelease];
}

- (LAHStmtRef *)parseReference{
    unichar ch = self.token.firstCharacter;
    if (ch != '\'') return nil;

    LAHStmtRef *value = [[LAHStmtRef alloc] init];
    value.name = self.token.stringByUnescapingStringValue;
    [self advance];
    
    return [value autorelease];
}

- (LAHStmtRef *)parseReferenceAsChild{
    LAHStmtRef *value = [self parseReference];
    [self expect:@"\n"];
    return value;
}

- (LAHStmtNumber *)parseNumber{
    if ( ![self isNumber] ) return nil;
    
    LAHStmtNumber *number = [[LAHStmtNumber alloc] init];
    number.value = self.token.stringValue;
    [self advance];
    
    return [number autorelease];
}

- (LAHStmtValue *)parseSingleValue{
    LAHStmtValue *value = nil;
    
    if      ( (value = [self parseValue]) ) ;
    else if ( (value = [self parseReference]) ) ;
    else if ( (value = [self parseTransferredValue]) ) ;
    else if ( (value = [self parseNumber]) ) ;
    else if ( (value = [self parseTagName]) ) ;
    else ;
    
    return value;
}

- (LAHStmtMultiple *)parseMultipleWithLeft:(NSString *)left right:(NSString *)right{
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    while (
           ![self at:right] &&
           ([self at:left] || [self at:@","])
           ) {
        
        LAHStmtValue *value = nil;
        if ( (value = [self parseSingleValue]) ) {
            [values addObject:value];
        }
        
    }
    
    LAHStmtMultiple *multiple = nil;
    if (values.count != 0) {
        multiple = [[LAHStmtMultiple alloc] init];
        multiple.values = values;
    }
    
    [values release];
    return [multiple autorelease];

}

#pragma mark - Parsing helpers
/**
 * Returns the current token.
 */
- (LAHToken *)token {
	if (_index < [_tokens count]) {
		return [_tokens objectAtIndex:_index];
	} else {
		return _eof;
	}
}

/**
 * Advance to the next token, making it the new current token.
 */
- (void)advance {
	_index += 1;
    //NSLog(@"%@", self.token.stringValue);
}

/**
 * Returns YES if the current token matches the given one and consumes it
 * or returns NO and keeps the current token.
 */
- (BOOL)at:(NSString *)token {
	if ([self.token isEqualToString:token]) {
		[self advance];
		return YES;
	}
	return NO;
}

/**
 * Raises an exception if the current token does not match the given one.
 * Otherwise consume the token and advance to the next token.
 */
- (void)expect:(NSString *)token {
	if (![self at:token]) {
        [self error:[NSString stringWithFormat:@"expected %@", token]];
	}
}

/**
 * Raises a SyntaxError exception with the given message.
 */
- (id)error:(NSString *)message {
    message = [NSString stringWithFormat:@"%@ but found %@ in line %d",
               message,
               self.token.stringValue,
               self.token.lineNumber];
	@throw [NSException exceptionWithName:@"SyntaxError" reason:message userInfo:nil];
}

#pragma mark - Specific
- (BOOL)isHTMLTagName{
    NSString *value = self.token.stringValue;
    return isByRegularExpression(value, gHtmlEX);
    
}

- (BOOL)isTextTag{
    
    NSString *value = self.token.stringValue;
    
    if ([value isEqualToString:LAHEntTextTag]) {
		return YES;
    }
	
    return NO;
}


- (BOOL)isAttributeName{
    return YES;
}

- (BOOL)isNumber{
    
    NSString *value = self.token.stringValue;
    return isByRegularExpression(value, gNumberEX);
}

- (BOOL)isMethodName{
    return YES;
}

/*
+ (BOOL)isAttibuteName:(NSString *)name{
    static NSSet *keywords = nil;
    if (!keywords) {
        keywords = [[NSSet alloc] initWithObjects:
                    LAHParaId,
                    LAHParaKey,
                    LAHParaSym,
                    LAHParaReg,
                    LAHParaRoot,
                    LAHParaPath,
                    LAHParaTag,
                    LAHParaText,
                    LAHParaRange,
                    LAHParaIndex,
                    LAHParaIsText,
                    LAHParaIsDemocratic,
                    nil];
    }
    return [keywords containsObject:name];
}
*/

@end

