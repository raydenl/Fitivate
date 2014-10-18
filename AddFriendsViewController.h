//
//  AddFriendsViewController.h
//  Fitivate
//
//  Created by Rayden Lee on 14/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendsViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *currentFriendsUsernames;

@property (weak, nonatomic) IBOutlet UITextField *friendTextField;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

- (IBAction)didTapAddFriend:(id)sender;

@end
