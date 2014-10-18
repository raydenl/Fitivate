//
//  TimelineEvent.m
//  Fitivate
//
//  Created by Rayden Lee on 17/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "TimelineEvent.h"

@implementation TimelineEvent

@synthesize displayName;
@synthesize profilePhoto;
@synthesize timestamp;
@synthesize timestampString;
@synthesize eventText;

// timestamp property getter
- (NSString *) timestampString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSDate *today = [NSDate date];
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400]; //86400 is the seconds in a day
    
    NSTimeInterval difference = [today timeIntervalSinceDate:self.timestamp];
    
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * refDateString = [[self.timestamp description] substringToIndex:10];
    
    int second = 1;
    int minute = second*60;
    int hour = minute*60;
    int day = hour*24;
    // interval can be before (negative) or after (positive)
    int num = abs(difference);
    
    if (num < 20)
    {
        return @"A few seconds ago.";
    }
    if (num < minute)
    {
        return @"Less than a minute ago.";
    }
    if (num < hour)
    {
        int actualMinute = num/minute;
        return [NSString stringWithFormat:@"About %d %@ ago.", actualMinute, actualMinute > 1 ? @"minutes" : @"minute"];
    }
    if ([refDateString isEqualToString:yesterdayString])
    {
        [dateFormatter setDateFormat:@"h:mm:ss aaa"];
        
        return [NSString stringWithFormat:@"Yesterday %@", [dateFormatter stringFromDate:self.timestamp]];
    }
    if (num < day)
    {
        int actualHour = num/hour;
        return [NSString stringWithFormat:@"About %d %@ ago.", actualHour, actualHour > 1 ? @"hours" : @"hour"];
    }
    
    [dateFormatter setDateFormat:@"d/MM/yyyy h:mm:ss aaa"];
    
    return [dateFormatter stringFromDate:self.timestamp];
}

@end
