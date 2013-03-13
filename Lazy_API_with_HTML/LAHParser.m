//
//  LAHParser.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 3/9/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHParser.h"
#import "LAHStmt.h"
#import "LAHInterface.h"
#import "Token.h"

@implementation LAHParser

#pragma mark Initialization
- (id)initWithString:(NSString *)source {
	if ((self = [self init])) {
		tokens = [Token tokenizeString:source];
		index = 0;
	}
	return self;
}

#pragma mark - Key words
/**
 * Returns YES if the given string a Python keyword.
 */
+ (BOOL)isKeyword:(NSString *)string {
    static NSSet *keywords = nil;
    if (!keywords) {
        keywords = [[NSSet alloc] initWithObjects:
                    LAHEntArr,
                    LAHEntDic,
                    LAHEntFet,
                    LAHEntOpe,
                    LAHEntRec,
                    LAHEntDow,
                    LAHParaId,
                    LAHParaKey,
                    LAHParaSym,
                    LAHParaRoot,
                    LAHParaTag,
                    LAHParaText,
                    LAHParaRange,
                    LAHParaIndex,
                    LAHValText,
                    LAHValTag,
                    LAHValNone,
                    LAHValAll,
                    nil];
    }
    return [keywords containsObject:string];
}

+ (BOOL)isPropertyName:(NSString *)name{
    static NSSet *keywords = nil;
    if (!keywords) {
        keywords = [[NSSet alloc] initWithObjects:
                    LAHParaId,
                    LAHParaKey,
                    LAHParaSym,
                    LAHParaRoot,
                    LAHParaPath,
                    LAHParaTag,
                    LAHParaText,
                    LAHParaRange,
                    LAHParaIndex,
                    nil];
    }
    return [keywords containsObject:name];
}

#pragma mark Parsing helpers

/**
 * Returns the current token.
 */
- (Token *)token {
	if (index < [tokens count]) {
		return [tokens objectAtIndex:index];
	} else {
		return [Token EOFToken];
	}
}

/**
 * Advance to the next token, making it the new current token.
 */
- (void)advance {
	index += 1;
    NSLog(@"%@", [[self token] stringValue]);
}

/**
 * Returns YES if the current token matches the given one and consumes it
 * or returns NO and keeps the current token.
 */
- (BOOL)at:(NSString *)token {
	if ([[self token] isEqualToString:token]) {
		[self advance];
		return YES;
	}
	return NO;
}

/**
 * Raises a SyntaxError exception with the given message.
 */
