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
#import "LAHFetcher.h"
#import "LAHOperation.h"
#import "LAHRecognizer.h"
#import "LAHDownloader.h"

@implementation LAHFrame
- (id)initWithDictionary:(NSMutableDictionary *)container{
    self = [super init];
    if (self) {
        self.generates = container;
        [self.gains = [[NSMutableSet alloc] init] release];
    }
    return self;
}

- (void)assert:(BOOL)condition error:(NSString *)message{
    if (condition) [self error:message];
}

- (void)error:(NSString *)message{
    [NSException raise:message format:nil];
}

- (void)registerGenerate:(LAHNode *)entity withKey:(NSString *)key{
    [_generates setObject:entity forKey:key];
}

- (void)doGain{
    for (LAHStmtGain *g in _gains) {
        LAHNode *value = [_generates objectForKey:quotedString(g.name)];
        //[self assert:value != nil error:@"Can't find gain named:"];
        if (value == nil) continue;
        
        LAHNode *target = g.target;
        SEL method = g.method;
        if (method == nil) method = [self methodWithTarget:target value:value];
        
        [target performSelector:method withObject:value];
    }
}

- (SEL)methodWithTarget:(LAHNode *)target value:(LAHNode *)value{
    if ([target isKindOfClass:[LAHRecognizer class]]) {
        if ([value isKindOfClass:[LAHFetcher class]]) {
            return @selector(addFetcher:);
        }else if ([value isKindOfClass:[LAHDownloader class]]) {
            return @selector(addDownloader:);
        }
        return @selector(addChild:);
    } else if ([target isKindOfClass:[LAHConstruct class]]){
        if ([value isKindOfClass:[LAHRecognizer class]]) {
            return @selector(addIdentifier:);
        }
    } else if ([target isKindOfClass:[LAHDownloader class]]){
        if ([value isKindOfClass:[LAHFetcher class]]) {
            return @selector(addFetcher:);
        }
        return @selector(addChild:);
    }
    return nil;
}

- (void)dealloc{
    self.generates = nil;
    self.gains = nil;
    [super dealloc];
}

@end

@implementation LAHStmt
- (id)evaluate:(LAHFrame *)frame{
    return nil;
}
@end

@implementation LAHStmtSuite
- (id)evaluate:(LAHFrame *)frame{
    NSMutableArray *collector = [NSMutableArray arrayWithCapacity:_statements.count];
    for (LAHStmt *s in _statements) {
        [collector addObject:[s evaluate:frame]];
    }
    return collector;
}

- (void)dealloc{
    self.statements = nil;
    [super dealloc];
}
@end

@implementation LAHStmtEntity
- (void)generate:(id)object inFrame:(LAHFrame *)frame{
    NSString *generate = quotedString(self.generate);
    if (generate) {
        [frame registerGenerate:object withKey:generate];
    }
}

- (void)propertiesOfObject:(LAHNode *)object inFrame:(LAHFrame *)frame{}

- (void)childrenOfObject:(LAHNode *)object inFrame:(LAHFrame *)frame{
    for (LAHStmt *s in self.children) {
        if ([s isKindOfClass:[LAHStmtEntity class]]) {
            LAHNode *con = [s evaluate:frame];
            [frame assert:![con isKindOfClass:[LAHNode class]] error:@"LAHNode can't accept child"];
            [object addChild:con];
        }else if ([s isKindOfClass:[LAHStmtGain class]]) {
            LAHStmtGain *gain  = (LAHStmtGain *)s;
            [gain evaluate:frame target:object method:nil];
        }
    }
}

- (void)dealloc{
    self.generate = nil;
    self.properties = nil;
    self.children = nil;
    [super dealloc];
}

@end

@implementation LAHStmtConstruct
- (void)propertiesOfObject:(LAHConstruct *)object inFrame:(LAHFrame *)frame{
    for (LAHStmtProperty *p in self.properties) {
        NSString *pN = p.propertyName;  //property name
        id pV = [p evaluate:frame]; //property value
        
        if ([pN isEqualToString:LAHParaKey]) {
            [frame assert:![pV isKindOfClass:[NSString class]]
                    error:@"LAHConstruct expects String as KEY."];
            object.key = pV;
        } else if ([pN isEqualToString:LAHParaId]) {
            if ([pV isKindOfClass:[NSSet class]]) {
                object.identifiers = [((LAHStmtSet *)p.value) evaluate:frame gainTarget:object];
            } else if ([pV isKindOfClass:[LAHStmtGain class]]) {
                LAHStmtGain *gain = (LAHStmtGain *)pV;
                [gain evaluate:frame target:object method:@selector(addIdentifier:)];
            } else {
                [frame error:@"LAHConstruct expects Tuple/Gain as IDENTIFIERS."];
            }
        }else{
            [frame error:@"LAHConstruct can't accept parameter."];
        }
    }
}

