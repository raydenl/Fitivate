//
//  LoginViewController.h
//  Fitivate
//
//  Created by Rayden Lee on 10/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)didTapLogin:(id)sender;

@end
