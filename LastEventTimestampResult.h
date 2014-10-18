//
//  LastEventTimestampResult.h
//  Fitivate
//
//  Created by Rayden Lee on 14/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEventResult.h"

extern NSString *const LastEventTimestampResultKey;

@interface LastEventTimestampResult : NSObject <IEventResult>

- (id) initWithTimestamp:(NSDate *)date;

@end
