//
//  LAHFetcher.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/21/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHString.h"
#import "LAHTag.h"
#import "LAHPage.h"
#import "LAHNote.h"

#define kFather (LAHModel *)_father

@interface LAHString ()
@property(nonatomic, copy)NSString *string;
@end

@implementation LAHString
@synthesize string = _string, staticString = _staticString;
@synthesize re = _re;
#pragma mark - Life Cycle

- (void)dealloc{
    self.string = nil;
    self.staticString = nil;
    self.re = nil;
    
    [super dealloc];
}

#pragma mark - Copy
- (id)copyVia:(NSMutableDictionary *)table{
    LAHString *copy = [super copyVia:table];
    
    copy.staticString = _staticString;
    copy.re = _re;
    
    return copy;
}


#pragma mark - LAHFetcher
- (void)fetchValue:(NSString *)value{
    LAHNoteQuick(@"%@\tfetching \"%@\"", self.desc, value);
    
    self.string = value;
    [kFather recieve:self];
}

- (void)fetchStaticString{
    if (!_staticString) return;
    [self fetchValue:_staticString];
}

#pragma mark - States
- (void)refresh{
    self.string = nil;
    [super refresh];
}

- (void)saveStateForKey:(id)key{
    //Do nothing.
    LAHNoteQuick(@"%@\tsave %p", self.desc, self.data);
}

- (void)restoreStateForKey:(id)key{
    //Do nothing.
}

#pragma mark - Data
- (id)data{
    return _string;
}

#pragma mark - Log
- (NSString *)tagNameInfo{
    return @"str";
}

- (NSString *)attributesInfo{
    NSMutableString *info = [NSMutableString stringWithString:[super attributesInfo]];
    if (_re) [info appendFormat:@"re=\"%@\"", _re];
    return info;
}

@end

