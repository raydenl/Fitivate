//
//  ActivityTimelineEvent.m
//  Fitivate
//
//  Created by Rayden Lee on 17/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "ActivityTimelineEvent.h"

@implementation ActivityTimelineEvent

-(id)initWithUser:(EventUser *)user activity:(EventActivity *)activity createdAt:(NSDate *)createdAt
{
    self.displayName = user.getDisplayName;
    self.profilePhoto = user.getProfilePhoto;
    self.timestamp = createdAt;
    self.eventText = [self getEventTextWithUser:user activity:activity];
    
    return self;
}

- (NSString *) getEventTextWithUser:(EventUser *)user activity:(EventActivity *)activity
{
    if (user.isCurrentUser)
    {
        return [NSString stringWithFormat:@""];
    }
    else
    {
        return [NSString stringWithFormat:@""];
    }
}

@end
