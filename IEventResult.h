//
//  IEventResult.h
//  Fitivate
//
//  Created by Rayden Lee on 24/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IEventResult <NSObject>

@required
//add required here
@property (strong, nonatomic) NSDictionary *result;

@optional
// add optional here

@end
