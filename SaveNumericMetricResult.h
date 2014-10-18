//
//  SaveNumericMetricResult.h
//  Fitivate
//
//  Created by Rayden Lee on 24/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEventResult.h"

extern NSString *const SaveNumericMetricResultMetricUnitIdKey;
extern NSString *const SaveNumericMetricResultSavedUserNumericMetricKey;

@interface SaveNumericMetricResult : NSObject <IEventResult>

- (id) initWithMetricUnitId:(NSString *)metricUnitId savedUserNumericMetric:(PFObject *)savedUserNumericMetric;

@end
