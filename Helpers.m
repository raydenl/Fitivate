//
//  Helpers.m
//  Fitivate
//
//  Created by Rayden Lee on 11/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

+(NSString *) getErrorMessageWithArray:(NSArray *)array
{
    if (array.count == 1)
    {
        return [array firstObject];
    }
    
    NSMutableString *errorMessage;
    for (NSString *message in array)
    {
        [errorMessage appendString:[NSString stringWithFormat:@"%C %@\n", 0x2022, message]];
    }
    
    return errorMessage;
}

+(BOOL) isSetWithNumber:(NSNumber *)number
{
    if (number == nil || [number isEqual:[NSNull null]] || [number isEqualToNumber:[NSDecimalNumber notANumber]])
    {
        return false;
    }
    
    return true;
}

+(BOOL) isSetWithObject:(NSObject *)object
{
    if (object == nil || [object isEqual:[NSNull null]])
    {
        return false;
    }
    
    return true;
}

+(BOOL) isNotEmptyWithString:(NSString *)string
{
    string = [self trimWithString:string];
    
    if ([string isEqualToString:@""])
    {
        return false;
    }
    
    return true;
}

+(NSString *) trimWithString:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return string;
}

+(void) postErrorNotificationWithErrorMessage:(NSString *)errorMessage eventName:(NSString *)eventName
{
    ErrorResult *errorResult = [[ErrorResult alloc] initWithErrorMessage:errorMessage];
    [[NSNotificationCenter defaultCenter] postNotificationName:eventName object:nil userInfo:errorResult.result];
}

@end
