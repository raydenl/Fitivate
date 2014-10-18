//
//  FriendRequestHandler.h
//  Fitivate
//
//  Created by Rayden Lee on 18/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendRequestHandler : NSObject

- (void) cancelFriendRequestWithObject:(PFObject *)object;
- (void) acceptFriendRequestWithObject:(PFObject *)object;
- (void) ignoreFriendRequestWithObject:(PFObject *)object;
- (void) deleteFriendRequestWithObject:(PFObject *)object;
- (void) addFriendWithCandidate:(NSString *)candidate existingFriendsUsernames:(NSArray *)existingFriendsUsernames;

@end
