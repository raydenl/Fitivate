//
//  SignupViewController.h
//  Fitivate
//
//  Created by Rayden Lee on 10/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;

- (IBAction)didTapSignup:(id)sender;

@end
