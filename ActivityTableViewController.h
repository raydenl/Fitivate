//
//  ActivityTableViewController.h
//  Fitivate
//
//  Created by Rayden Lee on 21/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDto.h"

@interface ActivityTableViewController : UITableViewController

@property (strong, nonatomic) ActivityDto *activityDto;

@property (weak, nonatomic) IBOutlet UITextField *minutesPerformedTextField;
@property (weak, nonatomic) IBOutlet UITextField *caloriesBurnedTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)didTapSave:(id)sender;

@end
