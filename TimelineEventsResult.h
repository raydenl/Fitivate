//
//  TimelineEventsResult.h
//  Fitivate
//
//  Created by Rayden Lee on 11/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEventResult.h"

extern NSString *const TimelineEventsResultEventsArrayKey;

@interface TimelineEventsResult : NSObject <IEventResult>

- (id) initWithEventsArray:(NSArray *)eventsArray;

@end