- (void)childrenOfObject:(LAHConstruct *)object inFrame:(LAHFrame *)frame{
    for (LAHStmt *s in self.children) {
        if ([s isKindOfClass:[LAHStmtEntity class]]) {
            LAHConstruct *con = [s evaluate:frame];
            [frame assert:![con isKindOfClass:[LAHConstruct class]] error:@"LAHConstruct can't accept child"];
            [object addChild:con];
        }else if ([s isKindOfClass:[LAHStmtGain class]]) {
            LAHStmtGain *gain  = (LAHStmtGain *)s;
            [gain evaluate:frame target:object method:@selector(addChild:)];
        }
    }
}

@end

@implementation LAHStmtArray
- (id)evaluate:(LAHFrame *)frame{
    LAHArray *array = [[LAHArray alloc] init];
    [self generate:array inFrame:frame];
    [self propertiesOfObject:array inFrame:frame];
    [self childrenOfObject:array inFrame:frame];
    return [array autorelease];
}
@end

@implementation LAHStmtDictionary
- (id)evaluate:(LAHFrame *)frame{
    LAHDictionary *dictionary = [[LAHDictionary alloc] init];
    [self generate:dictionary inFrame:frame];
    [self propertiesOfObject:dictionary inFrame:frame];
    [self childrenOfObject:dictionary inFrame:frame];
    return [dictionary autorelease];
}
@end

@implementation LAHStmtFetcher
- (id)evaluate:(LAHFrame *)frame{
    LAHFetcher *fetcher = [[LAHFetcher alloc] init];
    [self generate:fetcher inFrame:frame];
    [self propertiesOfObject:fetcher inFrame:frame];
    return [fetcher autorelease];
}

- (void)propertiesOfObject:(LAHConstruct *)object inFrame:(LAHFrame *)frame{
    NSUInteger index = 0;
    LAHFetcher *fetcher = (LAHFetcher *)object;
    for (LAHStmtProperty *p in self.properties) {
        NSString *pN = p.propertyName;  //property name
        id pV = [p evaluate:frame]; //property value
        
        if ([pN isEqualToString:LAHParaDefault]) {
            switch (index) {
                case 0:
                    fetcher.symbol = pV;
                    break;
                default:
                    break;
            }
        
        } else if ([pN isEqualToString:LAHParaSym]) {
            [frame assert:![pV isKindOfClass:[NSString class]]
                    error:@"LAHConstruct expects String as SYMBOL."];
            fetcher.symbol = pV;
        
        } else if ([pN isEqualToString:LAHParaKey]) {
            [frame assert:![pV isKindOfClass:[NSString class]]
                    error:@"LAHConstruct expects String as KEY."];
            fetcher.key = pV;
        
        } else if ([pN isEqualToString:LAHParaId]) {
            [frame assert:![pV isKindOfClass:[NSArray class]]
                    error:@"LAHConstruct expects Tuple as identifiers."];
            fetcher.identifiers = pV;
        
        }else{
            [frame error:@"LAHConstruct can't accept parameter."];
        }
        index ++;
    }
}

@end

@implementation LAHStmtOperation
- (id)evaluate:(LAHFrame *)frame{
    LAHOperation *ope = [[LAHOperation alloc] init];
    [self generate:ope inFrame:frame];
    [self propertiesOfObject:ope inFrame:frame];
    [self childrenOfObject:ope inFrame:frame];
    
    return [ope autorelease];
}

- (void)propertiesOfObject:(LAHConstruct *)object inFrame:(LAHFrame *)frame{
    NSUInteger index = 0;
    LAHOperation *ope = (LAHOperation *)object;
    for (LAHStmtProperty *p in self.properties) {
        NSString *pN = p.propertyName;  //property name
        
        if ([pN isEqualToString:LAHParaDefault]) {
            switch (index) {
                case 0:
                    [(LAHStmtGain *)p.value evaluate:frame target:ope method:@selector(setConstruct:)];
                    break;
                case 1:
                    ope.link = [p.value evaluate:frame];
                    break;
                default:
                    break;
            }
        } else if ([pN isEqualToString:LAHParaRoot]) {
            [(LAHStmtGain *)p.value evaluate:frame target:ope method:@selector(setConstruct:)];
        } else if ([pN isEqualToString:LAHParaPath]) {
            ope.link = [p.value evaluate:frame];
        } else {
            [frame error:@"LAHOperation can' accept PROPERTY"];
        }
        index ++;
    }
}

