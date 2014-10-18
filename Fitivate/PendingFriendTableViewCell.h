//
//  PendingFriendTableViewCell.h
//  Fitivate
//
//  Created by Rayden Lee on 16/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingFriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