- (id)error:(NSString *)message {
    message = [NSString stringWithFormat:@"%@ but found %@ in line %d",
               message,
               [[self token] stringValue],
               [[self token] lineNumber]];
	@throw [NSException exceptionWithName:@"SyntaxError" reason:message userInfo:nil];
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

#pragma mark Suite parsing
- (LAHStmtSuite *)parse{
    NSMutableArray *stmts = [NSMutableArray array];
	while (![self at:@"!EOF"]) {
		if (![self at:@"\n"]) {
            [stmts addObject:[self parseEntity]];
		}
	}
    LAHStmtSuite *suite = [[[LAHStmtSuite alloc] init] autorelease];
    suite.statements = stmts;
	return suite;
}

#pragma mark - Parse Entity
- (LAHStmt *)parseChild{
    NSString *value = [[self token] stringValue];
	unichar ch = [value characterAtIndex:0];
    if (ch == '\'') {
        [self advance]; [self expect:@"\n"];
        LAHStmtGain *gain = [[[LAHStmtGain alloc] init] autorelease];
        gain.name = value;
        return gain;
    }else{
        return [self parseEntity];
    }
    return [self error:@"expected CHILD"];
}

- (LAHStmtEntity *)parseEntity{
    LAHStmtEntity *entity = nil;
    if ([self at:LAHEntArr]) entity = [[LAHStmtArray alloc] init];
    else if ([self at:LAHEntDic]) entity = [[LAHStmtDictionary alloc] init];
    else if ([self at:LAHEntFet]) entity = [[LAHStmtFetcher alloc] init];
    else if ([self at:LAHEntOpe]) entity = [[LAHStmtOperation alloc] init];
    else if ([self at:LAHEntRec]) entity = [[LAHStmtRecgnizer alloc] init];
    else if ([self at:LAHEntDow]) entity = [[LAHStmtDownloader alloc] init];
    else {
        NSString *expStr = [NSString stringWithFormat:@"expected: %@, %@, %@, %@, %@, %@,", LAHEntArr, LAHEntDic, LAHEntFet, LAHEntOpe, LAHEntRec, LAHEntDow];
        [self error:expStr];
    }
    //LAHStmtEntity *entity = [[[LAHStmtEntity alloc] init] autorelease];
    //entity.type = type;
    
    NSString *tokenValue = [[self token] stringValue];
	unichar ch = [tokenValue characterAtIndex:0];
    if (ch == '\'') {
        [self advance];
        entity.generate = tokenValue;
    }
    
    if ([self at:@"("]) {
        NSArray *pS = [self parseProperties];
        entity.properties = pS;
	}
    
    if ([self at:@":"]) {
        [self expect:@"\n"];
        if ([self at:@"!INDENT"]) {
            NSMutableArray *children = [NSMutableArray array];
            while (![self at:@"!DEDENT"]) {
                [children addObject:[self parseChild]];
            }
            entity.children = children;
        }
    }else{
        [self expect:@"\n"];
    }
    
    return [entity autorelease];
}
/*
- (LAHStmtGenerate *)parseGenerate{
    NSString *tokenValue = [[self token] stringValue];
	unichar ch = [tokenValue characterAtIndex:0];
	if (ch == '\'') {
        [self advance];
	}
	return [self error:@"expected GENERATE"];;
}*/

#pragma mark - Parse Property
- (NSArray *)parseProperties{
    NSMutableArray *properties = [[[NSMutableArray alloc] init] autorelease];
    if ([self at:@")"]) {
		return nil;
	}
    [properties addObject:[self parseProperty]];
    while ([self at:@","]) {
		if ([self at:@")"]) {
			return nil;
		}
		[properties addObject:[self parseProperty]];
	}
	[self expect:@")"];
	
    return properties;
}

- (LAHStmtProperty *)parseProperty{
    Token *next = [tokens objectAtIndex:index + 1];
    NSString *nextValue = next.stringValue;
    NSString *name = nil; LAHStmtValue *value = nil;
    if ([nextValue isEqualToString:@"="]) {
        name = [self parsePropertyName];
        if ([self at:@"="]) {
            value = [self parseValue];
        }
    }else if ([nextValue isEqualToString:@","] || [nextValue isEqualToString:@")"]) {
        name = LAHParaDefault;
        value = [self parseValue];
    }
    if (name && value) {
        LAHStmtProperty *pro = [[[LAHStmtProperty alloc] init] autorelease];
        pro.name = name;
        pro.value = value;
        return pro;
    }

    return [self error:@"expected PORPERTY"];
}

- (NSString *)parsePropertyName{
    NSString *name = self.token.stringValue;
	unichar ch = [name characterAtIndex:0];
	if (([LAHParser isPropertyName:name]) || ch == '"') {
		[self advance];
		return name;
	}
	return [self error:@"expected PORPERTY NAME"];
}

- (LAHStmtValue *)parseValue{
    NSString *value = self.token.stringValue;
	unichar ch = self.token.firstCharacter;
    if (ch == '"' || ch == '_' || isalnum(ch)) {
        [self advance];
        LAHStmtValue *va = [[[LAHStmtValue alloc] init] autorelease];
        va.string = value;
        return va;
    } else if (ch == '\'') {
        [self advance];
        LAHStmtGain *gain = [[[LAHStmtGain alloc] init] autorelease];
        gain.name = value;
        return gain;
    } else if ([self at:@"("]) {
		return [self parseTuple];
	} else if ([self at:@"{"]) {
		return [self parseSet];
	}
    return [self error:@"expexted VALUE"];
}

- (LAHStmtTuple *)parseTuple{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    while (![self at:@")"]) {
        if (![self at:@","]) {
            [values addObject:[self parseValue]];
        }
    }
    LAHStmtTuple *tuple = [[LAHStmtTuple alloc] init];
    tuple.values = values;
    return [tuple autorelease];
}

- (LAHStmtSet *)parseSet{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    while (![self at:@"}"]) {
        if (![self at:@","]) {
            [values addObject:[self parseValue]];
        }
    }
    LAHStmtSet *tuple = [[LAHStmtSet alloc] init];
    tuple.values = values;
    return [tuple autorelease];
}

@end

