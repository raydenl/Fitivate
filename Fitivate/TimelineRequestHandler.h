//
//  TimelineRequestHandler.h
//  Fitivate
//
//  Created by Rayden Lee on 8/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimelineRequestHandler : NSObject

-(void) fetchNumericMetricEventsWithLastEventTimestamp:(NSDate *)timestamp;
-(void) fetchNumericMetricLastEventTimestamp;

@end
