//
//  LAHNoteTest.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 5/4/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHNoteTest.h"
#import "LAHNote.h"

@implementation LAHNoteTest

- (void)testMutableChildren{
    LAHNote *note = [[[LAHNote alloc] init] autorelease];
    LAHNote *child = [[[LAHNote alloc] init] autorelease];
    STAssertNoThrow([note.mutableChildren addObject:child], @"Add child to mutableChild.");
    STAssertEquals(note.mutableChildren.count, 1U, @"Mutable Children count.");
    STAssertNoThrow([note.mutableChildren removeObject:child], @"remove child from mutableChild.");
}

- (void)testDegree{
    LAHNote *note0 = [[[LAHNote alloc] init] autorelease];
    LAHNote *note0_0 = [[[LAHNote alloc] init] autorelease];
    LAHNote *note0_1 = [[[LAHNote alloc] init] autorelease];
    LAHNote *note0_2 = [[[LAHNote alloc] init] autorelease];
    LAHNote *note0_0_0 = [[[LAHNote alloc] init] autorelease];
    LAHNote *note0_0_1 = [[[LAHNote alloc] init] autorelease];
    LAHNote *note0_1_0 = [[[LAHNote alloc] init] autorelease];
    LAHNote *note0_1_0_0 = [[[LAHNote alloc] init] autorelease];

    note0.children = @[note0_0, note0_1, note0_2];
    note0_0.children = @[note0_0_0, note0_0_1];
    note0_1.children = @[note0_1_0];
    note0_1_0.children = @[note0_1_0_0];
    
    STAssertEquals(note0.reverseDegree, 3U, @"Degree");
    STAssertEquals(note0_0.reverseDegree, 1U, @"Degree");
    STAssertEquals(note0_1.reverseDegree, 2U, @"Degree");
    STAssertEquals(note0_2.reverseDegree, 0U, @"Degree");
    STAssertEquals(note0_0_0.reverseDegree, 0U, @"Degree");
    STAssertEquals(note0_0_1.reverseDegree, 0U, @"Degree");
    STAssertEquals(note0_1_0.reverseDegree, 1U, @"Degree");
    STAssertEquals(note0_1_0_0.reverseDegree, 0U, @"Degree");

}

- (void)testOpenNote{
    [LAHNote openNote:@"0"];
    [LAHNote openNote:@"1"];
    [LAHNote openNote:@"2"];
    [LAHNote openNote:@"3"];
    [LAHNote closeAll];

    NSLog(@"%@", [LAHNote logBy:0 on:0]);
    [LAHNote clean];
}

- (void)testQuickNote{
    [LAHNote openNote:@"0"];
    [LAHNote quickNote:@"1"];
    [LAHNote quickNote:@"2"];
    [LAHNote quickNote:@"3"];
    [LAHNote closeAll];

    NSLog(@"%@", [LAHNote logBy:0 on:0]);
    [LAHNote clean];
}

- (void)testCloseNote{
    [LAHNote openNote:@"0"];
    [LAHNote openNote:@"1"];
    [LAHNote quickNote:@"2"];
    [LAHNote quickNote:@"3"];
    [LAHNote openNote:@"4"];
    [LAHNote quickNote:@"5"];
    [LAHNote quickNote:@"6"];
    [LAHNote closeNote];
    [LAHNote closeNote];
    [LAHNote closeNote];
    [LAHNote closeAll];

    NSLog(@"%@", [LAHNote logBy:0 on:0]);
    [LAHNote clean];
}

- (void)testThreshold{
    [LAHNote openNote:@"0"];
    
    [LAHNote openNote:@"1"];
    [LAHNote openNote:@"2"];
    [LAHNote openNote:@"3"];
    [LAHNote openNote:@"4"];
    [LAHNote openNote:@"5"];
    [LAHNote closeNote];
    [LAHNote closeNote];
    [LAHNote closeNote];
    [LAHNote closeNote];
    [LAHNote closeNote];

    [LAHNote openNote:@"6"];
    [LAHNote openNote:@"7"];
    [LAHNote openNote:@"8"];
    [LAHNote openNote:@"9"];
    [LAHNote closeNote];
    [LAHNote closeNote];
    [LAHNote closeNote];
    [LAHNote closeNote];

    [LAHNote openNote:@"10"];
    [LAHNote openNote:@"11"];
    [LAHNote openNote:@"12"];
    [LAHNote closeNote];
    [LAHNote closeNote];
    [LAHNote closeNote];

    [LAHNote openNote:@"13"];
    [LAHNote openNote:@"14"];
    [LAHNote closeNote];
    [LAHNote closeNote];

    [LAHNote openNote:@"15"];
    [LAHNote closeAll];

    NSLog(@"%@", [LAHNote logBy:0 on:0]);
    NSLog(@"%@", [LAHNote logBy:5 on:0]);
    NSLog(@"%@", [LAHNote logBy:6 on:0]);

    NSLog(@"%@", [LAHNote logBy:0 on:1]);
    NSLog(@"%@", [LAHNote logBy:1 on:1]);
    NSLog(@"%@", [LAHNote logBy:2 on:1]);
    NSLog(@"%@", [LAHNote logBy:3 on:1]);
    NSLog(@"%@", [LAHNote logBy:4 on:1]);
    NSLog(@"%@", [LAHNote logBy:5 on:1]);
    
    NSLog(@"%@", [LAHNote logBy:0 on:2]);
    NSLog(@"%@", [LAHNote logBy:1 on:2]);
    NSLog(@"%@", [LAHNote logBy:2 on:2]);
    NSLog(@"%@", [LAHNote logBy:3 on:2]);
    NSLog(@"%@", [LAHNote logBy:4 on:2]);

    [LAHNote logWisely];
}

@end
