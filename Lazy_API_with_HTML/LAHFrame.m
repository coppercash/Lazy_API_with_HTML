//
//  LAHFrame.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 5/2/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHFrame.h"
#import "LAHNode.h"
#import "LAHStmt.h"

@implementation LAHFrame
@synthesize toRefer = _toRefer, references = _references;
@synthesize father = _father;

#pragma mark - Class Basic
- (id)initWithDictionary:(NSMutableDictionary *)container{
    self = [super init];
    if (self) {
        self.references = container;
    }
    return self;
}

- (NSMutableDictionary *)references{
    if (!_references) {
        _references = [[NSMutableDictionary alloc] init];
    }
    
    return _references;
}

- (NSMutableArray *)toRefer{
    
    if (!_toRefer) {
        
        NSMutableArray *toRefer = _father.toRefer;
        if (toRefer) {
            
            _toRefer = [_father.toRefer retain];
            
        }else{
            
            _toRefer = [[NSMutableArray alloc] init];
            
        }
    }
    
    return _toRefer;
}

- (void)dealloc{
    self.references = nil;
    self.toRefer = nil;
    self.father = nil;
    [super dealloc];
}

#pragma mark - Reference
- (void)referObject:(LAHNode *)entity toKey:(NSString *)key{
    if ( !entity ) {
        NSString *message = [NSString stringWithFormat:@"Can't refer '%@' to key '%@'", entity, key];
        [self error:message];
    }
    
    LAHNode *unexpect = _references[key];
    if (unexpect) {
        NSString *message = [NSString stringWithFormat:@"Entity '%@' can't be refered to key '%@', because of entity '%@' using the same key.", entity, key, unexpect];
        [self error:message];
    }
    
    [self.references setObject:entity forKey:key];
}

- (id)objectForKey:(NSString *)key{
    
    id object = [self.references objectForKey:key];
    
    if (!object) {
        object = [_father objectForKey:key];
    }
    
    if (!object) {
        NSString *message = [NSString stringWithFormat:@"Can' derefer entity for key: %@", key];
        [self error:message];
    }
    
    return object;
}

#pragma mark - Error
- (void)error:(NSString *)message{
    @throw [NSException exceptionWithName:@"LinkError" reason:message userInfo:nil];
}

- (void)object:(NSString *)object expect:(NSString *)expect butFind:(NSString *)find{
    NSString *message = [NSString stringWithFormat:@"%@ expect %@, but find %@.", object, expect, find];
    [self error:message];
}

- (BOOL)object:(NSString *)object accept:(NSArray *)types find:(NSObject *)find strict:(BOOL)strict{
    BOOL isAcceptive = NO;
    NSMutableString *message = [NSMutableString stringWithString:@""];
    for (Class class in types) {
        if (strict) {
            isAcceptive |= [find isMemberOfClass:class];
        }else{
            isAcceptive |= [find isKindOfClass:class];
        }
        
        [message appendFormat:@"%@%@", ([message isEqualToString:@""] ? @"" : @" / "), NSStringFromClass(class)];
        
    }
    if (!isAcceptive) {
        if ([message isEqualToString:@""]) {
            message = [NSMutableString stringWithString:@"none"];
        }
        
        [self object:object expect:message butFind:NSStringFromClass(find.class)];
    }
    return YES;
}

- (BOOL)object:(NSString *)object accept:(NSArray *)types find:(NSObject *)find{
    return [self object:object accept:types find:find strict:NO];
}

- (void)attribute:(NSString *)attr ofEntity:(LAHNode *)entity expect:(NSArray *)types find:(LAHStmtValue *)find{
    NSString *message = [NSString stringWithFormat:@"Attribute '%@' of entity '%@'", attr, [entity class]];
    [self object:message accept:types find:find strict:YES];
}

@end

