//
//  TimelineEvent.m
//  Fitivate
//
//  Created by Rayden Lee on 11/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "NumericMetricTimelineEvent.h"

@implementation NumericMetricTimelineEvent

-(id)initWithUser:(EventUser *)user metric:(EventMetric *)metric createdAt:(NSDate *)createdAt
{
    self.displayName = user.getDisplayName;
    self.profilePhoto = user.getProfilePhoto;
    self.timestamp = createdAt;
    self.eventText = [self getEventTextWithUser:user metric:metric];
    
    return self;
}

- (NSString *) getEventTextWithUser:(EventUser *)user metric:(EventMetric *)metric
{
    if (user.isCurrentUser)
    {
        return [NSString stringWithFormat:@"Updated measurement %@ to %@.",
                metric.metricName,
                metric.getMetricString];
    }
    else
    {
        return [NSString stringWithFormat:@"Updated measurement %@.",
                metric.metricName];
    }
}

@end
