//
//  ListFriendsViewController.h
//  Fitivate
//
//  Created by Rayden Lee on 13/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListFriendsViewController : PFQueryTableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addFriendsNavButton;

- (IBAction)didTapAddFriends:(id)sender;

@end
