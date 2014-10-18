//
//  Metric.h
//  Fitivate
//
//  Created by Rayden Lee on 17/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventMetric : NSObject

@property (strong, nonatomic, readonly) NSString *metricName;

-(id)initWithName:(NSString *)name value:(NSNumber *)value unit:(NSString *)unit;

-(NSString *) getMetricString;

@end
