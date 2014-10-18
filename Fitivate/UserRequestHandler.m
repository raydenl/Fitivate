//
//  UserRequestHandler.m
//  Fitivate
//
//  Created by Rayden Lee on 17/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "UserRequestHandler.h"
#import "UserDetailsResult.h"

@implementation UserRequestHandler

- (void) createUserWithEmail:(NSString *)email username:(NSString *)username password:(NSString *)password
{
    PFUser *newUser = [PFUser user];
    newUser.email = email;
    newUser.username = username;
    newUser.password = password;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (!error)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:UserCreatedSuccessEvent object:nil];
        }
        else
        {
            NSLog(@"%@", error);
            [Helpers postErrorNotificationWithErrorMessage:@"Failed to create user." eventName:UserCreatedFailureEvent];
        }
    }];
}

- (void) loginUserWithUsername:(NSString *)username password:(NSString *)password
{
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error)
    {
                                        if (!error)
                                        {
                                            if (user)
                                            {
                                                [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginSuccessEvent object:nil];
                                            }
                                            else
                                            {
                                                [Helpers postErrorNotificationWithErrorMessage:@"Failed to login user." eventName:UserLoginFailureEvent];
                                            }
                                        }
                                        else
                                        {
                                            NSLog(@"%@", error);
                                            [Helpers postErrorNotificationWithErrorMessage:@"Failed to login user." eventName:UserLoginFailureEvent];
                                        }
                                    }];
}

- (void) logoutUser
{
    @try
    {
        [PFUser logOut];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UserLogoutSuccessEvent object:nil];
    }
    @catch (NSException *ex)
    {
        NSLog(@"%@", ex.description);
        [Helpers postErrorNotificationWithErrorMessage:@"Failed to logout user." eventName:UserLogoutFailureEvent];
    }
}

- (void) fetchUserDetails
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error)
        {
            NSLog(@"Fetch user details successful");
            
            NSString *firstName = [object objectForKey:@"firstName"];
            NSString *lastName = [object objectForKey:@"lastName"];
            NSDate *dateOfBirth = [object objectForKey:@"dateOfBirth"];
            
            UserDetailsResult *userDetailsResult = [[UserDetailsResult alloc] initWithFirstName:firstName lastName:lastName dateOfBirth:dateOfBirth];
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchUserDetailsSuccessEvent object:nil userInfo:userDetailsResult.result];
        }
        else
        {
            NSLog(@"%@", error);
            [Helpers postErrorNotificationWithErrorMessage:@"Unable to retrieve user details." eventName:FetchUserDetailsFailureEvent];
        }
    }];

}

- (void) saveUserDetailsWithFirstName:(NSString *)firstName lastName:(NSString *)lastName dateOfBirth:(NSDate *)dateOfBirth
{
    PFUser *user = [PFUser currentUser];
    
    if ([Helpers isSetWithObject:firstName] && [Helpers isNotEmptyWithString:firstName])
    {
        user[@"firstName"] = [Helpers trimWithString:firstName];
    }
    else
    {
        [user removeObjectForKey:@"firstName"];
    }
    
    if ([Helpers isSetWithObject:lastName] && [Helpers isNotEmptyWithString:lastName])
    {
        user[@"lastName"] = [Helpers trimWithString:lastName];
    }
    else
    {
        [user removeObjectForKey:@"lastName"];
    }
    
    if ([Helpers isSetWithObject:dateOfBirth])
    {
        user[@"dateOfBirth"] = dateOfBirth;
    }
    else
    {
        [user removeObjectForKey:@"dateOfBirth"];
    }
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            NSLog(@"user details - save successful");
            [[NSNotificationCenter defaultCenter] postNotificationName:SaveUserDetailsSuccessEvent object:nil];
        }
        else
        {
            NSLog(@"%@", error);
            [Helpers postErrorNotificationWithErrorMessage:@"" eventName:SaveUserDetailsFailureEvent];
        }
    }];
}

+(BOOL) isAuthenticatedWithUsername:(NSString *)username
{
    return [[[PFUser currentUser] username] isEqualToString:username];
}

@end
