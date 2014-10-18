//
//  LoginViewController.m
//  Fitivate
//
//  Created by Rayden Lee on 10/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "LoginViewController.h"
#import "UserRequestHandler.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    UserRequestHandler *_userRequestHandler;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Custom initialization
        _userRequestHandler = [[UserRequestHandler alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupEvents];
    
    [self.usernameTextField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self removeEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLoginSuccess:)
                                                 name:UserLoginSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLoginFailure:)
                                                 name:UserLoginFailureEvent
                                               object:nil];
}

- (void)removeEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UserLoginSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UserLoginFailureEvent
                                               object:nil];
}

- (void)userLoginSuccess:(NSNotification *)notification
{
    NSLog(@"LoginViewController - userLoginSuccess");

    [ActivityIndicator hideWithView:self.view];
    
    [self performSegueWithIdentifier:LoginToMain sender:self];
}

- (void)userLoginFailure:(NSNotification *)notification
{
    [ActivityIndicator hideWithView:self.view];
    
    NSString *errorString = [[notification userInfo] objectForKey:ErrorResultKey];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ErrorTitle message:errorString delegate:self cancelButtonTitle:OkButtonName otherButtonTitles:nil];
    [alert show];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSString *segueIdentifier = [segue identifier];
    
    if ([segueIdentifier isEqualToString:LoginToMain])
    {
        UIViewController *upcomingViewController = segue.destinationViewController;
        
        [upcomingViewController.navigationItem setLeftBarButtonItem:nil];
        [upcomingViewController.navigationItem setHidesBackButton:YES animated:YES];
    }
}


- (IBAction)didTapLogin:(id)sender
{
    NSLog(@"LoginViewController - didTapLogin");
    
    NSString *username = [self.usernameTextField text];
    NSString *password = [self.passwordTextField text];
    
    [ActivityIndicator showWithView:self.view];
    
    [_userRequestHandler loginUserWithUsername:username password:password];
}
@end
