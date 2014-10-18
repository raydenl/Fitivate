//
//  FriendRequestHandler.m
//  Fitivate
//
//  Created by Rayden Lee on 18/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "FriendRequestHandler.h"

@implementation FriendRequestHandler

- (void) cancelFriendRequestWithObject:(PFObject *)object
{
    object[@"friendRequestCancelledAt"] = [NSDate date];
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:FriendRequestCancelledSuccessEvent object:nil];
        }
        else
        {
            NSLog(@"%@", error);
            [Helpers postErrorNotificationWithErrorMessage:@"Failed to cancel friend request." eventName:FriendRequestCancelledFailureEvent];
        }
    }];
}

- (void) acceptFriendRequestWithObject:(PFObject *)object
{
    object[@"relationshipConfirmedAt"] = [NSDate date];
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:FriendRequestCancelledSuccessEvent object:nil];
        }
        else
        {
            NSLog(@"%@", error);
            [Helpers postErrorNotificationWithErrorMessage:@"Failed to accept friend request." eventName:FriendRequestCancelledFailureEvent];
        }
    }];
}

- (void) ignoreFriendRequestWithObject:(PFObject *)object
{
    object[@"friendRequestIgnoredAt"] = [NSDate date];
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:FriendRequestCancelledSuccessEvent object:nil];
        }
        else
        {
            NSLog(@"%@", error);
            [Helpers postErrorNotificationWithErrorMessage:@"Failed to ignore friend request." eventName:FriendRequestCancelledFailureEvent];
        }
    }];
}

- (void) deleteFriendRequestWithObject:(PFObject *)object
{
    object[@"deletedAt"] = [NSDate date];
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:FriendRequestCancelledSuccessEvent object:nil];
        }
        else
        {
            NSLog(@"%@", error);
            [Helpers postErrorNotificationWithErrorMessage:@"Failed to delete friend request." eventName:FriendRequestCancelledFailureEvent];
        }
    }];
}

- (void) addFriendWithCandidate:(NSString *)candidate existingFriendsUsernames:(NSArray *)existingFriendsUsernames
{
    PFQuery *usernameQuery = [PFUser query];
    [usernameQuery whereKey:@"username" equalTo:candidate];
    
    PFQuery *emailQuery = [PFUser query];
    [emailQuery whereKey:@"email" equalTo:candidate];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[usernameQuery,emailQuery]];
    //[query whereKey:@"username" notEqualTo:[[PFUser currentUser] username]];
    //[query whereKey:@"username" notContainedIn:existingFriendsUsernames];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *friendCandidateObjects, NSError *error) {
        if (!error)
        {
            NSLog(@"Retrieved friend candidate object count: %lu", (unsigned long)friendCandidateObjects.count);
            
            // if we have friend candidates
            if (friendCandidateObjects.count > 0)
            {
                // get the first friend candidate
                PFUser *friendCandidate = [friendCandidateObjects firstObject];
                
                // check to see if the friend candidate is yourself
                if ([friendCandidate.username isEqualToString:[[PFUser currentUser] username]])
                {
                    NSLog(@"Candidate is yourself.");
                    [[NSNotificationCenter defaultCenter] postNotificationName:AddFriendIsYourselfEvent object:nil];
                }
                else
                {
                    // check to see if the friend candidate is already a friend
                    if ([self userAlreadyFriend:friendCandidate existingFriendsUsernames:existingFriendsUsernames])
                    {
                        NSLog(@"Candidate is already friend.");
                        [[NSNotificationCenter defaultCenter] postNotificationName:AddFriendAlreadyFriendEvent object:nil];
                    }
                    else
                    {
                        NSLog(@"Add friend candidate.");
                        [self addFriend:friendCandidate];
                    }
                }
            }
            else
            {
                NSLog(@"No friend candidates found.");
                [[NSNotificationCenter defaultCenter] postNotificationName:AddFriendNotFoundEvent object:nil];
            }
        }
        else
        {
            NSLog(@"%@", error);
            [Helpers postErrorNotificationWithErrorMessage:@"Failed to add friend." eventName:AddFriendFailureEvent];
        }
    }];
}

- (BOOL) userAlreadyFriend:(PFUser *)user existingFriendsUsernames:(NSArray *)existingFriendsUsernames
{
    return ([existingFriendsUsernames containsObject:user.username]) ? true : false;
}

- (void) addFriend:(PFUser *)friendCandidate
{
    // we now need to check to see if there is already an existing (cancelled/ignored) relationship
    // between this user and the friend candidate
    PFQuery *exitingRelationshipQuery = [PFQuery queryWithClassName:UserFriend];
    [exitingRelationshipQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [exitingRelationshipQuery whereKey:@"friend" equalTo:friendCandidate];
    
    [exitingRelationshipQuery findObjectsInBackgroundWithBlock:^(NSArray *relationshipObjects, NSError *error) {
        if (!error)
        {
            NSLog(@"Retrieved relationship object count: %lu", (unsigned long)relationshipObjects.count);
            
            if (relationshipObjects > 0)
            {
                // get the first relationship
                PFObject *relationship = [relationshipObjects firstObject];
                [relationship removeObjectForKey:@"friendRequestCancelledAt"];
                [relationship removeObjectForKey:@"deletedAt"];
                [self saveFriend:relationship];
            }
            else
            {
                // no existing relationship exists, so create a new one
                PFObject *userFriend = [PFObject objectWithClassName:UserFriend];
                userFriend[@"user"] = [PFUser currentUser];
                userFriend[@"friend"] = friendCandidate;
                [self saveFriend:userFriend];
            }
        }
        else
        {
            NSLog(@"%@", error);
            [Helpers postErrorNotificationWithErrorMessage:@"Failed to add friend." eventName:AddFriendFailureEvent];
        }
    }];
}

- (void) saveFriend:(PFObject *)object
{
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            NSLog(@"Save successful");
            [[NSNotificationCenter defaultCenter] postNotificationName:AddFriendSuccessEvent object:nil];
        }
        else
        {
            NSLog(@"%@", error);
            [Helpers postErrorNotificationWithErrorMessage:@"Failed to add friend." eventName:AddFriendFailureEvent];
        }
    }];
}

@end
