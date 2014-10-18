//
//  UserRequestHandler.h
//  Fitivate
//
//  Created by Rayden Lee on 17/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRequestHandler : NSObject

-(void) createUserWithEmail:(NSString *)email username:(NSString *)username password:(NSString *)password;
-(void) loginUserWithUsername:(NSString *)username password:(NSString *)password;
-(void) logoutUser;
-(void) fetchUserDetails;
-(void) saveUserDetailsWithFirstName:(NSString *)firstName lastName:(NSString *)lastName dateOfBirth:(NSDate *)dateOfBirth;

+(BOOL) isAuthenticatedWithUsername:(NSString *)username;

@end
