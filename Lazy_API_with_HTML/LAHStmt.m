//
//  LAHStatement.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 3/9/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHStmt.h"
#import "LAHParser.h"

#import "LAHArray.h"
#import "LAHDictionary.h"
#import "LAHString.h"
#import "LAHOperation.h"
#import "LAHPage.h"
#import "LAHTag.h"
#import "LAHAttribute.h"

#import "LAHToken.h"
#import "LAHFrame.h"

#pragma mark - Basic
@implementation LAHStmt
- (id)evaluate:(LAHFrame *)frame{
    return nil;
}
@end

@implementation LAHStmtSuite
- (id)evaluate:(LAHFrame *)frame{
    NSMutableArray *collector = [NSMutableArray arrayWithCapacity:_statements.count];
    for (LAHStmt *s in _statements) {
        
        LAHFrame *subFrame = [[LAHFrame alloc] init];
        subFrame.father = frame;
        
        [collector addObject:[s evaluate:subFrame]];
        
        [frame.references addEntriesFromDictionary:subFrame.references];
        [subFrame release];
        
    }
    return collector;
}

- (NSMutableArray *)statements{
    if (!_statements) {
        _statements = [[NSMutableArray alloc] init];
    }
    return _statements;
}

- (void)dealloc{
    self.statements = nil;
    [super dealloc];
}
@end

#pragma mark - Entities
@implementation LAHStmtEntity

- (id)evaluate:(LAHFrame *)frame{
    LAHNode *entity = [self entity];
    
    for (LAHStmtAttribute *attr in _attributes) {
        [self attribute:attr of:entity inFrame:frame];
    }
    
    NSMutableArray *children = [[NSMutableArray alloc] initWithCapacity:_children.count];
    for (LAHStmt *childStmt in _children) {
        
        LAHNode *child = [childStmt evaluate:frame];
        [children addObject:child];
    
    }
    entity.children = children;
    
    return entity;
}

- (LAHNode *)entity{
    LAHNode * entity = [[LAHNode alloc] init];
    return [entity autorelease];
}

- (BOOL)attribute:(LAHStmtAttribute *)attr of:(LAHNode *)entity inFrame:(LAHFrame *)frame{
    NSString *name = attr.name;
    LAHStmtValue *value = attr.value;
    if ([name isEqualToString:LAHParaRef]) {
        
        [frame attribute:name ofEntity:entity expect:@[[LAHStmtRef class]] find:value];
        
        [frame.toRefer addObject:entity];
        
        [attr.value evaluate:frame];
        
        [frame.toRefer removeLastObject];
        
        return YES;
    }
    
    return NO;
}

- (NSMutableArray *)attributes{
    if (!_attributes) {
        _attributes = [[NSMutableArray alloc] init];
    }
    return _attributes;
}

- (NSMutableArray *)children{
    if (!_children) {
        _children = [[NSMutableArray alloc] init];
    }
    return _children;
}

- (void)dealloc{
    self.attributes = nil;
    self.children = nil;
    [super dealloc];
}

@end

@implementation LAHStmtModel

- (LAHNode *)entity{
    LAHModel *model = [[LAHModel alloc] init];
    return [model autorelease];
}

- (BOOL)attribute:(LAHStmtAttribute *)attr of:(LAHNode *)entity inFrame:(LAHFrame *)frame{
    if ([super attribute:attr of:entity inFrame:frame]) return YES;
    
    NSString *name = attr.name;
    LAHModel *model = (LAHModel *)entity;
    
    if ( [name isEqualToString:LAHParaKey] ) {
        
        LAHStmtValue *value = attr.value;
        [frame attribute:name ofEntity:entity expect:@[[LAHStmtValue class]] find:value];
        
        NSString *key = [value evaluate:frame];
        model.key = key;
        
        return YES;
    
    } else if ( [name isEqualToString:LAHParaRange] ) {
        
        LAHStmtMultiple *multiple = (LAHStmtMultiple *)attr.value;
        [frame attribute:name ofEntity:entity expect:@[[LAHStmtMultiple class]] find:multiple];

        NSArray *values = [multiple evaluate:frame];
        NSArray *range = [[NSArray alloc] initWithArray:[LAHStmtMultiple convertRange:values frame:frame]];
        model.range = range;
        [range release];
        
        return YES;
    }
    
    return NO;
}

@end

