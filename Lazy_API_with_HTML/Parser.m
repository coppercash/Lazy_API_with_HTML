//
//  Parser.m
//  Pyphon
//
//  Created by Stefan Matthias Aust on 15.01.11.
//  Copyright 2011 I.C.N.H. All rights reserved.
//

#import "Parser.h"

@implementation Parser


#pragma mark Initialization


- (id)initWithString:(NSString *)source {
	if ((self = [super init])) {
		tokens = [Token tokenizeString:source];
		index = 0;
	}
	return self;
}


/**
 * Returns YES if the given string a Python keyword.
 */
+ (BOOL)isKeyword:(NSString *)string {
    static NSSet *keywords = nil;
    if (!keywords) {
        keywords = [[NSSet alloc] initWithObjects:
                    @"and",
                    @"as",
                    @"assert",
                    @"break",
                    @"class",
                    @"continue",
                    @"def",
                    @"del",
                    @"elif",
                    @"else",
                    @"except",
                    @"exec",
                    @"finally",
                    @"for",
                    @"from",
                    @"global",
                    @"if",
                    @"import",
                    @"in",
                    @"is",
                    @"lambda",
                    @"not",
                    @"or",
                    @"pass",
                    @"raise",
                    @"return",
                    @"try",
                    @"while",
                    @"with",
                    @"yield",
                    nil];
    }
    return [keywords containsObject:string];
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


#pragma mark Expression list parsing


/**
 * Returns YES if the current token seems to be the beginning of a test expression.
 */
- (BOOL)has_test {
    NSString *token = [[self token] stringValue];
	unichar ch = [token characterAtIndex:0];
	return (isalnum(ch) && ![Parser isKeyword:token]) || strchr("+-([{\"'_", ch);
}

// testlist: test {',' test} [',']
- (NSArray *)parse_testlist_opt {
	NSMutableArray *exprs = [NSMutableArray array];
	if ([self has_test]) {
		[exprs addObject:[self parse_test]];
		while ([self at:@","]) {
			if (![self has_test]) {
				break;
			}
			[exprs addObject:[self parse_test]];
		}
	}
	return exprs;
}

// testlist: test {',' test} [',']
- (Expr *)parse_testlist_as_tuple {
	Expr *expr = [self parse_test];
	if (![self at:@","]) {
		return expr;
	}
	NSMutableArray *exprs = [NSMutableArray arrayWithObject:expr];
	if ([self has_test]) {
        [exprs addObjectsFromArray:[self parse_testlist_opt]];
    }
	return [TupleExpr exprWithExprs:exprs];
}


#pragma mark Expression parsing


// NAME
- (NSString *)parse_NAME {
	NSString *name = [[self token] stringValue];
	unichar ch = [name characterAtIndex:0];
	if ((isalpha(ch) && ![Parser isKeyword:name]) || ch == '_') {
		[self advance];
		return name;
	}
	return [self error:@"expected NAME"]; 
}

// subscript: test | [test] ':' [test] [':' [test]]
- (Expr *)parse_subscript {
	Expr *start, *stop, *step;
	if ([self has_test]) {
		start = [self parse_test];
		if (![self at:@","]) {
			return start;
		}
	} else {
		start = [LiteralExpr exprWithValue:[Pyphon None]];
		[self expect:@":"];
	}
	if ([self has_test]) {
		stop = [self parse_test];
	} else {
		stop = [LiteralExpr exprWithValue:[Pyphon None]];
	}
	if ([self at:@":"]) {
		if ([self has_test]) {
			step = [self parse_test];
		} else {
			step = [LiteralExpr exprWithValue:[Pyphon None]];
		}
	} else {
		step = [LiteralExpr exprWithValue:[Pyphon None]];
	}
	return [CallExpr exprWithFuncExpr:[VariableExpr exprWithName:@"slice"]
                             argExprs:[NSArray arrayWithObjects:start, stop, step, nil]];
}

// dictorsetmaker: test ':' test {',' test ':' test} [','] | testlist
- (Expr *)parse_dictorsetmaker {
	if ([self at:@"}"]) {
		return [DictExpr exprWithExprs:[NSArray array]];
	}
	Expr *expr = [self parse_test];
	if ([self at:@":"]) {
		NSArray *pair = [NSArray arrayWithObjects:expr, [self parse_test], nil];
		NSMutableArray *exprs = [NSMutableArray arrayWithObject:pair];
		while ([self at:@","]) {
			if ([self at:@"}"]) {
				return [DictExpr exprWithExprs:exprs];
			}
			Expr *key = [self parse_test];
			[self expect:@":"];
			pair = [NSArray arrayWithObjects:key, [self parse_test], nil];
			[exprs addObject:pair];
		}
		[self expect:@"}"];
		return [DictExpr exprWithExprs:exprs];
	} else {
		NSMutableArray *exprs = [NSMutableArray arrayWithObject:expr];
		while ([self at:@","]) {
			if ([self at:@"}"]) {
				return [SetExpr exprWithExprs:exprs];
			}
			[exprs addObject:[self parse_test]];
		}
		[self expect:@"}"];
		return [SetExpr exprWithExprs:exprs];
	}
}

// private
- (Expr *)parse_listmaker {
	NSArray *exprs = [self parse_testlist_opt];
	[self expect:@"]"];
	return [ListExpr exprWithExprs:exprs];
}

// private
- (Expr *)parse_tuplemaker {
	if ([self at:@")"]) {
		return [TupleExpr exprWithExprs:[NSArray array]];
	}
	Expr *expr = [self parse_test];
	if ([self at:@")"]) {
		return expr;
	}
	[self expect:@","];
	NSMutableArray *exprs = [NSMutableArray arrayWithObject:expr];
	[exprs addObjectsFromArray:[self parse_testlist_opt]];
	[self expect:@")"];
	return [TupleExpr exprWithExprs:exprs];
}

// atom: '(' [testlist] ')' | '[' [testlist] ']' | '{' [dictorsetmaker] '}' | NAME | NUMBER | STRING+
- (Expr *)parse_atom {
	if ([self at:@"("]) return [self parse_tuplemaker];
	if ([self at:@"["]) return [self parse_listmaker];
	if ([self at:@"{"]) return [self parse_dictorsetmaker];
	
	NSString *tokenValue = [[self token] stringValue];
	unichar ch = [tokenValue characterAtIndex:0];

	if (isalpha(ch) || ch == '_') {
		[self advance];
		return [VariableExpr exprWithName:tokenValue];
	}
	if (isdigit(ch)) {
		[self advance];
		return [LiteralExpr exprWithValue:[NSNumber numberWithInteger:[tokenValue integerValue]]];
	}
	if (ch == '"' || ch == '\'') {
		NSMutableString *s = [NSMutableString string];
		while (ch == '"' || ch == '\'') {
			[s appendString:[[self token] stringByUnescapingStringValue]];
			[self advance];
			ch = [[[self token] stringValue] characterAtIndex:0];
		}
		return [LiteralExpr exprWithValue:s];
	}
	return [self error:@"expected (, [, {, NAME, NUMBER or STRING"];
}

// power: atom {trailer}
- (Expr *)parse_power {
	Expr *expr = [self parse_atom];
	// trailer: '(' [testlist] ')' | '[' subscript ']' | '.' NAME
	while (TRUE) {
		if ([self at:@"("]) {
			expr = [CallExpr exprWithFuncExpr:expr argExprs:[self parse_testlist_opt]];
			[self expect:@")"];
		} else if ([self at:@"["]) {
			expr = [IndexExpr exprWithExpr:expr subscriptExpr:[self parse_subscript]];
			[self expect:@"]"];
		} else if ([self at:@"."]) {
			expr = [AttrExpr exprWithExpr:expr name:[self parse_NAME]];
		} else {
			break;
		}
	}
	return expr;
}

// factor: ('+'|'-') factor | power
- (Expr *)parse_factor {
	if ([self at:@"-"]) {
		return [NegExpr exprWithExpr:[self parse_factor]];
	}
	if ([self at:@"+"]) {
		return [PosExpr exprWithExpr:[self parse_factor]];
	}
	return [self parse_power];
}

// term: factor {('*'|'/'|'%') factor}
- (Expr *)parse_term {
	Expr *expr = [self parse_factor];
	while (TRUE) {
		if ([self at:@"*"]) {
			expr = [MulExpr exprWithLeftExpr:expr rightExpr:[self parse_factor]];
		} else if ([self at:@"/"]) {
			expr = [DivExpr exprWithLeftExpr:expr rightExpr:[self parse_factor]];
		} else if ([self at:@"%"]) {
			expr = [ModExpr exprWithLeftExpr:expr rightExpr:[self parse_factor]];
		} else {
			break;
		}
	}
	return expr;
}

// expr: term {('+'|'-') term}
- (Expr *)parse_expr {
	Expr *expr = [self parse_term];
	while (TRUE) {
		if ([self at:@"+"]) {
			expr = [AddExpr exprWithLeftExpr:expr rightExpr:[self parse_term]];
		} else if ([self at:@"-"]) {
			expr = [SubExpr exprWithLeftExpr:expr rightExpr:[self parse_term]];
		} else {
			break;
		}
	}
	return expr;
}

// comparison: expr [('<'|'>'|'=='|'>='|'<='|'!='|'in'|'not' 'in'|'is' ['not']) expr]
- (Expr *)parse_comparison {
	Expr *expr = [self parse_expr];
	if ([self at:@"<"]) return [LtExpr exprWithLeftExpr:expr rightExpr:[self parse_expr]];
	if ([self at:@">"]) return [GtExpr exprWithLeftExpr:expr rightExpr:[self parse_expr]];
	if ([self at:@"=="]) return [EqExpr exprWithLeftExpr:expr rightExpr:[self parse_expr]];
	if ([self at:@"<="]) return [LeExpr exprWithLeftExpr:expr rightExpr:[self parse_expr]];
	if ([self at:@">="]) return [GeExpr exprWithLeftExpr:expr rightExpr:[self parse_expr]];
	if ([self at:@"!="]) return [NeExpr exprWithLeftExpr:expr rightExpr:[self parse_expr]];
	if ([self at:@"in"]) return [InExpr exprWithLeftExpr:expr rightExpr:[self parse_expr]];
	if ([self at:@"not"]) {
		[self expect:@"in"];
		return [NotExpr exprWithExpr: [InExpr exprWithLeftExpr:expr rightExpr:[self parse_expr]]];
	}
	if ([self at:@"is"]) {
		if ([self at:@"not"]) {
			return [NotExpr exprWithExpr:[IsExpr exprWithLeftExpr:expr rightExpr:[self parse_expr]]];
		}
		return [IsExpr exprWithLeftExpr:expr rightExpr:[self parse_expr]];
	}
	return expr;
}

// not_test: 'not' not_test | comparison
- (Expr *)parse_not_test {
	if ([self at:@"not"]) {
		return [NotExpr exprWithExpr:[self parse_not_test]];
	}
	return [self parse_comparison];
}

// and_test: not_test {'and' not_test}
- (Expr *)parse_and_test	{
	Expr *expr = [self parse_not_test];
	while ([self at:@"and"]) {
		expr = [AndExpr exprWithLeftExpr:expr rightExpr:[self parse_not_test]];
	}
	return expr;
}

// or_test: and_test {'or' and_test}
- (Expr *)parse_or_test	{
	Expr *expr = [self parse_and_test];
	while ([self at:@"or"]) {
		expr = [OrExpr exprWithLeftExpr:expr rightExpr:[self parse_and_test]];
	}
	return expr;
}

// test: or_test ['if' or_test 'else' test]
- (Expr *)parse_test {
	Expr *expr = [self parse_or_test];
	if ([self at:@"if"]) {
		Expr *thenExpr = expr;
		Expr *testExpr = [self parse_or_test];
		[self expect:@"else"];
		return [IfExpr exprWithTestExpr:testExpr thenExpr:thenExpr elseExpr:[self parse_test]];
	}
	return expr;
}


#pragma mark Simple statement parsing


// expr_stmt: testlist [('+=' | '-=' | '*=' | '/=' | '%=' | '=') testlist]
- (Stmt *)parse_expr_stmt {
    if ([self has_test]) {
        Expr *expr = [self parse_testlist_as_tuple];
		if ([self at:@"="]) return [AssignStmt stmtWithLeftExpr:expr rightExpr:[self parse_testlist_as_tuple]];
		if ([self at:@"+="]) return [AddAssignStmt stmtWithLeftExpr:expr rightExpr:[self parse_testlist_as_tuple]];
		if ([self at:@"-="]) return [SubAssignStmt stmtWithLeftExpr:expr rightExpr:[self parse_testlist_as_tuple]];
		return [ExprStmt stmtWithExpr:expr];
	}
	return [self error:@"expected statement"];
}

// small_stmt: expr_stmt | pass_stmt | flow_stmt
// flow_stmt: break_stmt | return_stmt | raise_stmt
- (Stmt *)parse_small_stmt {
	if ([self at:@"pass"]) return [PassStmt stmt];
	if ([self at:@"break"]) return [BreakStmt stmt];
	if ([self at:@"return"]) {
        Expr *expr = [self has_test] ? [self parse_testlist_as_tuple] : [LiteralExpr exprWithValue:[Pyphon None]];
		return [ReturnStmt stmtWithExpr:expr];
	}
	if ([self at:@"raise"]) {
		return [RaiseStmt stmtWithExpr:[self has_test] ? [self parse_test] : nil];
	}
	return [self parse_expr_stmt];
}

// simple_stmt: small_stmt {';' small_stmt} [';'] NEWLINE
- (NSArray *)parse_simple_stmt {
	NSMutableArray *stmts = [NSMutableArray arrayWithObject:[self parse_small_stmt]];
	while ([self at:@";"]) {
		if ([self at:@"\n"]) {
			return stmts;
		}
		[stmts addObject:[self parse_small_stmt]];
	}
	[self expect:@"\n"];
	return stmts;
}


#pragma mark Compount statement parsing


//private: ['else' ':' suite]
- (Suite *)parse_else {
	if ([self at:@"else"]) {
		[self expect:@":"];
		return [self parse_suite];
	}
	return [Suite suiteWithPassStmt];
}

// private: ['elif' test ':' suite | 'else' ':' suite]
- (Suite *)parse_if_stmt_cont {
	if ([self at:@"elif"]) {
		Expr *testExpr = [self parse_test];
		[self expect:@":"];
        Suite *thenSuite = [self parse_suite];
		return [Suite suiteWithStmt:[IfStmt stmtWithTestExpr:testExpr thenSuite:thenSuite elseSuite:[self parse_if_stmt_cont]]];
	}
	return [self parse_else];
}

// if_stmt: 'if' test ':' suite {'elif' test ':' suite} ['else' ':' suite]
- (Stmt *)parse_if_stmt {
	Expr *testExpr = [self parse_test];
	[self expect:@":"];
	Suite *thenSuite = [self parse_suite];
	return [IfStmt stmtWithTestExpr:testExpr thenSuite:thenSuite elseSuite:[self parse_if_stmt_cont]];
}

// while_stmt: 'while' test ':' suite ['else' ':' suite]
- (Stmt *)parse_while_stmt {
	Expr *testExpr = [self parse_test];
	[self expect:@":"];
	Suite *whileSuite = [self parse_suite];
	Suite *elseSuite = [self parse_else];
	return [WhileStmt stmtWithTestExpr:testExpr whileSuite:whileSuite elseSuite:elseSuite];
}

// exprlist: expr {',' expr} [',']
- (Expr *)parse_exprlist_as_tuple {
	Expr *expr = [self parse_expr];
	if (![self at:@","]) {
		return expr;
	}
	NSMutableArray *exprs = [NSMutableArray arrayWithObject:expr];
	while ([self has_test]) {
		[exprs addObject:[self parse_expr]];
		if (![self at:@","]) {
			break;
		}
	}
	return [TupleExpr exprWithExprs:exprs];
}

// for_stmt: 'for' exprlist 'in' testlist ':' suite ['else' ':' suite]
- (Stmt *)parse_for_stmt {
	Expr *targetExpr = [self parse_exprlist_as_tuple];
	[self expect:@"in"];
	Expr *iterExpr = [self parse_testlist_as_tuple];
	[self expect:@":"];
	Suite *forSuite = [self parse_suite];
	Suite *elseSuite = [self parse_else];
	return [ForStmt stmtWithTargetExpr:targetExpr iterExpr:iterExpr forSuite:forSuite elseSuite:elseSuite];
}

// except_clause: 'except' [test ['as' NAME]] ':' suite
- (ExceptClause *)parse_except_clause {
	Expr *exceptionsExpr = nil;
	NSString *name = nil;
	if (![self at:@":"]) {
		exceptionsExpr = [self parse_test];
		if ([self at:@"as"]) {
			name = [self parse_NAME];
		}
		[self expect:@":"];
	}
	return [ExceptClause exceptClauseWithExceptionsExpr:exceptionsExpr 
                                                   name:name 
                                                  suite:[self parse_suite]];
}

// try_stmt: 'try' ':' suite (except_clause {except_clause} ['else' ':' suite] | 'finally' ':' suite)
- (Stmt *)parse_try_stmt {
	[self expect:@":"];
	Suite *trySuite = [self parse_suite];
	if ([self at:@"finally"]) {
		return [TryFinallyStmt stmtWithTrySuite:trySuite finallySuite:[self parse_suite]];
	}
	[self expect:@"except"];
	NSMutableArray *exceptClauses = [NSMutableArray arrayWithObject:[self parse_except_clause]];
	while ([self at:@"except"]) {
		[exceptClauses addObject:[self parse_except_clause]];
	}
	Suite *elseSuite = [self parse_else];
	return [TryExceptStmt stmtWithTrySuite:trySuite exceptClauses:exceptClauses elseSuite:elseSuite];
}

// parameter: NAME ['=' test]
- (NSString *)parse_parameter:(NSMutableArray **)defexprs {
    NSString *name = [self parse_NAME];
    if ([self at:@"="]) {
        if (!*defexprs) {
            *defexprs = [NSMutableArray array];
        }
        [*defexprs addObject:[self parse_expr]];
    }
    return name;
}

// parameters: '(' [NAME {',' NAME} [',']] ')'
- (NSArray *)parse_parameters:(NSMutableArray **)defexprs {
	NSMutableArray *params = [NSMutableArray array];
	[self expect:@"("];
	if ([self at:@")"]) {
		return params;
	}
	[params addObject:[self parse_parameter:defexprs]];
	while ([self at:@","]) {
		if ([self at:@")"]) {
			return params;
		}
		[params addObject:[self parse_parameter:defexprs]];
	}
	[self expect:@")"];
	return params;
}

// funcdef: 'def' NAME parameters ':' suite
- (Stmt *)parse_funcdef {
	NSString *name = [self parse_NAME];
    NSArray *defexprs = nil;
	NSArray *params = [self parse_parameters:&defexprs];
	[self expect:@":"];
	return [DefStmt stmtWithName:name params:params defaults:defexprs suite:[self parse_suite]];
}

// classdef: 'class' NAME ['(' [test] ')'] ':' suite
- (Stmt *)parse_classdef {
	NSString *name = [self parse_NAME];
	Expr *superExpr = nil;
	if ([self at:@"("]) {
		if ([self at:@")"]) {
			superExpr = nil;
		} else {
			superExpr = [self parse_test];
			[self expect:@")"];
		}
	}
	[self expect:@":"];
	return [ClassStmt stmtWithName:name superExpr:superExpr suite:[self parse_suite]];
}

// compound_stmt: if_stmt | while_stmt | for_stmt | try_stmt | funcdef | classdef
- (Stmt *)parse_compound_stmt {
	if ([self at:@"if"]) return [self parse_if_stmt];
	if ([self at:@"while"]) return [self parse_while_stmt];
	if ([self at:@"for"]) return [self parse_for_stmt];
	if ([self at:@"try"]) return [self parse_try_stmt];
	if ([self at:@"def"]) return [self parse_funcdef];
	if ([self at:@"class"]) return [self parse_classdef];
	return nil;
}

// stmt: simple_stmt | compound_stmt
- (NSArray *)parse_stmt {
	Stmt *stmt = [self parse_compound_stmt];
	if (stmt) {
		return [NSArray arrayWithObject:stmt];
	}
	return [self parse_simple_stmt];
}


#pragma mark Suite parsing


// suite: simple_stmt | NEWLINE INDENT stmt+ DEDENT
- (Suite *)parse_suite {
	if ([self at:@"\n"]) {
		[self expect:@"!INDENT"];
		NSMutableArray *stmts = [NSMutableArray array];
		while (![self at:@"!DEDENT"]) {
			[stmts addObjectsFromArray:[self parse_stmt]];
		}
		return [Suite suiteWithStmts:stmts];
	}
	return [Suite suiteWithStmts:[self parse_simple_stmt]];
}

// file_input: {NEWLINE | stmt} ENDMARKER
- (Suite *)parse_file {
	NSMutableArray *stmts = [NSMutableArray array];
	while (![self at:@"!EOF"]) {
		if (![self at:@"\n"]) {
			[stmts addObjectsFromArray:[self parse_stmt]];
		}
	}
	return [Suite suiteWithStmts:stmts];
}

@end
