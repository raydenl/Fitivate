//
//  ProfileViewController.h
//  Fitivate
//
//  Created by Rayden Lee on 19/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBirthLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *datePickerTableViewCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateOfBirthDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender;
- (IBAction)didTapSave:(id)sender;

@end
