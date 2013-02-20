//
//  LAHConstruct.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/15/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHConstruct.h"
#import "LAHRecognizer.h"
#import "LAHOperation.h"

@implementation LAHConstruct
@synthesize type = _type, key = _key, indexSource = _indexSource;
@synthesize count = _count;

- (id)initWithKey:(NSString *)key children:(LAHNode *)firstChild, ... NS_REQUIRES_NIL_TERMINATION{
    va_list children; va_start(children, firstChild);
    self = [super initWithFirstChild:firstChild variadicChildren:children];
    va_end(children);
    if (self){
        self.key = key;
    }
    return self;
}

- (void)dealloc{
    [_key release]; _key = nil;
    _indexSource = nil;
    
    [super dealloc];
}

- (id)recieveObject:(LAHConstruct*)object{
    _count ++;
    return nil;
}

- (id)newValue{
    return nil;
}

- (NSUInteger)index{
    if (_indexSource == nil) return NSNotFound;
    return _indexSource.numberOfMatched - _indexSource.range.location - 1;
}

@end

@implementation LAHDictionary
@synthesize dictionary = _dictionary;

- (void)dealloc{
    [_dictionary release]; _dictionary = nil;
    
    [super dealloc];
}

- (id)recieveObject:(LAHConstruct*)object{
    NSMutableDictionary *dictionary = nil;
    if (_father == nil) {   //root construct
        if (_dictionary == nil) _dictionary = [[NSMutableDictionary alloc] init];
        dictionary = _dictionary;
    }else{
        dictionary = [(LAHConstruct*)_father recieveObject:self];   //Assert dictionary never be nil
    }
    
    id value = [dictionary objectForKey:object.key];
    if (value == nil) {
        [dictionary setObject:(value = object.newValue) forKey:object.key];
    }
    
    return value;
}

- (id)newValue{
    [_dictionary release];
    _dictionary = [[NSMutableDictionary alloc] init];
    _count ++;
    return _dictionary;
}

- (id)container{
    return _dictionary;
}

@end

@implementation LAHArray
@synthesize array = _array;

- (void)dealloc{
    [_array release]; _array = nil;
    
    [super dealloc];
}


- (id)recieveObject:(LAHConstruct*)object{
    NSMutableArray *array = nil;
    if (_father == nil) { //root construct
        if (_array == nil) _array = [[NSMutableArray alloc] init];
        array = _array;
    }else{
        array = [(LAHConstruct*)_father recieveObject:self];    //Assert array never be nil
    }
    
    id value = nil;
    if (object.indexSource == nil) {
        [array addObject:(value = object.newValue)];
    }else{
        NSRange rBO = NSMakeRange(0, [_children indexOfObject:object]); //range before object
        NSArray *subArray = [_children subarrayWithRange:rBO]; //child brefore object
        
        NSUInteger index = object.index;    //sub index
        for (LAHConstruct *c in subArray) index += c.count; //index is legal across all children
        
        if (index < array.count) {
            value = [array objectAtIndex:index];
        }else{
            for (int i = array.count; i <= index; i++) [array addObject:(value = object.newValue)];
        }
    }
    
    return value;
}

- (id)newValue{
    [_array release];
    _array = [[NSMutableArray alloc] init];
    _count ++;
    return _array;
}

- (id)container{
    return _array;
}

@end

@implementation LAHFetcher
@synthesize fetcher = _fetcher, property = _property;
#pragma mark - Life Cycle
- (id)initWithKey:(NSString*)key fetcher:(LAHPropertyFetcher)fetcher{
    self = [super init];
    if (self) {
        self.type = LAHConstructTypeFetcher;
        self.key = key;
        self.fetcher = fetcher;
    }
    return self;
}

- (id)initWithFetcher:(LAHPropertyFetcher)property{
    self = [super init];
    if (self) {
        self.type = LAHConstructTypeFetcher;
        self.fetcher = property;
    }
    return self;
}

- (void)dealloc{
    [_fetcher release]; _fetcher = nil;
    [_property release]; _property = nil;
    
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    LAHFetcher *copy = [[[self class] allocWithZone:zone] init];
    
    copy.father = self.father;
    copy.children = self.children;
    
    copy.type = self.type;
    copy.key = self.key;
    copy.indexSource = self.indexSource;
    
    copy.fetcher = self.fetcher;
    
    return copy;
}

#pragma mark - Element
- (void)fetchProperty:(id<LAHHTMLElement>)element{
    [_property release];
    _property = [_fetcher(element) copy];
    
    if (_property == nil) return;
    LAHConstruct *father = (LAHConstruct *)_father;
    [father recieveObject:self];
}

- (id)newValue{
    _count ++;
    if (_property == nil) return [NSNull null];
    return _property;
}

@end
