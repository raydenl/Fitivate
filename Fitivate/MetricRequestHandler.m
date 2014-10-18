//
//  MetricRequestHandler.m
//  Fitivate
//
//  Created by Rayden Lee on 22/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "MetricRequestHandler.h"
#import "SaveNumericMetricResult.h"

@implementation MetricRequestHandler

- (void) fetchUserMetrics
{
    PFQuery *query = [PFQuery queryWithClassName:UserNumericMetric];
    [query includeKey:@"metricWithUnit"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKeyDoesNotExist:@"versionedAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            NSLog(@"Fetch user metrics successful");
            
            id row;
            NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
            
            for (row in objects)
            {
                NSString *key = [[row objectForKey:@"metricWithUnit"] objectId];
                
                [mutableDictionary setObject:row forKey:key];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchUserMetricsSuccessEvent object:nil userInfo:mutableDictionary];
        }
        else
        {
            NSLog(@"%@", error);
            [Helpers postErrorNotificationWithErrorMessage:@"Unable to retrieve user metrics." eventName:FetchUserMetricsFailureEvent];
        }
    }];
}

- (void) fetchAllMetrics
{
    PFQuery *metricQuery = [PFQuery queryWithClassName:Metric];
    [metricQuery whereKeyDoesNotExist:@"deletedAt"];
    
    PFQuery *query = [PFQuery queryWithClassName:MetricUnit];
    [query includeKey:@"metric"];
    [query whereKey:@"metric" matchesQuery:metricQuery];
    [query whereKey:@"measurementSystem" equalTo:[[PFUser currentUser] objectForKey:@"preferredMeasurementSystem"]];
    [query whereKeyDoesNotExist:@"deletedAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            NSLog(@"Fetch all metrics successful");
            
            id row;
            NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
            
            for (row in objects)
            {
                NSString *key = [row objectId];
                
                [mutableDictionary setObject:row forKey:key];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchAllMetricsSuccessEvent object:nil userInfo:mutableDictionary];
        }
        else
        {
            NSLog(@"%@", error);
            [Helpers postErrorNotificationWithErrorMessage:@"Unable to retrieve all metrics." eventName:FetchAllMetricsFailureEvent];
        }
    }];
}

-(void) saveNumericMetricWithExistingValues:(NSDictionary *)existingUserNumericMetricValues newValue:(NSNumber *)newValue metricUnitId:(NSString *)metricUnitId
{
    if ([Helpers isSetWithNumber:newValue])
    {
        PFObject *userNumericMetric = [existingUserNumericMetricValues objectForKey:metricUnitId];
        
        if (userNumericMetric == nil)
        {
            [self saveWithNumericValue:newValue metricUnitId:metricUnitId];
        }
        else
        {
            [self versionAndSaveWithNumericValue:newValue existingUserNumericMetric:userNumericMetric metricUnitId:metricUnitId];
        }
    }
    else
    {
        NSLog(@"metric %@ - nothing to save", @"");
        [[NSNotificationCenter defaultCenter] postNotificationName:SaveMetricNothingToSaveEvent object:nil];
    }
}

- (void) saveWithNumericValue:(NSNumber *)value metricUnitId:(NSString *)metricUnitId
{
    PFObject *userNumericMetric = [PFObject objectWithClassName:UserNumericMetric];
    userNumericMetric[@"user"] = [PFUser currentUser];
    userNumericMetric[@"metricWithUnit"] = [PFObject objectWithoutDataWithClassName:MetricUnit objectId:metricUnitId];
    userNumericMetric[@"value"] = value;
    [userNumericMetric saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            NSLog(@"Save successful.");
            SaveNumericMetricResult *saveMetricResult = [[SaveNumericMetricResult alloc] initWithMetricUnitId:metricUnitId savedUserNumericMetric:userNumericMetric];
            [[NSNotificationCenter defaultCenter] postNotificationName:SaveMetricSuccessEvent object:nil userInfo:saveMetricResult.result];
        }
        else
        {
            NSLog(@"%@", error);
            [Helpers postErrorNotificationWithErrorMessage:@"" eventName:SaveMetricFailureEvent];
        }
    }];
}

- (void) versionAndSaveWithNumericValue:(NSNumber *)value existingUserNumericMetric:(PFObject *)existingUserNumericMetric metricUnitId:(NSString *)metricUnitId
{
    NSNumber *existingValue = [existingUserNumericMetric objectForKey:@"value"];
    
    if (![value isEqualToNumber:existingValue])
    {
        PFQuery *query = [PFQuery queryWithClassName:UserNumericMetric];
        [query getObjectInBackgroundWithId:existingUserNumericMetric.objectId block:^(PFObject *object, NSError *error) {
            if (!error)
            {
                object[@"versionedAt"] = [NSDate date];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error)
                    {
                        [self saveWithNumericValue:value metricUnitId:metricUnitId];
                    }
                    else
                    {
                        NSLog(@"%@", error);
                        [Helpers postErrorNotificationWithErrorMessage:@"" eventName:SaveMetricFailureEvent];
                    }
                }];
            }
            else
            {
                NSLog(@"%@", error);
                [Helpers postErrorNotificationWithErrorMessage:@"" eventName:SaveMetricFailureEvent];
            }
        }];
    }
    else
    {
        NSLog(@"metric %@ - nothing to save", @"");
        [[NSNotificationCenter defaultCenter] postNotificationName:SaveMetricNothingToSaveEvent object:nil];
    }
}

@end
