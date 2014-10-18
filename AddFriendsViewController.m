//
//  AddFriendsViewController.m
//  Fitivate
//
//  Created by Rayden Lee on 14/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "FriendRequestHandler.h"

@interface AddFriendsViewController ()

@end

@implementation AddFriendsViewController
{
    FriendRequestHandler *_friendRequestHandler;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        _friendRequestHandler = [[FriendRequestHandler alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.friendTextField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupEvents];
    
    [self.friendTextField becomeFirstResponder];
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
                                             selector:@selector(addFriendSuccess:)
                                                 name:AddFriendSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addFriendFailure:)
                                                 name:AddFriendFailureEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addFriendNotFound:)
                                                 name:AddFriendNotFoundEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addFriendAlreadyFriend:)
                                                 name:AddFriendAlreadyFriendEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addFriendIsYourself:)
                                                 name:AddFriendIsYourselfEvent
                                               object:nil];
}

- (void)removeEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:AddFriendSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:AddFriendFailureEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:AddFriendNotFoundEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:AddFriendAlreadyFriendEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AddFriendIsYourselfEvent
                                                  object:nil];
}

- (void)addFriendSuccess:(NSNotification *)notification
{
    [ActivityIndicator hideWithView:self.view];
    
    [self.currentFriendsUsernames addObject:self.friendTextField.text];
    self.friendTextField.text = @"";
}

- (void)addFriendFailure:(NSNotification *)notification
{
    [ActivityIndicator hideWithView:self.view];
    
    NSString *errorMessage = [[notification userInfo] objectForKey:ErrorResultKey];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ErrorTitle message:errorMessage delegate:self cancelButtonTitle:OkButtonName otherButtonTitles:nil];
    [alert show];
}

- (void)addFriendNotFound:(NSNotification *)notification
{
    [ActivityIndicator hideWithView:self.view];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Found" message:@"No such user exists." delegate:self cancelButtonTitle:OkButtonName otherButtonTitles:nil];
    [alert show];
}

- (void)addFriendAlreadyFriend:(NSNotification *)notification
{
    [ActivityIndicator hideWithView:self.view];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Add" message:@"This user has already been added as one of your Fiti-mates." delegate:self cancelButtonTitle:OkButtonName otherButtonTitles:nil];
    [alert show];
}

- (void)addFriendIsYourself:(NSNotification *)notification
{
    [ActivityIndicator hideWithView:self.view];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Add" message:@"You cannot add yourself as a friend." delegate:self cancelButtonTitle:OkButtonName otherButtonTitles:nil];
    [alert show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.friendTextField) {
        [self addFriend];
    }
    return YES;
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

- (void) addFriend
{
    NSString *candidate = [self.friendTextField text];
    
    [ActivityIndicator showWithView:self.view];
    
    [_friendRequestHandler addFriendWithCandidate:candidate existingFriendsUsernames:self.currentFriendsUsernames];
}

- (IBAction)didTapAddFriend:(id)sender
{
    [self addFriend];
}
@end
