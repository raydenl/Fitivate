//
//  TimelineRequestHandler.m
//  Fitivate
//
//  Created by Rayden Lee on 8/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "TimelineRequestHandler.h"
#import "NumericMetricTimelineEvent.h"
#import "TimelineEventsResult.h"
#import "LastEventTimestampResult.h"
#import "UserRequestHandler.h"

@implementation TimelineRequestHandler

-(void) fetchNumericMetricLastEventTimestamp
{
    PFQuery *query = [self getNumericMetricQueryWithIncludes:false];
    [query setLimit:1];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            NSDate *timestamp;
            if ([objects count] > 0)
            {
                // get the first item, even though there should one
                timestamp = [[objects objectAtIndex:0] createdAt];
            }
            
            LastEventTimestampResult *lastEventTimestampResult = [[LastEventTimestampResult alloc] initWithTimestamp:timestamp];
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchLastEventTimestampSuccessEvent object:nil userInfo:lastEventTimestampResult.result];
        }
        else
        {
            NSLog(@"%@", error);
            [Helpers postErrorNotificationWithErrorMessage:@"" eventName:FetchLastEventTimestampFailureEvent];
        }
    }];
}

-(PFQuery *) getNumericMetricQueryWithIncludes:(BOOL)includes
{
    // all confirmed friends
    PFQuery *confirmedFriendQuery = [PFQuery queryWithClassName:UserFriend];
    [confirmedFriendQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [confirmedFriendQuery whereKeyDoesNotExist:@"friendRequestCancelledAt"];
    [confirmedFriendQuery whereKeyDoesNotExist:@"deletedAt"];
    [confirmedFriendQuery whereKeyExists:@"relationshipConfirmedAt"];
    
    // get numeric metric updates for current user
    PFQuery *numericMetricUpdateQuery = [PFQuery queryWithClassName:UserNumericMetric];
    [numericMetricUpdateQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    
    // get numeric metric updates for all confirmed friends
    PFQuery *friendNumericMetricUpdateQuery = [PFQuery queryWithClassName:UserNumericMetric];
    [friendNumericMetricUpdateQuery whereKey:@"user" matchesKey:@"friend" inQuery:confirmedFriendQuery];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[numericMetricUpdateQuery,friendNumericMetricUpdateQuery]];
    if (includes)
    {
        [query includeKey:@"user"];
        [query includeKey:@"metricWithUnit.metric"];
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

-(void) fetchNumericMetricEventsWithLastEventTimestamp:(NSDate *)timestamp
{
    PFQuery *query = [self getNumericMetricQueryWithIncludes:true];
    if ([Helpers isSetWithObject:timestamp])
    {
        [query whereKey:@"createdAt" greaterThan:timestamp];
    }
    // limit returned results
    [query setLimit:50];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            NSMutableArray *events = [NSMutableArray new];
            
            id object;
            for(object in objects)
            {
                PFObject *userNumericMetric = (PFObject *)object;
                
                PFUser *user = userNumericMetric[@"user"];
                
//                PFFile *imageFile = [user objectForKey:@"image"];
                
//                if (imageFile != nil)
//                {
//                    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//                        UIImage *image = [UIImage imageWithData:data];
//                        
//                        TimelineEvent *timelineEvent = [[TimelineEvent alloc] initWithName:[self getNameWithUser:user] image:image eventCreatedAt:[userNumericMetric createdAt] event:[self getEventWithUserNumericMetric:userNumericMetric]];
//                        
//                        [events addObject:timelineEvent];
//                    }];
//                }
//                else
//                {
                    PFObject *metricUnit = [userNumericMetric objectForKey:@"metricWithUnit"];
                    PFObject *metric = [metricUnit objectForKey:@"metric"];
                
                EventUser *eventUser = [[EventUser alloc] initWithUsername:user.username firstName:user[@"firstName"] lastName:user[@"lastName"] photo:nil isCurrentUser:[UserRequestHandler isAuthenticatedWithUsername:user.username]];
                
                EventMetric *eventMetric = [[EventMetric alloc] initWithName:metric[@"name"] value:userNumericMetric[@"value"] unit:metricUnit[@"unit"]];
                
                NumericMetricTimelineEvent *timelineEvent = [[NumericMetricTimelineEvent alloc] initWithUser:eventUser metric:eventMetric createdAt:[userNumericMetric createdAt]];
                
                [events addObject:timelineEvent];
//                }
            }
            
            TimelineEventsResult *timelineEventsResult = [[TimelineEventsResult alloc] initWithEventsArray:events];
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchNumericMetricEventsSuccessEvent object:nil userInfo:timelineEventsResult.result];
        }
        else
        {
            NSLog(@"%@", error);
            [Helpers postErrorNotificationWithErrorMessage:@"" eventName:FetchNumericMetricEventsFailureEvent];
        }
    }];
}

@end
