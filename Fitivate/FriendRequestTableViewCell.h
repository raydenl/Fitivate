//
//  FriendRequestTableViewCell.h
//  Fitivate
//
//  Created by Rayden Lee on 16/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendRequestTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *ignoreButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
