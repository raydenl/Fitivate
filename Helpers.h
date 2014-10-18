//
//  Helpers.h
//  Fitivate
//
//  Created by Rayden Lee on 11/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helpers : NSObject

+(NSString *) getErrorMessageWithArray:(NSArray *)array;
+(BOOL) isSetWithNumber:(NSNumber *)number;
+(BOOL) isSetWithObject:(NSObject *)object;
+(BOOL) isNotEmptyWithString:(NSString *)string;
+(NSString *) trimWithString:(NSString *)string;
+(void) postErrorNotificationWithErrorMessage:(NSString *)errorMessage eventName:(NSString *)eventName;

@end
