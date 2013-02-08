//
//  ViewController.m
//  LAHDemo
//
//  Created by William Remaerd on 2/6/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "ViewController.h"
#import "LAHOperation.h"
#import "LAH51voa.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _lah = [[LAH51voa alloc] initWithHostName:@"www.51voa.com"];

    LAHOperation *homePage = [_lah homePage];
    [homePage addCompletion:^(LAHOperation *operation) {
        NSLog(@"%@", operation.container);
    }];
    [homePage start];
    
    [_lah performSelector:@selector(release) withObject:nil afterDelay:7.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
