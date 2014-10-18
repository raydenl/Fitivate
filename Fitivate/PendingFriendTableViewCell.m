//
//  PendingFriendTableViewCell.m
//  Fitivate
//
//  Created by Rayden Lee on 16/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "PendingFriendTableViewCell.h"

@implementation PendingFriendTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
