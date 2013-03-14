//
//  LAHInterpreter.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 3/8/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHInterpreter.h"
#import "LAHParser.h"
#import "LAHToken.h"
#import "LAHStmt.h"

@implementation LAHInterpreter
+ (void)interpretFile:(NSString *)path intoDictionary:(NSMutableDictionary *)dictionary{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSError *fileError = nil;
    NSString *string = [NSString stringWithContentsOfFile:path
                                                 encoding:NSASCIIStringEncoding
                                                    error:&fileError];
    NSAssert(fileError == nil, @"LAHInterpreter can't read file at '%@'.%@", path, fileError.userInfo);
    
    NSArray *tokens = [LAHToken tokenizeString:string];
    LAHParser *parser = [[LAHParser alloc] initWithTokens:tokens];
    LAHStmtSuite *suite = [parser parse];
    LAHFrame *frame = [[LAHFrame alloc] initWithDictionary:dictionary];
    [suite evaluate:frame];
    [frame doGain];
    
    [parser release]; [frame release];
    [pool release];
}
@end
