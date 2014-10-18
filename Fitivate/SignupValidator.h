//
//  SignupValidator
//  Fitivate
//
//  Created by Rayden Lee on 11/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignupValidator : NSObject

- (id) initWithDelegate:(NSObject *)delegate;
- (BOOL) validate:(NSString *)email username:(NSString *)username password:(NSString *)password;

@end
