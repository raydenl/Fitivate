//
//  MetricRequestHandler.h
//  Fitivate
//
//  Created by Rayden Lee on 22/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetricRequestHandler : NSObject

-(void) fetchUserMetrics;
-(void) fetchAllMetrics;
-(void) saveNumericMetricWithExistingValues:(NSDictionary *)existingUserNumericMetricValues newValue:(NSNumber *)newValue metricUnitId:(NSString *)metricUnitId;

@end
