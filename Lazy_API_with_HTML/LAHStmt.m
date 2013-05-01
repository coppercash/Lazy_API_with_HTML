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
        
    return object;
}

#pragma mark - Error
- (void)error:(NSString *)message{
    @throw [NSException exceptionWithName:@"LinkError" reason:message userInfo:nil];
}

- (void)attribute:(NSString *)attr ofEntity:(LAHNode *)entity expect:(NSString *)expect butFind:(LAHStmtValue *)find{
   
    NSString *message = [NSString stringWithFormat:@"Attribute '%@' of entity '%@' expect type '%@', but find '%@'.",
                         attr,
                         NSStringFromClass(entity.class),
                         expect,
                         NSStringFromClass(find.class)
                         ];
    [self error:message];

}

- (void)attribute:(NSString *)attr ofEntity:(LAHNode *)entity expect:(Class)expect find:(LAHStmtValue *)find{
    
    if ( ![find isMemberOfClass:expect] ) {
        [self attribute:attr ofEntity:entity expect:NSStringFromClass(expect) butFind:find];
    }

}

@end

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
        
        [frame attribute:name ofEntity:entity expect:[LAHStmtRef class] find:value];
        
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
        [frame attribute:name ofEntity:entity expect:[LAHStmtValue class] find:value];
        
        NSString *key = [value evaluate:frame];
        model.key = key;
        
        return YES;
    
    } else if ( [name isEqualToString:LAHParaRange] ) {
        
        LAHStmtMultiple *multiple = (LAHStmtMultiple *)attr.value;
        [frame attribute:name ofEntity:entity expect:[LAHStmtMultiple class] find:multiple];

        NSArray *range = [[NSArray alloc] initWithArray:[multiple evaluate:frame]];
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
        [frame attribute:name ofEntity:entity expect:[LAHStmtValue class] find:value];

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
        [frame attribute:name ofEntity:entity expect:[LAHStmtRef class] find:ref];
        
        LAHPage *page = [ref evaluate:frame];
        ope.page = page;
        
        return YES;
    } else if ([name isEqualToString:LAHParaModel]) {
        
        LAHStmtRef *ref = (LAHStmtRef *)attr.value;
        [frame attribute:name ofEntity:entity expect:[LAHStmtRef class] find:ref];
        
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
        
        [frame attribute:name ofEntity:entity expect:[LAHStmtMultiple class] find:value];
        
        NSArray *indexes = [[NSArray alloc] initWithArray:[value evaluate:frame]];
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
            
            NSString *message = [NSString stringWithFormat:@"%@ / %@",
                                 NSStringFromClass([LAHStmtValue class]),
                                 NSStringFromClass([LAHStmtMultiple class])];
            [frame attribute:name ofEntity:entity expect:message butFind:value];
            
        }
                
        return YES;

    }  else if ( [name isEqualToString:LAHParaIsDemocratic] ) {     //<div _isDemo="YES">
        
        [frame attribute:name ofEntity:entity expect:[LAHStmtValue class] find:value];
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
        if ( ![self add:attrStmt.value to:attribute frame:frame] ) {
            
            NSString *message = [NSString stringWithFormat:@"%@ / %@ / %@",
                                 NSStringFromClass([LAHStmtValue class]),
                                 NSStringFromClass([LAHStmtRef class]),
                                 NSStringFromClass([LAHStmtMultiple class])];
            [frame attribute:name ofEntity:entity expect:message butFind:attrStmt.value];
        
        } 
        
        return YES;
    
    }
    
    return NO;
}

- (BOOL)add:(LAHStmtValue *)value to:(LAHAttribute *)attribute frame:(LAHFrame *)frame{
    
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
        [frame attribute:name ofEntity:entity expect:[LAHStmtValue class] find:value];
        
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
@end
