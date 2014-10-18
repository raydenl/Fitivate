//
//  Events.h
//  Fitivate
//
//  Created by Rayden Lee on 17/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UserCreatedSuccessEvent;
extern NSString *const UserCreatedFailureEvent;
extern NSString *const UserLoginSuccessEvent;
extern NSString *const UserLoginFailureEvent;
extern NSString *const UserLogoutSuccessEvent;
extern NSString *const UserLogoutFailureEvent;
extern NSString *const FriendRequestCancelledSuccessEvent;
extern NSString *const FriendRequestCancelledFailureEvent;
extern NSString *const FriendRequestAcceptedSuccessEvent;
extern NSString *const FriendRequestAcceptedFailureEvent;
extern NSString *const FriendRequestIgnoredSuccessEvent;
extern NSString *const FriendRequestIgnoredFailureEvent;
extern NSString *const FriendRequestDeletedSuccessEvent;
extern NSString *const FriendRequestDeletedFailureEvent;
extern NSString *const AddFriendSuccessEvent;
extern NSString *const AddFriendFailureEvent;
extern NSString *const AddFriendNotFoundEvent;
extern NSString *const AddFriendAlreadyFriendEvent;
extern NSString *const AddFriendIsYourselfEvent;
extern NSString *const FetchUserMetricsSuccessEvent;
extern NSString *const FetchUserMetricsFailureEvent;
extern NSString *const FetchAllMetricsSuccessEvent;
extern NSString *const FetchAllMetricsFailureEvent;
extern NSString *const SaveMetricSuccessEvent;
extern NSString *const SaveMetricFailureEvent;
extern NSString *const SaveMetricNothingToSaveEvent;
extern NSString *const FetchUserDetailsSuccessEvent;
extern NSString *const FetchUserDetailsFailureEvent;
extern NSString *const SaveUserDetailsSuccessEvent;
extern NSString *const SaveUserDetailsFailureEvent;
extern NSString *const FetchNumericMetricEventsSuccessEvent;
extern NSString *const FetchNumericMetricEventsFailureEvent;
extern NSString *const FetchLastEventTimestampSuccessEvent;
extern NSString *const FetchLastEventTimestampFailureEvent;
extern NSString *const FetchAllActivitiesSuccessEvent;
extern NSString *const FetchAllActivitiesFailureEvent;
extern NSString *const FetchUserActivitySuccessEvent;
extern NSString *const FetchUserActivityFailureEvent;
extern NSString *const FetchUserActivityNoDataEvent;

@interface Events : NSObject

@end
