//
//  User.h
//  Fitivate
//
//  Created by Rayden Lee on 19/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUser.h"

typedef NS_ENUM(NSInteger, Gender) {
    Male,
    Female
};

@interface User : NSObject <IUser>

@end
