//
//  TimelineEvent.h
//  Fitivate
//
//  Created by Rayden Lee on 11/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "TimelineEvent.h"
#import "EventUser.h"
#import "EventMetric.h"

@interface NumericMetricTimelineEvent : TimelineEvent

-(id)initWithUser:(EventUser *)user metric:(EventMetric *)metric createdAt:(NSDate *)createdAt;

@end
