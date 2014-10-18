//
//  ActivityRequestHandler.m
//  Fitivate
//
//  Created by Rayden Lee on 19/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "ActivityRequestHandler.h"

@implementation ActivityRequestHandler

//-(void) fetchUserActivityWithActivityId:(NSString *)activityId
//{
//    PFQuery *activityQuery = [PFQuery queryWithClassName:Activity];
//    [activityQuery whereKeyDoesNotExist:@"deletedAt"];
//    [activityQuery whereKey:@"objectId" equalTo:activityId];
//    
//    PFQuery *query = [PFQuery queryWithClassName:UserActivity];
//    [query whereKey:@"user" equalTo:[PFUser currentUser]];
//    [query whereKey:@"activity" matchesQuery:activityQuery];
//    [query whereKeyDoesNotExist:@"versionedAt"];
//    
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error)
//        {
//            NSLog(@"Retrieved user activity object count: %lu", (unsigned long)objects.count);
//            
//            // if we have user activities
//            if (objects.count > 0)
//            {
//                // get the first user activity
//                PFObject *userActivity = [objects firstObject];
//                
//                NSNumber *minutesPerformed = [userActivity objectForKey:@"minutesPerformed"];
//                NSNumber *caloriesBurned = [userActivity objectForKey:@"caloriesBurned"];
//                
//                ActivityMetricsResult *activityMetricsResult = [[ActivityMetricsResult alloc] initWithMinutesPerformed:minutesPerformed caloriesBurned:caloriesBurned];
//                [[NSNotificationCenter defaultCenter] postNotificationName:FetchUserActivitySuccessEvent object:nil userInfo:activityMetricsResult.result];
//            }
//            else
//            {
//                NSLog(@"No user activity data found.");
//                [[NSNotificationCenter defaultCenter] postNotificationName:FetchUserActivityNoDataEvent object:nil];
//            }
//        }
//        else
//        {
//            NSLog(@"%@", error);
//            [Helpers postErrorNotificationWithErrorMessage:@"Unable to retrieve user activity." eventName:FetchUserActivityFailureEvent];
//        }
//    }];
//}

-(void) fetchAllActivities
{
    PFQuery *activityQuery = [PFQuery queryWithClassName:Activity];
    [activityQuery whereKeyDoesNotExist:@"deletedAt"];
    
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            NSLog(@"Fetch all activities successful");
            
            id row;
            NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
            
            for (row in objects)
            {
                NSString *key = [row objectId];
                
                [mutableDictionary setObject:row forKey:key];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchAllActivitiesSuccessEvent object:nil userInfo:mutableDictionary];
        }
        else
        {
            NSLog(@"%@", error);
            [Helpers postErrorNotificationWithErrorMessage:@"Unable to retrieve all activities." eventName:FetchAllActivitiesFailureEvent];
        }
    }];
}

-(void) saveActivityWithActivityId:(NSString *)activityId minutesPerformed:(NSNumber *)minutesPerformed caloriesBurned:(NSNumber *)caloriesBurned
{
    // make sure we have at least one value to save
    if ([Helpers isSetWithNumber:minutesPerformed] || [Helpers isSetWithNumber:caloriesBurned])
    {
        //
        PFQuery *query = [PFQuery queryWithClassName:UserActivity];
        [query getObjectInBackgroundWithId:activityId block:^(PFObject *object, NSError *error) {
            if (!error)
            {
                if (object == nil)
                {
                    // save
                }
                else
                {
                    // version and save
                }
            }
            else
            {
                // error
            }
        }];
    }
    else
    {
         NSLog(@"nothing to save");
    }
}

@end
