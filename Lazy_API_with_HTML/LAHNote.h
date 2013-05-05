//
//  LAHNote.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 5/4/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"

@interface LAHNote : LAHNode {
    NSString *_note;
}
@property(nonatomic, copy)NSString *note;
@property(nonatomic, readonly)NSMutableArray *mutableChildren;
@property(nonatomic, readonly)NSUInteger reverseDegree;
@property(nonatomic, readonly)NSString *noteDes;

- (NSString *)noteDesBy:(NSUInteger)rDegree on:(NSUInteger)degree;

+ (void)openNote:(NSString *)format, ...;
+ (void)closeNote;
+ (void)quickNote:(NSString *)format, ...;
+ (NSString *)logBy:(NSUInteger)rDegree on:(NSUInteger)degree;
+ (void)logAllAndClean;
+ (void)closeAll;
+ (void)clean;
@end

#define BOOLStr(b) ((b) ? @"YES" : @"NO")
#define TestStr(b) ((b) ? @"PASS" : @"FAIL")
@interface LAHNote (NoteAttribute)
+ (void)noteAttr:(NSString *)name d:(NSString *)destination s:(NSString *)source pass:(BOOL)pass;
+ (void)logWisely;
@end