@implementation LAHStmtArray
- (LAHNode *)entity{
    LAHArray *array = [[LAHArray alloc] init];
    return [array autorelease];
}
@end

@implementation LAHStmtDictionary
- (LAHNode *)entity{
    LAHDictionary *dictionary = [[LAHDictionary alloc] init];
    return [dictionary autorelease];
}
@end

@implementation LAHStmtString
- (LAHNode *)entity{
    LAHString *string = [[LAHString alloc] init];
    return [string autorelease];
}

- (BOOL)attribute:(LAHStmtAttribute *)attr of:(LAHNode *)entity inFrame:(LAHFrame *)frame{
    if ([super attribute:attr of:entity inFrame:frame]) return YES;
    
    NSString *name = attr.name;
    LAHString *string  = (LAHString *)entity;
    
    if ([name isEqualToString:LAHParaRE]) {
        
        LAHStmtValue *value = attr.value;
        [frame attribute:name ofEntity:entity expect:@[[LAHStmtValue class]] find:value];

        NSString *re = [value evaluate:frame];
        string.re = re;
        
        return YES;
    }
    
    return NO;
}

@end

@implementation LAHStmtOperation
- (LAHNode *)entity{
    LAHOperation *operation = [[LAHOperation alloc] init];
    return [operation autorelease];
}

- (id)evaluate:(LAHFrame *)frame{
    LAHOperation *ope = (LAHOperation *)[self entity];
    
    for (LAHStmtAttribute *attr in self.attributes) {
        [self attribute:attr of:ope inFrame:frame];
    }
    

    for (LAHStmt *childStmt in self.children) {
        
        LAHNode *child = [childStmt evaluate:frame];
        
        if ( [child isMemberOfClass:[LAHPage class]] ) {
            
            ope.page = (LAHPage *)child;
        
        } else if ( [child isMemberOfClass:[LAHModel class]] ) {
            
            ope.model = (LAHModel *)child;
            
        }

    }
    
    return ope;
}

- (BOOL)attribute:(LAHStmtAttribute *)attr of:(LAHNode *)entity inFrame:(LAHFrame *)frame{
    if ([super attribute:attr of:entity inFrame:frame]) return YES;
    
    NSString *name = attr.name;
    LAHOperation *ope  = (LAHOperation *)entity;
    
    if ([name isEqualToString:LAHParaPage]) {
        
        LAHStmtRef *ref = (LAHStmtRef *)attr.value;
        [frame attribute:name ofEntity:entity expect:@[[LAHStmtRef class]] find:ref];
        
        LAHPage *page = [ref evaluate:frame];
        ope.page = page;
        
        return YES;
    } else if ([name isEqualToString:LAHParaModel]) {
        
        LAHStmtRef *ref = (LAHStmtRef *)attr.value;
        [frame attribute:name ofEntity:entity expect:@[[LAHStmtRef class]] find:ref];
        
        LAHModel *model = [ref evaluate:frame];
        ope.model = model;
        
        return YES;
    }
    
    return NO;
}

@end

@implementation LAHStmtTag
- (LAHNode *)entity{
    LAHTag *tag = [[LAHTag alloc] init];
    return [tag autorelease];
}

