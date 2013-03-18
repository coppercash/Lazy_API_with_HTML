//
//  LAHRecognizer.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHRecognizer.h"
#import "LAHConstruct.h"
#import "LAHFetcher.h"
#import "LAHDownloader.h"

@implementation LAHRecognizer
@synthesize attributes = _attributes, isTextNode = _isTextNode, rule = _rule, isDemocratic = _isDemocratic;
@synthesize range = _range;
@synthesize isIdentifier = _isIdentifier, numberOfMatched = _numberOfMatched, matchingElement = _matchingElement;
@synthesize fetchers = _fetchers, downloaders = _downloaders;

#pragma mark - Life Cycle
- (id)init{
    self = [super init];
    if (self) {
        self.isTextNode = NO;
        self.isIdentifier = NO;
        self.range = NSMakeRange(0, NSUIntegerMax);
        self.isDemocratic = NO;
    }
    return self;
}

- (id)initWithFirstFetcher:(LAHFetcher *)firstFetcher variadicFetchers:(va_list)fetchers{
    self = [self init];
    if (self) {
        NSMutableArray *collector = [[NSMutableArray alloc] initWithObjects:firstFetcher, nil];
        LAHFetcher *fetcher;
        while ((fetcher = va_arg(fetchers, LAHFetcher*)) != nil) {
            [collector addObject:fetcher];
        }
        [self.fetchers = [[NSArray alloc] initWithArray:collector] release];
        [collector release];
    }
    return self;
}

- (id)initWithFetchers:(LAHFetcher *)firstFetcher, ... NS_REQUIRES_NIL_TERMINATION{
    va_list fetchers; va_start(fetchers, firstFetcher);
    self = [self initWithFirstFetcher:firstFetcher variadicFetchers:fetchers];
    va_end(fetchers);
    return self;
}

- (id)initWithFirstChild:(LAHNode*)firstChild variadicChildren:(va_list)children{
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    if (self) {
        self.isTextNode = NO;
        self.isIdentifier = NO;
        self.range = NSMakeRange(0, NSUIntegerMax);
        self.isDemocratic = YES;
    }
    return self;
}

- (void)dealloc{
    self.attributes = nil;
    self.rule = nil;
    self.fetchers = nil;
    self.downloaders = nil;
 
    [super dealloc];
}

#pragma mark - Setter
- (void)setTagName:(NSString *)tagName{
    NSSet *tagNames = [[NSSet alloc] initWithObjects:tagName, nil];
    if (_attributes) {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:_attributes];
        [temp setObject:tagNames forKey:LAHParaTag];
        
        NSDictionary *newAttr = [[NSDictionary alloc] initWithDictionary:temp];

        self.attributes = newAttr;
        [temp release]; [newAttr release];
    }else{
        NSDictionary *newAttr = [[NSDictionary alloc] initWithObjectsAndKeys:tagNames, LAHParaTag, nil];
        
        self.attributes = newAttr;
        [newAttr release];
    }
    [tagNames release];
}

- (void)setText:(NSString *)text{
    NSSet *texts = [[NSSet alloc] initWithObjects:text, nil];
    if (_attributes) {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:_attributes];
        [temp setObject:texts forKey:LAHParaText];
        
        NSDictionary *newAttr = [[NSDictionary alloc] initWithDictionary:temp];
        
        self.attributes = newAttr;
        [temp release]; [newAttr release];
    }else{
        NSDictionary *newAttr = [[NSDictionary alloc] initWithObjectsAndKeys:texts, LAHParaText, nil];
        
        self.attributes = newAttr;
        [newAttr release];
    }
    [texts release];
}

- (void)setIdentifier:(NSUInteger)index{
    _range = NSMakeRange(index, 1);
}

- (void)setDownloaders:(NSArray *)downloaders{
    [_downloaders release];
    _downloaders = [downloaders retain];
    
    for (LAHDownloader *d in _downloaders) {
        d.father = self;
    }
}

#pragma mark - Getter
- (NSUInteger)numberInRange{
    NSRange wR = NSMakeRange(0, _numberOfMatched);  //whole range
    NSRange iR = NSIntersectionRange(wR, _range);   //intersection range
    return iR.length;
}

- (NSUInteger)identifier{
    return _range.location;
}

