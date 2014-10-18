//
//  ErrorResult.h
//  Fitivate
//
//  Created by Rayden Lee on 18/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEventResult.h"

extern NSString *const ErrorResultKey;

@interface ErrorResult : NSObject <IEventResult>

- (id) initWithErrorMessage:(NSString *)errorMessage;

@end
