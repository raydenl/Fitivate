//
//  Constants.h
//  Fitivate
//
//  Created by Rayden Lee on 3/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

// storyboard names
extern NSString *const PhoneStoryboardName;

// dialog button caption names
extern NSString *const OkButtonName;
extern NSString *const CancelButtonName;

// dialog titles
extern NSString *const InvalidEntryTitle;
extern NSString *const ErrorTitle;
extern NSString *const ConfirmDeleteTitle;

// segues
extern NSString *const SplashToLogin;
extern NSString *const SplashToSignup;
extern NSString *const SplashToMain;
extern NSString *const LoginToMain;
extern NSString *const SignupToMain;

// custom parse class names
extern NSString *const UserNumericMetric;
extern NSString *const Metric;
extern NSString *const MetricUnit;
//extern NSString *const User;
extern NSString *const UserFriend;
extern NSString *const Activity;
extern NSString *const UserActivity;

// misc
extern int const DatePickerHeight;
extern double const TimelineTimeIntervalSeconds;

@interface Constants : NSObject

@end