#pragma mark - Attributes
- (void)setKey:(NSString *)key firstValue:(NSString *)firstValue variadicValues:(va_list)values{
    NSMutableArray *collector = [[NSMutableArray alloc] initWithObjects:firstValue, nil];
    NSString *value = nil;
    while ((value = va_arg(values, NSString*)) != nil) {
        [collector addObject:value];
    }
    NSSet *set = [[NSSet alloc] initWithArray:collector];
    
    if (_attributes) {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:_attributes];
        [temp setObject:set forKey:key];
        
        NSDictionary *newAttr = [[NSDictionary alloc] initWithDictionary:temp];
        
        self.attributes = newAttr;
        [temp release]; [newAttr release];
    }else{
        NSDictionary *newAttr = [[NSDictionary alloc] initWithObjectsAndKeys:set, key, nil];
        self.attributes = newAttr;
        [newAttr release];
    }
    
    [collector release]; [set release];
}

- (void)setKey:(NSString *)key attributes:(NSString *)firstValue, ... NS_REQUIRES_NIL_TERMINATION{
    va_list values; va_start(values, firstValue);
    [self setKey:key firstValue:firstValue variadicValues:values];
    va_end(values);
}


#pragma mark - Recursive
- (BOOL)handleElement:(LAHEle)element{
    //Step 0, check matching.
    if (![self isElementMatched:element]) return NO;
    _matchingElement = element;
    
#ifdef LAH_RULES_DEBUG
    gRecLogDegree += 1;
#endif
    
    BOOL isChildrenPass = (_children == nil || _children.count == 0) ? YES : NO;
    //Step 1, recursion
    //Two iteration in this order, so that the fetcher's fetching sequence depends on the sequence in the HTML.
    for (LAHEle e in element.children) {
        for (LAHRecognizer *node in _children) {
            if (_isIdentifier) [node refreshState];
            isChildrenPass |= [node handleElement:e];
        }
    }

    if (_isDemocratic && !isChildrenPass) {
#ifdef LAH_RULES_DEBUG
        gRecLogDegree -= 1;
#endif
        return NO;
    }
    
    //Step 2, fetch linked properties.
    for (LAHFetcher *f in _fetchers) {
        [f fetchProperty:element];
    }

    //Step 3, download with the property.
    for (LAHDownloader *d in _downloaders) {
        [d download:element];
    }
    
    _matchingElement = nil;
#ifdef LAH_RULES_DEBUG
    gRecLogDegree -= 1;
#endif
    return YES;
}

- (BOOL)isElementMatched:(LAHEle)element{
#ifdef LAH_RULES_DEBUG
    NSMutableString *space = [NSMutableString string];
    for (int i = 0; i < gRecLogDegree; i ++) [space appendString:@"\t"];
    NSMutableString *info = [NSMutableString stringWithFormat:@"\n%@%@", space, self];
    if (_fetchers && _fetchers.count != 0) [info appendFormat:@"\tFetchers:%d", _fetchers.count];
    if (_downloaders && _downloaders.count != 0) [info appendFormat:@"\tDownloaders:%d", _downloaders.count];

    BOOL logVisible = NO;
    void (^logOut)(BOOL) = ^(BOOL condition){
        if (condition)
            printf("%s\n", [info cStringUsingEncoding:NSASCIIStringEncoding]);
    };
#endif
    for (NSString *key in _attributes) {
        NSSet *recVs = [_attributes objectForKey:key];    //recognizer values
        NSAssert([recVs isKindOfClass:[NSSet class]], @"LAHRecognizer: legal values should be a NSSet.");

        NSString *eleV = nil;   //element value
        if ([key isEqualToString:LAHParaTag]) {
            eleV = element.tagName;
        }else if ([key isEqualToString:LAHParaText]){
            eleV = element.text;
        }else{
            eleV = [element.attributes objectForKey:key];
        }
        
        BOOL isMatched = NO;
        if (eleV) { //matching value
            for (NSString *recV in recVs) {
                if ([recV isEqualToString:LAHValAll]) {
                    isMatched = YES;
                    break;
                }
                isMatched |= [recV isEqualToString:eleV];
            }
        }else {
            for (NSString *recV in recVs)  //matching value
                isMatched |= [recV isEqualToString:LAHValNone];
        }
        
        /*
        //Statement below has same logic with the above one.But in each step of loop, it do [value isEqualToString:gRWNone].So its performance is worse.
        value = value ? value : gRWNone;
        for (NSString *lV in lVs) {
            if ([lV isEqualToString:gRWNotNone] && ![value isEqualToString:gRWNone]) {
                isMatched = YES;
                break;
            }
            isMatched |= [lV isEqualToString:value];
        }*/
        
#ifdef LAH_RULES_DEBUG
        if (!logVisible) {
            logVisible = ([key isEqualToString:LAHParaTag] && isMatched);
        }
        
        NSMutableString *matchingSet = [NSMutableString string];
        for (NSString *matchingV in recVs) [matchingSet appendFormat:@"%@, ", matchingV];
        [info appendFormat:@"\n%@%@\tkey=%@\t{ %@}\t%@", space,
         isMatched ? @"PASS" : @"FAIL",
         key, matchingSet, eleV];
        
        logOut(!isMatched && logVisible);
#endif
        if (!isMatched) return NO;
    }
    
    
    BOOL isTextMatched = _isTextNode == element.isTextNode;
#ifdef LAH_RULES_DEBUG
    [info appendFormat:@"\n%@%@\trec %@\tele %@", space,
     isTextMatched ? @"PASS" : @"FAIL",
     _isTextNode ? @"isTextNode" : @"isNotTextNode",
     element.isTextNode ? @"isTextNode" : @"isNotTextNode"];
    
    logOut(!isTextMatched && logVisible);
#endif
    if (!isTextMatched) return NO;
    
    
    if (_rule != nil) {
        BOOL isRuled = _rule(element);
#ifdef LAH_RULES_DEBUG
        [info appendFormat:@"\n%@%@\ton Rule", space, isRuled ? @"PASS" : @"FAIL"];
        
        logOut(!isRuled && logVisible);
#endif
        if (!isRuled) return NO;
    }
    
    
    //range indicates range of elements matched by above rules,
    //so before using it, _numberOfMatched should increase.
    _numberOfMatched ++;
    BOOL isInRange = NSLocationInRange(_numberOfMatched - 1, _range);
#ifdef LAH_RULES_DEBUG
    [info appendFormat:@"\n%@%@\trange(%d, %d)(%d...%d)\t%d", space,
     isInRange ? @"PASS" : @"FAIL",
     _range.location,
     _range.length,
     _range.location,
     NSMaxRange(_range), _numberOfMatched - 1];
    
    logOut(!isInRange && logVisible);
#endif
    if (!isInRange) return NO;
    
#ifdef LAH_RULES_DEBUG
    logVisible = YES;
    [info appendFormat:@"\n%@PASS\tALL", space];
    logOut(logVisible);
#endif
    
    return YES;
}

