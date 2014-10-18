//
//  SaveNumericMetricResult.m
//  Fitivate
//
//  Created by Rayden Lee on 24/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "SaveNumericMetricResult.h"

NSString *const SaveNumericMetricResultMetricUnitIdKey = @"SaveNumericMetricResultMetricUnitIdKey";
NSString *const SaveNumericMetricResultSavedUserNumericMetricKey = @"SaveNumericMetricResultSavedUserNumericMetricKey";

@implementation SaveNumericMetricResult

@synthesize result;

- (id) initWithMetricUnitId:(NSString *)metricUnitId savedUserNumericMetric:(PFObject *)savedUserNumericMetric
{
    self.result = @{ SaveNumericMetricResultMetricUnitIdKey : metricUnitId,
                     SaveNumericMetricResultSavedUserNumericMetricKey : savedUserNumericMetric
                     };
    
    return self;
}

@end
