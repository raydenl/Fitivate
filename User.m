//
//  User.m
//  Fitivate
//
//  Created by Rayden Lee on 19/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "User.h"

@implementation User
{
    NSDate *_dateOfBirth;
    double _height;
    double _weight;
}

- (id) initWithDateOfBirth:(NSDate *)dateOfBirth height:(double)height weight:(double)weight
{
    if (self == [super init])
    {
        _dateOfBirth = dateOfBirth;
        _height = height;
        _weight = weight;
    }
    return self;
}

- (NSInteger) getAge
{
    NSDate *today = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:_dateOfBirth
                                       toDate:today
                                       options:0];
    return ageComponents.year;
}

- (double)getBodyMassIndex
{
    return _weight/sqrt(_height);
}

@end
