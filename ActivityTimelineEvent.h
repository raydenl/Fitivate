//
//  ActivityTimelineEvent.h
//  Fitivate
//
//  Created by Rayden Lee on 17/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "TimelineEvent.h"
#import "EventUser.h"
#import "EventActivity.h"

@interface ActivityTimelineEvent : TimelineEvent

-(id)initWithUser:(EventUser *)user activity:(EventActivity *)activity createdAt:(NSDate *)createdAt;

@end
