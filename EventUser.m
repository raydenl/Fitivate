//
//  EventUser.m
//  Fitivate
//
//  Created by Rayden Lee on 17/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "EventUser.h"

@implementation EventUser
{
    NSString *_username;
    NSString *_firstName;
    NSString *_lastName;
    UIImage *_photo;
}

-(id) initWithUsername:(NSString *)username firstName:(NSString *)firstName lastName:(NSString *)lastName photo:(UIImage *)photo isCurrentUser:(BOOL)isCurrentUser
{
    _username = username;
    _firstName = firstName;
    _lastName = lastName;
    _photo = photo;
    _isCurrentUser = isCurrentUser;
    
    return self;
}

-(NSString *) getDisplayName
{
    if (![Helpers isSetWithObject:_firstName])
    {
        return _username;
    }
    
    if (![Helpers isSetWithObject:_lastName])
    {
        return _firstName;
    }
    
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}

-(UIImage *) getProfilePhoto
{
    return _photo;
}

@end