@end

@implementation LAHStmtRecgnizer
- (id)evaluate:(LAHFrame *)frame{
    LAHRecognizer *recognizer = [[LAHRecognizer alloc] init];
    [self generate:recognizer inFrame:frame];
    [self propertiesOfObject:recognizer inFrame:frame];
    [self childrenOfObject:recognizer inFrame:frame];
    return [recognizer autorelease];
}

- (void)propertiesOfObject:(LAHConstruct *)object inFrame:(LAHFrame *)frame{
    NSUInteger index = 0;
    LAHRecognizer *rec = (LAHRecognizer *)object;

    void (^addAsAttributes)(id, NSString *) =  ^(id value, NSString *key){
        if ([value isKindOfClass:[NSSet class]]) {
            [rec addAttributes:value withKey:key];
        } else if ([value isKindOfClass:[NSString class]]) {
            NSMutableSet *set = [NSMutableSet setWithObject:value];
            [rec addAttributes:set withKey:key];
        } else {
            [frame error:@"LAHRecognizer expects set/string as ATTIBUTES"];
        }
    };
    BOOL (^boolValue)(NSString *) = ^(NSString *value){
        if ([value isEqualToString:@"YES"]) {
            return YES;
        }else if ([value isEqualToString:@"NO"]){
            return NO;
        }else{
            [frame error:@"BOOL must be YES or NO."];
        }
        return NO;
    };
    
    for (LAHStmtProperty *p in self.properties) {
        NSString *pN = p.propertyName;  //property name
        id pV = [p evaluate:frame]; //property value
        
        if ([pN isEqualToString:LAHParaDefault]) {
            switch (index) {
                case 0:
                    addAsAttributes(pV, LAHParaTag);
                    break;
                case 1:
                    addAsAttributes(pV, LAHParaClass);
                    break;
                default:
                    break;
            }
        } else if ([pN isEqualToString:LAHParaRange]) {
            [frame assert:![pV isKindOfClass:[NSArray class]] error:@"LAHRecognizer expects list as RANGE."];
            NSArray *array = (NSArray *)pV;
            [frame assert:(array.count != 2) error:@"A Range should have too components"];
            NSString *locStr = [pV objectAtIndex:0];
            NSString *lenStr = [pV objectAtIndex:1];
            rec.range = NSMakeRange(locStr.integerValue, lenStr.integerValue);
        
        } else if ([pN isEqualToString:LAHParaIndex]) {
            [frame assert:![pV isKindOfClass:[NSString class]] error:@"LAHRecognizer expects integer as INDEX."];
            NSUInteger index = [(NSString *)pV integerValue];
            rec.index = index;
            
        } else if ([pN isEqualToString:LAHParaIsText]) {
            [frame assert:![pV isKindOfClass:[NSString class]] error:@"LAHRecognizer expects BOOL as isText."];
            rec.isTextNode = boolValue(pV);
            
        } else if ([pN isEqualToString:LAHParaIsDemocratic]) {
            [frame assert:![pV isKindOfClass:[NSString class]] error:@"LAHRecognizer expects BOOL as isDemocratic."];
            rec.isDemocratic = boolValue(pV);
            
        }
        else {
            addAsAttributes(pV, pN);
        }
        
        index ++;
    }
}

- (void)childrenOfObject:(LAHNode *)object inFrame:(LAHFrame *)frame{
    LAHRecognizer *recgonizer = (LAHRecognizer *)object;
    for (LAHStmt *s in self.children) { //LAHStmtRecognizer, LAHStmtDownloader, LAHStmtGain
        if ([s isKindOfClass:[LAHStmtRecgnizer class]]) {
            LAHRecognizer *rec = [s evaluate:frame];
            [frame assert:![rec isKindOfClass:[LAHRecognizer class]]
                    error:@"LAHRecognizer can't accept child"];
            [recgonizer addChild:rec];
        }else if ([s isKindOfClass:[LAHStmtDownloader class]]) {
            LAHDownloader *dow = [s evaluate:frame];
            [frame assert:![dow isKindOfClass:[LAHDownloader class]]
                    error:@"LAHRecognizer can't accept downloader"];
            [recgonizer addDownloader:dow];
        }else if ([s isKindOfClass:[LAHStmtGain class]]) {
            LAHStmtGain *gain  = (LAHStmtGain *)s;
            [gain evaluate:frame target:object method:nil];
        }
    }
}

