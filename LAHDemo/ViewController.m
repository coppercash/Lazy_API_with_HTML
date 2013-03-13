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

#import "Token.h"
#import "LAHParser.h"
#import "LAHStmt.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"voa" ofType:@"lah"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    /*
    NSArray *tokens = [Token tokenizeString:string];
    for (Token *t in tokens) {
        NSLog(@"%@", t.stringValue);
    }*/
    LAHParser *parser = [[LAHParser alloc] initWithString:string];
    LAHStmtSuite *suite = [parser parse];
    NSMutableDictionary *container = [[NSMutableDictionary alloc] init];
    LAHFrame *frame = [[LAHFrame alloc] initWithContainer:container];
    NSArray *results = [suite evaluate:frame];
    [frame doGain];
    
    for (LAHNode *r in results) {
        [r log:0];
    }
    //[parser parse];
    
    /*
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
    */
    
    //[self performSelector:@selector(clean) withObject:nil afterDelay:10.0f];
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
