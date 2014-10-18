//
//  TimelineNavigationViewController.m
//  Fitivate
//
//  Created by Rayden Lee on 21/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "TimelineNavigationViewController.h"

@interface TimelineNavigationViewController ()

@end

@implementation TimelineNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"TimelineNavigationViewController - viewDidAppear");
    
    [super viewDidAppear:animated];
    
    // hide the main view controller nav bar
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