- (LAHOperation*)recursiveOperation{
    LAHRecognizer *father = (LAHRecognizer *)_father;
    return father.recursiveOperation;
}

#pragma mark - State
- (void)saveStateForKey:(id)key{
    //NSNumber *count = [[NSNumber alloc] initWithUnsignedInteger:_numberOfMatched];
    if (_matchingElement) [_states setObject:_matchingElement forKey:key];
    //[count release];
    for (LAHConstruct *c in _children) {
        [c saveStateForKey:key];
    }
}

- (void)restoreStateForKey:(id)key{
    //NSNumber *count = [_states objectForKey:key];
    _matchingElement = [_states objectForKey:key];
    [_states removeObjectForKey:key];
    for (LAHConstruct *c in _children) {
        [c restoreStateForKey:key];
    }
}

- (void)refreshState{
    _numberOfMatched = 0;
    for (LAHRecognizer *r in _children) {
        [r refreshState];
    }
}

#pragma mark - Interpreter
- (void)addFetcher:(LAHFetcher *)fetcher{
    if (_fetchers == nil) [self.fetchers = [[NSMutableArray alloc] init] release];
    [(NSMutableArray *)_fetchers addObject:fetcher];
}

- (void)addDownloader:(LAHDownloader *)downloader{
    if (_downloaders == nil) [self.downloaders = [[NSMutableArray alloc] init] release];
    [(NSMutableArray *)_downloaders addObject:downloader];
    downloader.father = self;
}

- (void)addAttributes:(NSSet *)attributes withKey:(NSString *)key{
    if (_attributes == nil) [self.attributes = [[NSMutableDictionary alloc] init] release];
    [(NSMutableDictionary *)_attributes setObject:attributes forKey:key];
}

#pragma mark - Log
- (NSString *)infoProperties{
    NSMutableString *info = [NSMutableString string];
    
    for (NSString *key in _attributes.allKeys) {
        [info appendFormat:@"%@={", key];
        NSSet *attrs = [_attributes objectForKey:key];
        for (NSString *attr in attrs) {
            [info appendFormat:@"%@, ", attr];
        }
        [info appendString:@"}, "];
    }
    if (!NSEqualRanges(_range, NSMakeRange(0, NSUIntegerMax))) {
        [info appendFormat:@"range=(%d, %d), ", _range.location, _range.length];
    }
    if (_isTextNode) [info appendString:@"isTextNode, "];
    if (_rule) [info appendString:@"hasRule"];
    return info;
}

- (NSString *)infoChildren:(NSUInteger)degree{
    NSMutableString *info = [NSMutableString string];

    for (LAHFetcher *f in _fetchers) [info appendString:[f info:degree]];
    for (LAHDownloader *d in _downloaders) [info appendString:[d info:degree]];
    [info appendString:[super infoChildren:degree]];
    
    return info;
}

@end

