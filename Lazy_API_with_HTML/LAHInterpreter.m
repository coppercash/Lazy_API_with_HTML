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
#import "LAHFrame.h"

@interface LAHInterpreter ()
+ (void)interpretIntoDictionary:(NSMutableDictionary *)dictionary fromFirstFile:(NSString *)firstFile otherFiles:(va_list)otherFiles;
@end

@implementation LAHInterpreter
+ (void)interpretFile:(NSString *)path intoDictionary:(NSMutableDictionary *)dictionary{
    NSError *fileError = nil;
    NSString *string = [NSString stringWithContentsOfFile:path
                                                 encoding:NSASCIIStringEncoding
                                                    error:&fileError];
    NSAssert(fileError == nil, @"LAHInterpreter can't read file at '%@'.%@", path, fileError.userInfo);
    
    [self interpretString:string intoDictionary:dictionary];
}

+ (void)interpretIntoDictionary:(NSMutableDictionary *)dictionary fromFirstFile:(NSString *)firstFile otherFiles:(va_list)otherFiles{

    NSError *fileError = nil;
    NSString *string = [NSString stringWithContentsOfFile:firstFile encoding:NSASCIIStringEncoding error:&fileError];
    NSAssert(fileError == nil, @"LAHInterpreter can't read file at '%@'.%@", firstFile, fileError.userInfo);
    
    NSMutableString *collector = [[NSMutableString alloc] initWithString:string];
    
    NSString *file = nil;
    while ((file = va_arg(otherFiles, NSString*)) != nil) {
        string = [NSString stringWithContentsOfFile:file encoding:NSASCIIStringEncoding error:&fileError];
        [collector appendString:string];
        NSAssert(fileError == nil, @"LAHInterpreter can't read file at '%@'.%@", file, fileError.userInfo);
    }
    
    [self interpretString:collector intoDictionary:dictionary];
    
    [collector release];

}

+ (void)interpretIntoDictionary:(NSMutableDictionary *)dictionary fromFiles:(NSString *)firstFile, ... NS_REQUIRES_NIL_TERMINATION {
    va_list files; va_start(files, firstFile);
    [LAHInterpreter interpretIntoDictionary:dictionary fromFirstFile:firstFile otherFiles:files];
    va_end(files);
}

+ (void)interpretString:(NSString *)string intoDictionary:(NSMutableDictionary *)dictionary{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSArray *tokens = [LAHToken tokenizeString:string];
    LAHParser *parser = [[LAHParser alloc] initWithTokens:tokens];
    LAHStmtSuite *suite = [parser parseCommand];
    LAHFrame *frame = [[LAHFrame alloc] initWithDictionary:dictionary];
    [suite evaluate:frame];
    
    [parser release]; [frame release];
    [pool release];
}


//+ (void)interpretString:(NSString *)string intoDictionary:(NSMutableDictionary *)dictionary{
//    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//
//    @try {
//        NSArray *tokens = [LAHToken tokenizeString:string];
//        LAHParser *parser = [[LAHParser alloc] initWithTokens:tokens];
//        LAHStmtSuite *suite = [parser parseCommand];
//        LAHFrame *frame = [[LAHFrame alloc] initWithDictionary:dictionary];
//        [suite evaluate:frame];
//
//        [parser release]; [frame release];
//    }
//    @catch (NSException *exception) {
//        NSAssert(exception == nil, @"%@", exception);
//    }
//    
//    [pool release];
//}

+ (LAHNode *)interpretFile:(NSString *)path forKey:(NSString *)key{
    NSMutableDictionary *container = [[NSMutableDictionary alloc] init];
    
    [self interpretFile:path intoDictionary:container];
    LAHNode *ret = container[key];
    [ret retain];
    [ret autorelease];
    
    [container release];
    
    return ret;
}


@end
