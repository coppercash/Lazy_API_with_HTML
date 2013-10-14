//
//  ViewController.m
//  LAHDemo
//
//  Created by William Remaerd on 2/6/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "ViewController.h"
#import "LAHOperation.h"
#import "LMHModelsGroup.h"

#import "LAHInterpreter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"51VOA" ofType:@"lah"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    _group = [[LMHModelsGroup alloc] initWithCommand:string key:@"ope"];
    
    LAHOperation *ope = _group.operations[0];
    _ope = ope.copy;
    
    
    [_ope addCompletion:^(LAHOperation *operation) {
        NSLog(@"%@", operation.data);
    }];
    [_ope start];
    
    
    [self performSelector:@selector(clean) withObject:nil afterDelay:7.0];
}

- (void)clean{
    [_group release];
    [_ope release];
    _ope = nil;
    _group = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
