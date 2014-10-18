//
//  ActivityRequestHandler.h
//  Fitivate
//
//  Created by Rayden Lee on 19/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityRequestHandler : NSObject

-(void) fetchAllActivities;
-(void) saveActivityWithActivityId:(NSString *)activityId minutesPerformed:(NSNumber *)minutesPerformed caloriesBurned:(NSNumber *)caloriesBurned;

@end
