//
//  Metric.m
//  Fitivate
//
//  Created by Rayden Lee on 17/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "EventMetric.h"

@implementation EventMetric
{
    NSNumber *_value;
    NSString *_unit;
}

-(id) initWithName:(NSString *)name value:(NSNumber *)value unit:(NSString *)unit
{
    _metricName = name;
    _value = value;
    _unit = unit;
    
    return self;
}

-(NSString *) getMetricString
{
    return [NSString stringWithFormat:@"%g %@", [_value floatValue], _unit];
}

@end
