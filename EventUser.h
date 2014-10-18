//
//  EventUser.h
//  Fitivate
//
//  Created by Rayden Lee on 17/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventUser : NSObject

@property (assign, nonatomic, readonly) BOOL isCurrentUser;

-(id) initWithUsername:(NSString *)username firstName:(NSString *)firstName lastName:(NSString *)lastName photo:(UIImage *)photo isCurrentUser:(BOOL)isCurrentUser;

-(NSString *) getDisplayName;

-(UIImage *) getProfilePhoto;

@end
