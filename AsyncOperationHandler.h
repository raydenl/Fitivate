//
//  AsyncRequestHandler.h
//  Fitivate
//
//  Created by Rayden Lee on 25/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncOperationHandler : NSObject

- (void) addOperation:(void (^)())block;
- (void) handleResponse;
- (void) handleErrorResponse:(NSString *)errorMessage;
- (void) runWithFinallyBlock:(void (^)())finallyBlock successBlock:(void (^)())successBlock errorBlock:(void (^)(NSArray *errors))errorBlock;

@end
