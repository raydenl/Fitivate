//
//  UserDetailsResult.h
//  Fitivate
//
//  Created by Rayden Lee on 25/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEventResult.h"

extern NSString *const UserDetailsResultFirstNameKey;
extern NSString *const UserDetailsResultLastNameKey;
extern NSString *const UserDetailsResultDateOfBirthKey;

@interface UserDetailsResult : NSObject <IEventResult>

- (id) initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName dateOfBirth:(NSDate *)dateOfBirth;

@end
