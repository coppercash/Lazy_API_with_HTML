//
//  LAHStatement.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 3/9/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LAHNode, LAHModel;

@interface LAHFrame : NSObject
@property(nonatomic, retain)NSMutableDictionary *generates;
@property(nonatomic, retain)NSMutableSet *gains;
- (id)initWithDictionary:(NSMutableDictionary *)container;
- (void)doGain;
@end

@interface LAHStmt : NSObject
- (id)evaluate:(LAHFrame *)frame;
@end

@interface LAHStmtSuite : LAHStmt
@property(nonatomic, retain)NSArray *statements;
@end

@interface LAHStmtEntity : LAHStmt
@property(nonatomic, copy)NSString *generate;
@property(nonatomic, retain)NSMutableArray *properties;
@property(nonatomic, retain)NSMutableArray *children;
- (void)generate:(LAHNode *)object inFrame:(LAHFrame *)frame;
- (void)propertiesOfObject:(LAHNode *)object inFrame:(LAHFrame *)frame;
- (void)childrenOfObject:(LAHNode *)object inFrame:(LAHFrame *)frame;
@end

@interface LAHStmtConstruct : LAHStmtEntity
@end

@interface LAHStmtArray : LAHStmtConstruct
@end

@interface LAHStmtDictionary : LAHStmtConstruct
@end

@interface LAHStmtString : LAHStmtConstruct
@end

@interface LAHStmtOperation : LAHStmtEntity
@end

@interface LAHStmtTag : LAHStmtEntity
@end

@interface LAHStmtPage : LAHStmtEntity
@end

@class LAHStmtValue;
@interface LAHStmtAttribute : LAHStmt
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *re;
@property(nonatomic, retain)LAHStmtValue *value;
//- (NSString *)propertyName;
@end

@interface LAHStmtValue : LAHStmt
@property(nonatomic, copy)NSString *string;
@end

@interface LAHStmtNumber : LAHStmtValue
@property(nonatomic, copy)NSString *value;
@end

@interface LAHStmtMultiple : LAHStmtValue
@property(nonatomic, retain)NSArray *values;
@end
/*
@interface LAHStmtTuple : LAHStmtValue
- (id)evaluate:(LAHFrame *)frame gainTarget:(LAHNode *)target;
@property(nonatomic, retain)NSArray *values;
@end

@interface LAHStmtSet : LAHStmtValue
- (id)evaluate:(LAHFrame *)frame gainTarget:(LAHNode *)target;
@property(nonatomic, retain)NSArray *values;
@end
*/
@class LAHNode;
@interface LAHStmtGain : LAHStmtValue
@property(nonatomic, copy)NSString *name;
@property(nonatomic, assign)LAHNode *target;
@property(nonatomic, assign)SEL method;
- (id)evaluate:(LAHFrame *)frame target:(id)target method:(SEL)method;
@end

NSString *quotedString(NSString *string);