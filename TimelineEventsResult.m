//
//  TimelineEventsResult.m
//  Fitivate
//
//  Created by Rayden Lee on 11/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "TimelineEventsResult.h"

NSString *const TimelineEventsResultEventsArrayKey = @"TimelineEventsResultEventsArrayKey";

@implementation TimelineEventsResult

@synthesize result;

- (id) initWithEventsArray:(NSArray *)eventsArray
{
    self.result = @{ TimelineEventsResultEventsArrayKey : eventsArray
                     };
    
    return self;
}

@end
