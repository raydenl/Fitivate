//
//  ITimelineEvent.h
//  Fitivate
//
//  Created by Rayden Lee on 14/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ITimelineEvent <NSObject>

@required
//add required here
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) UIImage *profilePhoto;
@property (strong, nonatomic) NSDate *timestamp;
@property (strong, nonatomic) NSString *timestampString;
@property (strong, nonatomic) NSString *eventText;

@optional
// add optional here

@end
