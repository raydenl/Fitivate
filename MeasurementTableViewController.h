//
//  MeasurementTableViewController.h
//  Fitivate
//
//  Created by Rayden Lee on 10/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeasurementTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)didTapSave:(id)sender;

@end
