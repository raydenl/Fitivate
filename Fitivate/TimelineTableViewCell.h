//
//  TimelineTableViewCell.h
//  Fitivate
//
//  Created by Rayden Lee on 8/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;

@end
