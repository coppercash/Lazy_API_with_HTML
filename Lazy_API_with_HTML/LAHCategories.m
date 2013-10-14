//
//  LAHCategories.m
//  Lazy_API_with_HTML
//
//  Created by William Remaerd on 5/2/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "LAHCategories.h"
#import "LAHFrame.h"

@implementation NSArray (LAHArray)

- (NSArray *)dividedRangesWithFrame:(LAHFrame *)frame{
    
    NSInteger index = 0;
    NSRange cRange = NSMakeRange(0, 0);
    NSMutableArray *collector = [NSMutableArray arrayWithCapacity:self.count / 2];
    while (index < self.count) {
        NSNumber *locNum = self[index ++];
        [frame object:@"Range" accept:@[[NSNumber class]] find:locNum];
        NSUInteger loc = locNum.unsignedIntegerValue;
        
        if (index >= self.count) break;
        
        NSNumber *lenNum = self[index ++];
        [frame object:@"Range" accept:@[[NSNumber class]] find:lenNum];
        NSUInteger len = lenNum.unsignedIntegerValue;
        
        if (len == 0) continue;
        
        if (NSEqualRanges(cRange, NSMakeRange(0, 0))) {
            cRange.location = loc;
        } else {
            cRange.location = NSMaxRange(cRange) - 1 + loc;
        }
        cRange.length = len;
        NSValue *rangeValue = [NSValue valueWithRange:cRange];
        
        [collector addObject:rangeValue];
    }
    
    return collector;

}

- (BOOL)locationInDividedRanges:(NSUInteger)location{
    
    for (NSValue *rangeValue in self) {
        NSRange range = rangeValue.rangeValue;
        if (NSLocationInRange(location, range)) return YES;
    }
    return NO;

}

- (NSString *)dividedDesc{
    NSMutableString *message = [NSMutableString stringWithFormat:@"{"];
    for (NSValue *rangeValue in self) {
        NSRange range = rangeValue.rangeValue;
        [message appendFormat:@"%@%d...%d",
         ([self objectAtIndex:0] == rangeValue ? @"" : @", "),
         range.location,
         NSMaxRange(range) - 1];
    }
    [message appendFormat:@"}"];
    return message;
}

- (NSString *)lineDesc{
    NSMutableString *message = [NSMutableString string];
    for (NSObject *object in self) {
        [message appendFormat:@"%@\"%@\"", ([self objectAtIndex:0] == object ? @"" : @", "), object];
    }
    return message;
}

@end

@implementation NSString (LAHString)

- (void)log{
    printf("%s", [self cStringUsingEncoding:NSASCIIStringEncoding]);
}

@end