//
//  SignupViewController.m
//  Fitivate
//
//  Created by Rayden Lee on 10/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "SignupViewController.h"
#import "SignupValidator.h"
#import "UserRequestHandler.h"

@interface SignupViewController ()

@end

@implementation SignupViewController {
    UserRequestHandler *_userRequestHandler;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
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
    
    [self.emailTextField becomeFirstResponder];
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
                                             selector:@selector(userCreatedSuccess:)
                                                 name:UserCreatedSuccessEvent
                                                    object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userCreatedFailure:)
                                                 name:UserCreatedFailureEvent
                                               object:nil];
}

- (void)removeEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UserCreatedSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UserCreatedFailureEvent
                                               object:nil];
}

- (void)userCreatedSuccess:(NSNotification *)notification
{
    [ActivityIndicator hideWithView:self.view];
    
    [self performSegueWithIdentifier:SignupToMain sender:self];
}

- (void)userCreatedFailure:(NSNotification *)notification
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
    
    if ([segueIdentifier isEqualToString:SignupToMain])
    {
        UIViewController *upcomingViewController = segue.destinationViewController;
        
        [upcomingViewController.navigationItem setLeftBarButtonItem:nil];
        [upcomingViewController.navigationItem setHidesBackButton:YES animated:YES];
    }
}

- (IBAction)didTapSignup:(id)sender
{
    NSString *email = [self.emailTextField text];
    NSString *username = [self.usernameTextField text];
    NSString *password = [self.passwordTextField text];
    
    SignupValidator *validator = [[SignupValidator alloc] initWithDelegate:self];
    
    if ([validator validate:email username:username password:password])
    {
        [ActivityIndicator showWithView:self.view];
        
        [_userRequestHandler createUserWithEmail:email username:username password:password];
    }
}
@end
