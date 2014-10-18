//
//  LastEventTimestampResult.m
//  Fitivate
//
//  Created by Rayden Lee on 14/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "LastEventTimestampResult.h"

NSString *const LastEventTimestampResultKey = @"LastEventTimestampResultKey";

@implementation LastEventTimestampResult

@synthesize result;

- (id) initWithTimestamp:(NSDate *)date
{
    self.result = @{ LastEventTimestampResultKey : (date?:[NSNull null])
                     };
    
    return self;
}

@end
