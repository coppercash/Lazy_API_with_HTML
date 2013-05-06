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

@interface LAHString ()
@property(nonatomic, copy)NSString *string;
@end

@implementation LAHString
@synthesize string = _string, value = _value;
@synthesize re = _re;
#pragma mark - Life Cycle

- (void)dealloc{
    self.string = nil;
    self.value = nil;
    self.re = nil;
    
    [super dealloc];
}

#pragma mark - LAHFetcher
- (void)fetchValue:(NSString *)value{
#ifdef LAH_RULES_DEBUG
    [LAHNote quickNote:@"%@\tfetching \"%@\"", self.des, value];
#endif
    self.string = value;
    [(LAHModel *)_father recieve:self];
}

#pragma mark - States
- (void)refresh{
    self.string = nil;
    [super refresh];
}

- (void)saveStateForKey:(id)key{
    //Do nothing.
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

