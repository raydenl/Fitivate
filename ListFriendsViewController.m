//
//  ListFriendsViewController.m
//  Fitivate
//
//  Created by Rayden Lee on 13/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "ListFriendsViewController.h"
#import "AddFriendsViewController.h"
#import "FriendRequestTableViewCell.h"
#import "PendingFriendTableViewCell.h"
#import "FriendTableViewCell.h"
#import "FriendRequestHandler.h"

@interface ListFriendsViewController ()

@end

@implementation ListFriendsViewController {
    FriendRequestHandler *_friendRequestHandler;
    NSMutableArray *_currentFriendsUsernames;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        _friendRequestHandler = [[FriendRequestHandler alloc] init];
        _currentFriendsUsernames = [[NSMutableArray alloc] init];
        
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"UserFriend";
        
        // The key of the PFObject to display in the label of the default cell style
        //self.textKey = @"username";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupEvents];
    
    //[self.navigationController setToolbarHidden:YES animated:YES];
    
    [self loadObjects];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self removeEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(friendRequestSuccess:)
                                                 name:FriendRequestCancelledSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(friendRequestFailure:)
                                                 name:FriendRequestCancelledFailureEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(friendRequestSuccess:)
                                                 name:FriendRequestAcceptedSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(friendRequestFailure:)
                                                 name:FriendRequestAcceptedFailureEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(friendRequestSuccess:)
                                                 name:FriendRequestIgnoredSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(friendRequestFailure:)
                                                 name:FriendRequestIgnoredFailureEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(friendRequestSuccess:)
                                                 name:FriendRequestDeletedSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(friendRequestFailure:)
                                                 name:FriendRequestDeletedFailureEvent
                                               object:nil];
}

- (void)removeEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:FriendRequestCancelledSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:FriendRequestCancelledFailureEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:FriendRequestAcceptedSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:FriendRequestAcceptedFailureEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:FriendRequestIgnoredSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:FriendRequestIgnoredFailureEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:FriendRequestDeletedSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:FriendRequestDeletedFailureEvent
                                               object:nil];
}

- (void)friendRequestSuccess:(NSNotification *)notification
{
    // remove all friends, and then reload to add any remaining back
    [_currentFriendsUsernames removeAllObjects];
    [self loadObjects];
}

