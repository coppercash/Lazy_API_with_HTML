//
//  LAHNote.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 5/4/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNote.h"


@interface LAHNote ()
@end

@implementation LAHNote
@synthesize note = _note;
@dynamic mutableChildren;
@dynamic reverseDegree;
@dynamic noteDes;

- (NSMutableArray *)mutableChildren{
    if (!_children) {
        _children = [[NSMutableArray alloc] init];
    }
    return (NSMutableArray *)_children;
}

- (NSUInteger)reverseDegree{
    NSUInteger max = 0;
    for (LAHNote *child in _children) {
        max = MAX(max, child.reverseDegree);
    }
    return (_children.count == 0) ? 0 : max + 1;
}

- (NSString *)noteDes{
    
    NSMutableString *log = [NSMutableString stringWithFormat:@"%@%@", self.degreeSpace, _note];
    for (LAHNote *child in _children) {
        [log appendFormat:@"\n%@", child.noteDes];
    }

    return log;
}

- (NSString *)noteDesBy:(NSUInteger)rDegree on:(NSUInteger)degree{
    //Rewrite
    NSUInteger d = self.degree, r = self.reverseDegree;
    if (d == degree && r < rDegree) return nil;
    if (d + r < degree) return nil;
    
    NSMutableString *childrenLog = [NSMutableString string];
    for (LAHNote *child in _children) {
        NSString *childLog = [child noteDesBy:rDegree on:degree];
        if (childLog) [childrenLog appendFormat:@"\n%@", childLog];
    }
    
    if ([childrenLog isEqualToString:@""] && _children.count != 0) return nil;
    
    NSString *log = [NSString stringWithFormat:@"%@%@%@", self.degreeSpace, _note, childrenLog];
    
    return log;
}

#pragma mark - Static
static LAHNote *_currentNote = nil;
static NSMutableArray *_rootNotes = nil;

+ (NSString *)logBy:(NSUInteger)rDegree on:(NSUInteger)degree{
    NSMutableString *log = [NSMutableString string];
    for (LAHNote *note in _rootNotes) {
        [log appendFormat:@"\n%@", [note noteDesBy:rDegree on:degree]];
    }
    [log appendString:@"\n"];
    return log;
}

+ (void)openNote:(NSString *)format, ...{
    va_list va;
    va_start(va, format);
    [self openNote:format arguments:va];
    va_end(va);
}

+ (void)openNote:(NSString *)format arguments:(va_list)argumets{
    if (!_rootNotes) {
        _rootNotes = [[NSMutableArray alloc] init];
    }
    
    LAHNote *newNote = [[self alloc] init];
    newNote.note = [[NSString alloc] initWithFormat:format arguments:argumets];
    newNote.father = _currentNote;
    
    if (_currentNote) {
        
        [_currentNote.mutableChildren addObject:newNote];
        
    } else {
        
        [_rootNotes addObject:newNote];
        
    }
    
    _currentNote = newNote;
    [newNote.note release];
    [newNote release];
}

+ (void)closeNote{
    _currentNote = (LAHNote *)_currentNote.father;
}

+ (void)quickNote:(NSString *)format, ...{
    va_list va;
    va_start(va, format);
    [self openNote:format arguments:va];
    va_end(va);
    [self closeNote];
}

+ (void)logAllAndClean{
    [self closeAll];
    NSLog(@"%@", [LAHNote logBy:0 on:0]);
    [self clean];
}

+ (void)closeAll{
    while (_currentNote) {
        [self closeNote];
    }
}

+ (void)clean{
    [_rootNotes removeAllObjects];
}

@end

@implementation LAHNote (NoteAttribute)
+ (void)noteAttr:(NSString *)name d:(NSString *)destination s:(NSString *)source pass:(BOOL)pass{
    NSString *info = [NSString stringWithFormat:@"%@ %@\t%@\t%@", TestStr(pass), name, destination, source];
    [self quickNote:info];
    if (!pass) {
        [self closeNote];
    }
}

+ (void)logWisely{
    [self closeAll];
    NSLog(@"%@", [LAHNote logBy:2 on:2]);
    [self clean];
}
@end
