//
//  ErrorResult.m
//  Fitivate
//
//  Created by Rayden Lee on 18/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "ErrorResult.h"

NSString *const ErrorResultKey = @"ErrorResultKey";

@implementation ErrorResult

@synthesize result;

- (id) initWithErrorMessage:(NSString *)errorMessage
{
    self.result = @{ ErrorResultKey : errorMessage
                     };
    
    return self;
}

@end