- (void)friendRequestFailure:(NSNotification *)notification
{
    NSString *errorMessage = [[notification userInfo] objectForKey:ErrorResultKey];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ErrorTitle message:errorMessage delegate:self cancelButtonTitle:OkButtonName otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSString *segueIdentifier = [segue identifier];
    
    if ([segueIdentifier isEqualToString:@"listFriendsToAddFriends"])
    {
        AddFriendsViewController *addFriendsViewController = [segue destinationViewController];
       
        addFriendsViewController.currentFriendsUsernames = _currentFriendsUsernames;
        
        // create a custom back button item, and set it
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        [self.navigationItem setBackBarButtonItem:backBarButtonItem];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable
{
    // all friends, regardless of whether the relationship is confirmed or not
    PFQuery *friendQuery = [PFQuery queryWithClassName:self.parseClassName];
    [friendQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [friendQuery whereKeyDoesNotExist:@"friendRequestCancelledAt"];
    [friendQuery whereKeyDoesNotExist:@"deletedAt"];
    
    // all users that have requested to add you as a friend
    PFQuery *friendRequestQuery = [PFQuery queryWithClassName:self.parseClassName];
    [friendRequestQuery whereKey:@"friend" equalTo:[PFUser currentUser]];
    [friendRequestQuery whereKeyDoesNotExist:@"relationshipConfirmedAt"];
    [friendRequestQuery whereKeyDoesNotExist:@"friendRequestIgnoredAt"];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[friendQuery,friendRequestQuery]];
    [query includeKey:@"user"];
    [query includeKey:@"friend"];
    
    //[query orderByAscending:@"friend"];
    
    return query;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    //return 0;
//    //if (tableView == self.tableView)
//    //{
//        //if (tableView == self.searchDisplayController.searchResultsTableView) {
//        //return self.objects.count;
//    //}
//    //else
//    //{
//        //return self.searchResults.count;
//        //return 0;
//    //}
//    
//    //return 1;
//}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *friendIdentifier = @"friendCell";
    static NSString *pendingFriendIdentifier = @"pendingFriendCell";
    static NSString *friendRequestIdentifier = @"friendRequestCell";
    
    PFUser *currentUser = [PFUser currentUser];
    PFUser *user = [object objectForKey:@"user"];
    PFUser *friend = [object objectForKey:@"friend"];
    
    if ([object objectForKey:@"relationshipConfirmedAt"] == nil)
    {
        // you are the user, so get the friend you have requested to add
        if ([user.objectId isEqualToString:currentUser.objectId])
        {
            PendingFriendTableViewCell *cell = (PendingFriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:pendingFriendIdentifier];
            if (cell == nil) {
                cell = [[PendingFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pendingFriendIdentifier];
            }
            
            cell.titleLabel.text = friend.username;
            [_currentFriendsUsernames addObject:friend.username];
            cell.subtitleLabel.text =@"Pending Friend Request";
            cell.cancelButton.tag = indexPath.row;
            [cell.cancelButton addTarget:self action:@selector(didTapCancel:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        // you are the friend, so you want the user who is requesting to add you
        else
        {
            FriendRequestTableViewCell *cell = (FriendRequestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:friendRequestIdentifier];
            if (cell == nil) {
                cell = [[FriendRequestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friendRequestIdentifier];
            }
            
            cell.titleLabel.text = user.username;
            cell.subtitleLabel.text = @"New Friend Request";
            cell.acceptButton.tag = indexPath.row;
            [cell.acceptButton addTarget:self action:@selector(didTapAccept:) forControlEvents:UIControlEventTouchUpInside];
            cell.ignoreButton.tag = indexPath.row;
            [cell.ignoreButton addTarget:self action:@selector(didTapIgnore:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
    }
    else
    {
        FriendTableViewCell *cell = (FriendTableViewCell *)[tableView dequeueReusableCellWithIdentifier:friendIdentifier];
        if (cell == nil) {
            cell = [[FriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friendIdentifier];
        }
        
        cell.titleLabel.text = friend.username;
        [_currentFriendsUsernames addObject:friend.username];
        [cell.deleteButton addTarget:self action:@selector(didTapDelete:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    return nil;
}

- (void)didTapCancel:(id)sender
{
    // get the button
    UIButton *button = (UIButton *)sender;
    
    PFObject *userFriend = self.objects[button.tag];
    
    [_friendRequestHandler cancelFriendRequestWithObject:userFriend];
}

- (void)didTapAccept:(id)sender
{
    // get the button
    UIButton *button = (UIButton *)sender;
    
    PFObject *userFriend = self.objects[button.tag];
    
    [_friendRequestHandler acceptFriendRequestWithObject:userFriend];
}

- (void)didTapIgnore:(id)sender
{
    // get the button
    UIButton *button = (UIButton *)sender;
    
    PFObject *userFriend = self.objects[button.tag];
    
    [_friendRequestHandler ignoreFriendRequestWithObject:userFriend];
}

- (void)didTapDelete:(id)sender
{
    UIAlertViewWithBlock *alert = [[UIAlertViewWithBlock alloc] initWithTitle:ConfirmDeleteTitle message:@"Are you sure you want to delete this Fiti-mate?" cancelButtonTitle:CancelButtonName otherButtonTitles:OkButtonName, nil];
    [alert showWithBlock:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
        if (didCancel)
        {
            return;
        }
        
        // get the button
        UIButton *button = (UIButton *)sender;
        
        PFObject *userFriend = self.objects[button.tag];
        
        [_friendRequestHandler deleteFriendRequestWithObject:userFriend];
    }];
}

/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */


#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (IBAction)didTapAddFriends:(id)sender
{
    [self performSegueWithIdentifier:@"listFriendsToAddFriends" sender:self];
}
@end
