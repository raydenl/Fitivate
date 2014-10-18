//
//  SignupValidator
//  Fitivate
//
//  Created by Rayden Lee on 11/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "SignupValidator.h"

@implementation SignupValidator {
    NSObject *_delegate;
}

- (id) initWithDelegate:(NSObject *)delegate
{
    _delegate = delegate;
    
    return self;
}

- (BOOL) validate:(NSString *)email username:(NSString *)username password:(NSString *)password
{
    if (![self validateEmail: email])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:InvalidEntryTitle message:@"Email not valid." delegate:_delegate cancelButtonTitle:OkButtonName otherButtonTitles:nil];
        [alert show];
        return false;
    }
    
    if (username.length < 4)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:InvalidEntryTitle message:@"Username must be at least 4 characters long." delegate:_delegate cancelButtonTitle:OkButtonName otherButtonTitles:nil];
        [alert show];
        return false;
    }
    
    if (![self validateUsername: username])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:InvalidEntryTitle message:@"Usernames can only contain letters (Aa-Zz), numbers (0-9), dashes (-) and underscores (_)." delegate:_delegate cancelButtonTitle:OkButtonName otherButtonTitles:nil];
        [alert show];
        return false;
    }
    
    if (password.length < 6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:InvalidEntryTitle message:@"Password must be at least 6 characters long." delegate:_delegate cancelButtonTitle:OkButtonName otherButtonTitles:nil];
        [alert show];
        return false;
    }
    
    return true;
}

- (BOOL) validateEmail: (NSString *) candidate
{
    NSString *regex = @"^.+@[^@]+\\.[^@]{2,}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [test evaluateWithObject:candidate];
}

- (BOOL) validateUsername: (NSString *) candidate
{
    NSString *regex = @"^[a-zA-Z0-9_-]+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [test evaluateWithObject:candidate];
}
@end
