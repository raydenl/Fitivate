//
//  SplashViewController.m
//  Fitivate
//
//  Created by Rayden Lee on 10/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad
{
    NSLog(@"SplashViewController - viewDidLoad");
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"SplashViewController - viewDidAppear");
    
    [super viewDidAppear:animated];
    
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self checkStatus];
}

- (void)checkStatus
{
    NSLog(@"SplashViewController - checkStatus");
    
    //[ActivityIndicator showActivityIndicator:self.view];
    [self.loginButton setHidden:YES];
    [self.signupButton setHidden:YES];
    
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:SplashToMain sender:self];
    } else {
        //[ActivityIndicator hideActivityIndicator:self.view];
        [self.loginButton setHidden:NO];
        [self.signupButton setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSString *segueIdentifier = [segue identifier];
    
    if ([segueIdentifier isEqualToString:SplashToMain])
    {
        UIViewController *upcomingViewController = segue.destinationViewController;
        
        [upcomingViewController.navigationItem setLeftBarButtonItem:nil];
        [upcomingViewController.navigationItem setHidesBackButton:YES animated:YES];
    }
    
    if ([segueIdentifier isEqualToString:SplashToLogin])
    {
        // create a custom back button item, and set it
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        [self.navigationItem setBackBarButtonItem:backBarButtonItem];
    }
    
    if ([segueIdentifier isEqualToString:SplashToSignup])
    {
        // create a custom back button item, and set it
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        [self.navigationItem setBackBarButtonItem:backBarButtonItem];
    }
}


- (IBAction)didTapLogin:(id)sender
{
    NSLog(@"SplashViewController - didTapLogin");
    
    [self performSegueWithIdentifier:SplashToLogin sender:self];
}

- (IBAction)didTapSignup:(id)sender
{
    NSLog(@"SplashViewController - didTapSignup");
    
    [self performSegueWithIdentifier:SplashToSignup sender:self];
}
@end
