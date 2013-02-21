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
#import "LAHVoaNews.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _51voa = [[LAH51voa alloc] init];
    
    LAHOperation *homePage = [_51voa homePage];
    [homePage addCompletion:^(LAHOperation *operation) {
        NSLog(@"\n51voa\n%@", operation.container);
    }];
    [homePage start];
     
    
    _voaNews = [[LAHVoaNews alloc] init];
    
    LAHOperation *voaHome = [_voaNews homePage];
    [voaHome addCompletion:^(LAHOperation *operation) {
        NSLog(@"\nvoanews\n%@", operation.container);
    }];
    [voaHome start];
    
    
    [self performSelector:@selector(clean) withObject:nil afterDelay:10.0f];
}

- (void)clean{
    [_51voa release];
    [_voaNews release];
    NSLog(@"Finish cleaning.");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
