//
//  FriendsNavigationViewController.m
//  Fitivate
//
//  Created by Rayden Lee on 20/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "FriendsNavigationViewController.h"

@interface FriendsNavigationViewController ()

@end

@implementation FriendsNavigationViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
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
    NSLog(@"FriendsNavigationViewController - viewDidAppear");
    
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