- (BOOL)attribute:(LAHStmtAttribute *)attrStmt of:(LAHNode *)entity inFrame:(LAHFrame *)frame{
    if ([super attribute:attrStmt of:entity inFrame:frame]) return YES;
    
    NSString *name = attrStmt.name;
    LAHStmtValue *value = attrStmt.value;
    LAHTag *tag  = (LAHTag *)entity;
    
    if ( [name isEqualToString:LAHParaIndexes] ) {              //<div _indexes=(0, 17)>
        
        [frame attribute:name ofEntity:entity expect:@[[LAHStmtMultiple class]] find:value];
        
        NSArray *values = [value evaluate:frame];
        NSArray *indexes = [[NSArray alloc] initWithArray:[LAHStmtMultiple convertRange:values frame:frame]];
        tag.indexes = indexes;
        [indexes release];
        
        return YES;
    
    } else if ( [name isEqualToString:LAHParaIndexOf] ) {       //<div _indexOf='ref'>
        
        if ([value isMemberOfClass:[LAHStmtRef class]]) {
            
            LAHNode *entity = [value evaluate:frame];
            
            
            if ( ![entity isKindOfClass:[LAHModel class]] ) {
                NSString *message = [NSString stringWithFormat:@"_indexOf of tag can only accept %@ reference, but find %@",
                                     NSStringFromClass([LAHModel class]),
                                     NSStringFromClass([entity class])];
                [frame error:message];
            }
            NSSet *indexOf = [[NSSet alloc] initWithObjects:entity, nil];
            tag.indexOf = indexOf;
            [indexOf release];
            
        } else if ([value isMemberOfClass:[LAHStmtMultiple class]]) {
            
            NSSet *indexOf = [[NSSet alloc] initWithArray:[value evaluate:frame]];
            tag.indexOf = indexOf;
            [indexOf release];

        } else {
            
            [frame attribute:name ofEntity:entity expect:@[[LAHStmtValue class], [LAHStmtMultiple class]] find:value];
            
        }
                
        return YES;

    }  else if ( [name isEqualToString:LAHParaIsDemocratic] ) {     //<div _isDemo="YES">
        
        [frame attribute:name ofEntity:entity expect:@[[LAHStmtValue class]] find:value];
        NSString *boolValue = [value evaluate:frame];
        if ([boolValue isEqualToString:LAHValYES]) {
            tag.isDemocratic = YES;
        }else if ([boolValue isEqualToString:LAHValNO]) {
            tag.isDemocratic = NO;
        }
        
        return YES;
        
    } else {
        
        LAHAttribute *attribute = [[LAHAttribute alloc] init];
        [tag.attributes addObject:attribute];
        [attribute release];
        
        
        //Attribute Name
        attribute.name = attrStmt.name;
        
        
        //Attribute method
        NSString *methodName = nil;
        if ( (methodName = attrStmt.methodName) ) {
            attribute.methodName = methodName;
            attribute.args = [attrStmt.args evaluate:frame];    //Type uncheck
        }

        
        //Attribute legal values and getters
        if ( ![self.class add:attrStmt.value to:attribute frame:frame] ) {
            
              [frame attribute:name ofEntity:entity expect:@[[LAHStmtValue class],
                                                             [LAHStmtRef class],
                                                             [LAHStmtMultiple class]]
                          find:attrStmt.value];
        
        } 
        
        return YES;
    
    }
    
    return NO;
}

+ (BOOL)add:(LAHStmtValue *)value to:(LAHAttribute *)attribute frame:(LAHFrame *)frame{
    
    if ([value isMemberOfClass:[LAHStmtValue class]]) {         //<div class="legalValue">
        
        NSString *string = [value evaluate:frame];
        NSSet *set = [[NSSet alloc] initWithObjects:string, nil];
        attribute.legalValues = set;
        [set release];

    } else if ([value isMemberOfClass:[LAHStmtRef class]]) {    //<div class='ref'>

        LAHNode *entity = [value evaluate:frame];
        if ( ![entity isKindOfClass:[LAHPage class]] && ![entity isKindOfClass:[LAHString class]] ) {
            NSString *message = [NSString stringWithFormat:@"Html attribute of tag can only accept %@ / %@ reference, but find %@",
                                 NSStringFromClass([LAHString class]),
                                 NSStringFromClass([LAHPage class]),
                                 NSStringFromClass([entity class])];
            [frame error:message];
        }
        NSSet *set = [[NSSet alloc] initWithObjects:entity, nil];
        attribute.getters = set;
        [set release];

    } else if ([value isMemberOfClass:[LAHStmtMultiple class]]) {   //<div class={"legalValue", 'ref'}>
        
        NSArray *values = [value evaluate:frame];
        NSMutableSet *legalValues = [[NSMutableSet alloc] init];
        NSMutableSet *getters = [[NSMutableSet alloc] init];
        for (id val in values) {
            
            if ([val isKindOfClass:[NSString class]]) {
                
                [legalValues addObject:val];
                
            } else if ([val isMemberOfClass:[LAHString class]] || [val isMemberOfClass:[LAHPage class]]) {
                
                [getters addObject:val];
                
            }
            
        }
        
        attribute.legalValues = legalValues;
        attribute.getters = getters;
        [legalValues release];
        [getters release];

        
    } else {
        
        return NO;
    
    }
    
    return YES;

}

@end

@implementation LAHStmtPage
- (LAHPage *)entity{
    LAHPage *page = [[LAHPage alloc] init];
    return [page autorelease];
}

