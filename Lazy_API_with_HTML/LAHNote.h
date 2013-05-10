//
//  LAHNote.h
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 5/4/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNode.h"
#define LAH_RULES_DEBUG

@interface LAHNote : LAHNode {
    NSString *_note;
}
@property(nonatomic, copy)NSString *note;
@property(nonatomic, readonly)NSMutableArray *mutableChildren;
@property(nonatomic, readonly)NSUInteger reverseDegree;
@property(nonatomic, readonly)NSString *noteDes;

- (NSString *)noteDescBy:(NSUInteger)rDegree on:(NSUInteger)degree;

+ (void)openNote:(NSString *)desc, ...;
+ (void)closeNote;
+ (void)quickNote:(NSString *)desc, ...;
+ (void)closeAll;
+ (void)clean;
+ (void)logAllAndClean;
+ (NSString *)logBy:(NSUInteger)rDegree on:(NSUInteger)degree;
@end

#define BOOLStr(b) ((b) ? @"YES" : @"NO")
#define TestStr(b) ((b) ? @"PASS" : @"FAIL")
#define NumberStr(n) ([NSString stringWithFormat:@"%d", (n)])

@interface LAHNote (NoteAttribute)
+ (void)noteAttr:(NSString *)name d:(NSString *)destination s:(NSString *)source pass:(BOOL)pass;
+ (void)logWisely;

#ifdef LAH_RULES_DEBUG

#define LAHNoteAttr(name, des, src, isPass) ([LAHNote noteAttr:(name) d:(des) s:(src) pass:(isPass)])
#define LAHNoteLogWisely ([LAHNote logWisely])

#else

#define LAHNoteAttr(name, des, src, isPass)
#define LAHNoteLogWisely

#endif

@end

#ifdef LAH_RULES_DEBUG
#define LAHNoteOpen(desc, ...) ([LAHNote openNote:(desc), __VA_ARGS__])
#define LAHNoteClose ([LAHNote closeNote])
#define LAHNoteQuick(desc, ...) ([LAHNote quickNote:(desc), __VA_ARGS__])
#define LAHNoteCloseAll ([LAHNote closeAll])
#define LAHNoteClean ([LAHNote clean])
#define LAHNoteLogAllAndClean ([LAHNote logAllAndClean])

#else

#define LAHNoteOpen(desc, ...)
#define LAHNoteClose
#define LAHNoteQuick(desc, ...)
#define LAHNoteCloseAll
#define LAHNoteClean
#define LAHNoteLogAllAndClean

#endif