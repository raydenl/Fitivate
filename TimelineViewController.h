//
//  TimelineViewController.h
//  Fitivate
//
//  Created by Rayden Lee on 8/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIButton *enterMeasurementButton;
@property (weak, nonatomic) IBOutlet UIButton *enterActivityButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;

- (IBAction)didTapEnterMeasurement:(id)sender;
- (IBAction)didTapEnterActivity:(id)sender;
- (IBAction)didTapLogout:(id)sender;

@end