- (BOOL)attribute:(LAHStmtAttribute *)attr of:(LAHNode *)entity inFrame:(LAHFrame *)frame{
    if ([super attribute:attr of:entity inFrame:frame]) return YES;
    
    NSString *name = attr.name;
    LAHPage *page  = (LAHPage *)entity;
    
    if ([name isEqualToString:LAHParaLink]) {
        
        LAHStmtValue *value = attr.value;
        [frame attribute:name ofEntity:entity expect:@[[LAHStmtValue class]] find:value];
        
        NSString *link = [value evaluate:frame];
        page.link = link;
        
        return YES;
    } 
    
    return NO;
}

@end

#pragma mark - Value
@implementation LAHStmtValue
@synthesize value = _value;

- (id)evaluate:(LAHFrame *)frame{
    if (!_value) {
        [frame error:@"Value of LAHStmtValue can not be 'nil'."];
    }
    return self.value;
    /*
     NSScanner* scan = [NSScanner scannerWithString:_string]; int val;
     if ([scan scanInt:&val] && [scan isAtEnd]) {
     return _string;
     }
     char ch = [_string characterAtIndex:0];
     switch (ch) {
     case '_':{
     return _string;
     }break;
     case '"':{
     return quotedString(_string);
     }break;
     default:
     break;
     }
     return nil;
     */
}

- (void)dealloc{
    self.value = nil;
    [super dealloc];
}

@end


@implementation LAHStmtRef
@dynamic name;
- (id)evaluate:(LAHFrame *)frame{
    LAHNode *entity = [frame objectForKey:self.name];
    
    if ( !entity ) {    //Can't get the entity
        
        NSMutableArray *entitiesQueue = frame.toRefer;
        if (entitiesQueue.count == 0) {
            
            NSString *message = [NSString stringWithFormat:@"Can not refer or get entity named '%@'", self.name];
            [frame error:message];
        
        } else {
            
            //Refer an entity
            entity = [entitiesQueue lastObject];
            [frame referObject:entity toKey:self.name];
        
        }
    }
    
    return entity;
}

- (NSString *)name{
    return _value;
}

- (void)setName:(NSString *)name{
    [_value release];
    _value = [name copy];
}

@end

@implementation LAHStmtAttribute
- (id)evaluate:(LAHFrame *)frame{
    return [_value evaluate:frame];
}

- (void)dealloc{
    self.name = nil;
    self.value = nil;
    [super dealloc];
}

@end


@implementation LAHStmtNumber
- (id)evaluate:(LAHFrame *)frame{
    if (!isByRegularExpression(_value, gNumberEX)) {
        NSString *message = [NSString stringWithFormat:@"%@ is not pure number.", _value];
        [frame error:message];
    }
    NSNumber *number = [NSNumber numberWithInteger:_value.integerValue];
    return number;
}
@end

@implementation LAHStmtMultiple
- (id)evaluate:(LAHFrame *)frame{
    
    NSMutableArray *collector = [NSMutableArray arrayWithCapacity:_values.count];
    for (LAHStmtValue *valueStmt in _values) {
        id value = [valueStmt evaluate:frame];
        [collector addObject:value];
    }
    
    return collector;
}

+ (NSArray *)convertRange:(NSArray *)range frame:(LAHFrame *)frame{
    if (!range || range.count == 0) return nil;
    
    NSInteger index = 0;
    NSRange cRange = NSMakeRange(0, 0);
    NSMutableArray *collector = [NSMutableArray arrayWithCapacity:range.count / 2];
    while (index < range.count) {
        NSNumber *locNum = range[index ++];
        [frame object:@"Range" accept:@[[NSNumber class]] find:locNum];
        NSUInteger loc = locNum.unsignedIntegerValue;

        if (index >= range.count) break;
        
        NSNumber *lenNum = range[index ++];
        [frame object:@"Range" accept:@[[NSNumber class]] find:lenNum];
        NSUInteger len = lenNum.unsignedIntegerValue;
        
        if (len == 0) continue;
        
        if (NSEqualRanges(cRange, NSMakeRange(0, 0))) {
            cRange.location = loc;
        } else {
            cRange.location = NSMaxRange(cRange) - 1 + loc;
        }
        cRange.length = len;
        NSValue *rangeValue = [NSValue valueWithRange:cRange];
        
        [collector addObject:rangeValue];
    }
    
    return collector;
}

@end
