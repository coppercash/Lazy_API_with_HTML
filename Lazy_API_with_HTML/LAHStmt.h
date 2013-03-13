//
//  LAHStatement.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 3/9/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
typedef enum {
    LAHStmtEntityTypeUnknown,
    LAHStmtEntityTypeArray,
    LAHStmtEntityTypeDicitonary,
    LAHStmtEntityTypeFetcher,
    LAHStmtEntityTypeOperation,
    LAHStmtEntityTypeRecognizer,
    LAHStmtEntityTypeDownloader
}LAHStmtEntityType;
*/
@class LAHNode, LAHConstruct;

@interface LAHFrame : NSObject
@property(nonatomic, retain)NSMutableDictionary *generates;
@property(nonatomic, retain)NSMutableSet *gains;
- (id)initWithContainer:(NSMutableDictionary *)container;
- (void)doGain;
@end

@interface LAHStmt : NSObject
- (id)evaluate:(LAHFrame *)frame;
@end

@interface LAHStmtSuite : LAHStmt
@property(nonatomic, retain)NSArray *statements;
@end

//@class LAHStmtGenerate;
@interface LAHStmtEntity : LAHStmt
//@property(nonatomic)LAHStmtEntityType type;
@property(nonatomic, copy)NSString *generate;
//@property(nonatomic, retain)LAHStmtGenerate *generate;
@property(nonatomic, retain)NSArray *properties;
@property(nonatomic, retain)NSArray *children;
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

@interface LAHStmtFetcher : LAHStmtConstruct
@end

@interface LAHStmtOperation : LAHStmtEntity
@end

@interface LAHStmtRecgnizer : LAHStmtEntity
@end

@interface LAHStmtDownloader : LAHStmtEntity
@end
/*
@interface LAHStmtGenerate : LAHStmt
@property(nonatomic, copy)NSString *name;
@end
*/
@class LAHStmtValue;
@interface LAHStmtProperty : LAHStmt
@property(nonatomic, copy)NSString *name;
@property(nonatomic, retain)LAHStmtValue *value;
@end

@interface LAHStmtValue : LAHStmt
@property(nonatomic, copy)NSString *string;
@end

@interface LAHStmtTuple : LAHStmtValue
@property(nonatomic, retain)NSArray *values;
@end

@interface LAHStmtSet : LAHStmtValue
@property(nonatomic, retain)NSArray *values;
@end

@class LAHNode;
@interface LAHStmtGain : LAHStmtValue
@property(nonatomic, copy)NSString *name;
@property(nonatomic, assign)LAHNode *target;
@property(nonatomic, assign)SEL method;
- (id)evaluate:(LAHFrame *)frame target:(id)target method:(SEL)method;
@end