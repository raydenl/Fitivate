//
//  UserDetailsResult.m
//  Fitivate
//
//  Created by Rayden Lee on 25/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "UserDetailsResult.h"

NSString *const UserDetailsResultFirstNameKey = @"UserDetailsResultFirstNameKey";
NSString *const UserDetailsResultLastNameKey = @"UserDetailsResultLastNameKey";
NSString *const UserDetailsResultDateOfBirthKey = @"UserDetailsResultDateOfBirthKey";

@implementation UserDetailsResult

@synthesize result;

- (id) initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName dateOfBirth:(NSDate *)dateOfBirth
{
    self.result = @{ UserDetailsResultFirstNameKey : (firstName?:[NSNull null]),
                     UserDetailsResultLastNameKey : (lastName?:[NSNull null]),
                     UserDetailsResultDateOfBirthKey : (dateOfBirth?:[NSNull null])
                     };
    
    return self;
}

@end