@end

@implementation LAHStmtDownloader
- (id)evaluate:(LAHFrame *)frame{
    LAHDownloader *downloader = [[LAHDownloader alloc] init];
    [self generate:downloader inFrame:frame];
    [self propertiesOfObject:downloader inFrame:frame];
    [self childrenOfObject:downloader inFrame:frame];
    return [downloader autorelease];
}


- (void)propertiesOfObject:(LAHConstruct *)object inFrame:(LAHFrame *)frame{
    NSUInteger index = 0;
    LAHDownloader *dow = (LAHDownloader *)object;
    for (LAHStmtProperty *p in self.properties) {
        NSString *pN = p.propertyName;  //property name
        id pV = [p evaluate:frame]; //property value
        
        if ([pN isEqualToString:LAHParaDefault]) {
            switch (index) {
                case 0:
                    dow.symbol = pV;
                    break;
                default:
                    break;
            }
        } else if ([pN isEqualToString:LAHParaSym]) {
            dow.symbol = pV;
        } else {
            [frame error:@"LAHDownloader can' accept PROPERTY"];
        }
        index ++;
    }
}

@end

@implementation LAHStmtGain
- (id)evaluate:(LAHFrame *)frame{
    return self;
}

- (id)evaluate:(LAHFrame *)frame target:(id)target method:(SEL)method{
    self.target = target;
    self.method = method;
    [frame.gains addObject:self];
    return nil;
}

- (void)dealloc{
    self.name = nil;
    [super dealloc];
}
@end

@implementation LAHStmtProperty
- (id)evaluate:(LAHFrame *)frame{
    return [_value evaluate:frame];
}

- (NSString *)propertyName{
    NSString *name = self.name;
    if ([name characterAtIndex:0] == '"' && [name characterAtIndex:name.length - 1] == '"') {
        return quotedString(name);
    }
    return name;
}

- (void)dealloc{
    self.name = nil;
    self.value = nil;
    [super dealloc];
}
@end

@implementation LAHStmtValue
- (id)evaluate:(LAHFrame *)frame{
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
}

- (void)dealloc{
    self.string = nil;
    [super dealloc];
}
@end


@implementation LAHStmtTuple
- (id)evaluate:(LAHFrame *)frame gainTarget:(LAHNode *)target{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (LAHStmtValue *v in _values) {
        if ([v isKindOfClass:[LAHStmtGain class]]) {
            LAHStmtGain *gain = (LAHStmtGain *)v;
            [gain evaluate:frame target:target method:nil];
        }else{
            [array addObject:[v evaluate:frame]];
        }
    }
    
    return [array autorelease];
}

- (id)evaluate:(LAHFrame *)frame{
    NSMutableArray *set = [[NSMutableArray alloc] init];
    for (LAHStmtValue *v in _values) {
        if (![v isKindOfClass:[LAHStmtGain class]]) {
            [set addObject:[v evaluate:frame]];
        }
    }
    
    return [set autorelease];
}

- (void)dealloc{
    self.values = nil;
    [super dealloc];
}
@end

@implementation LAHStmtSet
- (id)evaluate:(LAHFrame *)frame gainTarget:(LAHNode *)target{
    NSMutableSet *set = [[NSMutableSet alloc] init];
    for (LAHStmtValue *v in _values) {
        if ([v isKindOfClass:[LAHStmtGain class]]) {
            LAHStmtGain *gain = (LAHStmtGain *)v;
            [gain evaluate:frame target:target method:nil];
        }else{
            [set addObject:[v evaluate:frame]];
        }
    }
    
    return [set autorelease];
}

- (id)evaluate:(LAHFrame *)frame{
    NSMutableSet *set = [[NSMutableSet alloc] init];
    for (LAHStmtValue *v in _values) {
        if (![v isKindOfClass:[LAHStmtGain class]]) {
            [set addObject:[v evaluate:frame]];
        }
    }
    
    return [set autorelease];
}

- (void)dealloc{
    self.values = nil;
    [super dealloc];
}
@end

NSString *quotedString(NSString *string){
    NSString *str = [string substringWithRange:NSMakeRange(1, string.length - 2)];
    return str;
}