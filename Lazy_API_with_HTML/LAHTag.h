//
//  LAHRecognizer.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 2/5/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"
#import "LAHInterface.h"

@class LAHString;
@interface LAHTag : LAHNode {
    NSArray *_indexes;
    NSMutableSet *_attributes;
    
    NSSet *_indexOf;
    
    BOOL _isDemocratic;
}
@property(nonatomic, assign)BOOL isDemocratic;
@property(nonatomic, retain)NSArray *indexes;
@property(nonatomic, retain)NSMutableSet *attributes;
@property(nonatomic, retain)NSSet *indexOf;
@property(nonatomic, assign)NSRange singleRange;

- (BOOL)handleElement:(LAHEle)element atIndex:(NSInteger)index;

@end