//
//  MeasurementTableViewCell.h
//  Fitivate
//
//  Created by Rayden Lee on 10/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeasurementTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameUnitLabel;
@property (weak, nonatomic) IBOutlet UITextField *measurementTextField;

@property (weak, nonatomic) NSString *metricUnitId;

@end
