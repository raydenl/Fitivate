//
//  MeasurementTableViewCell.m
//  Fitivate
//
//  Created by Rayden Lee on 10/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "MeasurementTableViewCell.h"

@implementation MeasurementTableViewCell

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
