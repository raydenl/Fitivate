//
//  FriendTableViewCell.h
//  Fitivate
//
//  Created by Rayden Lee on 16/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
