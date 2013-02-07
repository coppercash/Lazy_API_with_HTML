//
//  ViewController.m
//  LAHDemo
//
//  Created by William Remaerd on 2/6/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "ViewController.h"
#import "LAHGreffier+Hpple+MKNetwrokKit.h"
#import "LAHRecognizer.h"
#import "LAHContainer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _lah = [[LAHGreffier_Hpple_MKNetwrokKit alloc] initWithHostName:@"www.51voa.com"];

    
    LAHGreffier* d0 = [self multiples];
    d0.dataSource = _lah; d0.delegate = _lah;
    [d0 handleElement:nil atIndex:0];
    //[_lah startWithTreeRoot:d0];
    
    _lah.greffier = d0;
    //[d0 release];
    //[_lah release]; _lah = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (LAHDownloader*)multiple{
    LAHFetcher *f0 = [[LAHFetcher alloc] initWithKey:@"names" propertyGetter:^NSString *(id<LAHHTMLElement> element) {
        return element.text;
    }];
    f0.tagName = @"a";
    f0.range = NSMakeRange(1, 5);
    
    LAHRecognizer *r0 = [[LAHRecognizer alloc] initWithChildren:f0, nil];
    r0.tagName = @"li";
    
    LAHRecognizer *r1 = [[LAHRecognizer alloc] initWithChildren:r0, nil];
    r1.tagName = @"ul";
    
    LAHRecognizer *r2 = [[LAHRecognizer alloc] initWithChildren:r1, nil];
    r2.tagName = @"span";
    r2.attributes = @{@"id":@"list"};

    LAHDownloader* d0 = [[LAHDownloader alloc] initWithChildren:r2, nil];
    d0.propertyGetter = ^NSString *(id<LAHHTMLElement> element) {
        return @"/index.html";
    };
    
    return d0;
}

- (LAHGreffier*)multiples{
    LAHFetcher *type = [[LAHFetcher alloc] initWithKey:@"type" propertyGetter:^NSString *(id<LAHHTMLElement> element) {
        return element.text;
    }];
    type.tagName = @"font";
    
    LAHFetcher *typeLink = [[LAHFetcher alloc] initWithKey:@"typeLink" propertyGetter:^NSString *(id<LAHHTMLElement> element) {
        return [element.attributes objectForKey:@"href"];
    } children:type, nil];
    typeLink.tagName = @"a";[typeLink setIndex:0];
    
    LAHFetcher *name = [[LAHFetcher alloc] initWithKey:@"name" propertyGetter:^NSString *(id<LAHHTMLElement> element) {
        return element.text;
    }];
    name.tagName = @"a"; [name setIndex:2];
    
    LAHFetcher *link = [[LAHFetcher alloc] initWithKey:@"link" propertyGetter:^NSString *(id<LAHHTMLElement> element) {
        return [element.attributes objectForKey:@"href"];
    }];
    link.tagName = @"a"; [link setIndex:2];

    LAHContainer *item = [[LAHDictionary alloc] initWithChildren:name, link, typeLink, type, nil];
    item.tagName = @"li"; item.range = NSMakeRange(0, 7);
    
    LAHContainer *array = [[LAHArray alloc] initWithChildren:item, nil];
    array.tagName = @"ul";

    LAHRecognizer *span = [[LAHRecognizer alloc] initWithChildren:array, nil];
    span.tagName = @"span"; span.attributes = @{@"id":@"list"};

    LAHGreffier *gre = [[LAHGreffier alloc] initWithPath:@"/index.html" rootContainer:array children:span, nil];
    
    return gre;
}


@end
