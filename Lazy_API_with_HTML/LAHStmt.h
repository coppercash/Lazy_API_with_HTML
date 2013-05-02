//
//  LAHStatement.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 3/9/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LAHFrame;
@class LAHNode;
@class LAHStmtValue, LAHStmtAttribute, LAHAttribute, LAHStmtMultiple;

@interface LAHStmt : NSObject
- (id)evaluate:(LAHFrame *)frame;
@end


@interface LAHStmtSuite : LAHStmt
@property(nonatomic, retain)NSMutableArray *statements;
@end


@interface LAHStmtEntity : LAHStmt
@property(nonatomic, retain)NSMutableArray *attributes;
@property(nonatomic, retain)NSMutableArray *children;

- (LAHNode *)entity;
- (BOOL)attribute:(LAHStmtAttribute *)attr of:(LAHNode *)entity inFrame:(LAHFrame *)frame;

@end


@interface LAHStmtModel : LAHStmtEntity
@end


@interface LAHStmtArray : LAHStmtModel
@end


@interface LAHStmtDictionary : LAHStmtModel
@end


@interface LAHStmtString : LAHStmtModel
@end


@interface LAHStmtOperation : LAHStmtEntity
@end


@interface LAHStmtTag : LAHStmtEntity
+ (BOOL)add:(LAHStmtValue *)value to:(LAHAttribute *)attribute frame:(LAHFrame *)frame;
@end


@interface LAHStmtPage : LAHStmtEntity
@end


@interface LAHStmtAttribute : LAHStmt
@property(nonatomic, copy)NSString *name;
@property(nonatomic, retain)LAHStmtValue *value;
@property(nonatomic, copy)NSString *methodName;
@property(nonatomic, retain)LAHStmtMultiple *args;
@end


@interface LAHStmtValue : LAHStmt {
    NSString *_value;
}
@property(nonatomic, copy)NSString *value;
@end


@interface LAHStmtNumber : LAHStmtValue
@end


@interface LAHStmtMultiple : LAHStmtValue
@property(nonatomic, retain)NSArray *values;
+ (NSArray *)convertRange:(NSArray *)range frame:(LAHFrame *)frame;
@end


@class LAHNode;
@interface LAHStmtRef : LAHStmtValue
@property(nonatomic, copy)NSString *name;
@end

