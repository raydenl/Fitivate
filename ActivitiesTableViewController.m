//
//  ActivityTableViewController.m
//  Fitivate
//
//  Created by Rayden Lee on 10/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "ActivitiesTableViewController.h"
#import "ActivityRequestHandler.h"
#import "ActivityTableViewController.h"
#import "ActivityTableViewCell.h"

@interface ActivitiesTableViewController ()

@end

@implementation ActivitiesTableViewController
{
    ActivityRequestHandler *_activityRequestHandler;
    NSArray *_allActivities;
    NSArray *_searchResults;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Custom initialization
        _activityRequestHandler = [ActivityRequestHandler new];
        _allActivities = [NSArray new];
        _searchResults = [NSArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"ActivityTableViewController - viewDidAppear");
    
    [super viewDidAppear:animated];
    
    [self setupEvents];
    
    [_activityRequestHandler fetchAllActivities];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self removeEvents];
}

-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchAllActivitiesSuccess:)
                                                 name:FetchAllActivitiesSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchAllActivitiesFailure:)
                                                 name:FetchAllActivitiesFailureEvent
                                               object:nil];
}

- (void)removeEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FetchAllActivitiesSuccessEvent
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FetchAllActivitiesFailureEvent
                                                  object:nil];
}

- (void)fetchAllActivitiesSuccess:(NSNotification *)notification
{
    // assign the fetched activities
    _allActivities = [notification.userInfo allValues];
    
    [self.tableView reloadData];
}

- (void)fetchAllActivitiesFailure:(NSNotification *)notification
{
    NSString *errorMessage = [[notification userInfo] objectForKey:ErrorResultKey];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ErrorTitle message:errorMessage delegate:self cancelButtonTitle:OkButtonName otherButtonTitles:nil];
    [alert show];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(SELF.name contains[c] %@)", searchText];
    _searchResults = [_allActivities filteredArrayUsingPredicate:resultPredicate];
}

#pragma mark - Table view data source

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 71;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [_searchResults count];
    }
    else
    {
        return [_allActivities count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *activityIdentifier = @"activityCell";
    
//    ActivityTableViewCell *cell = (ActivityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:activityIdentifier];
//    if (cell == nil) {
//        cell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activityIdentifier];
//    }
    
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    }else{
//        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    }
    
    ActivityTableViewCell *cell = (ActivityTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:activityIdentifier];
    
    PFObject *activity = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        activity = [_searchResults objectAtIndex:indexPath.row];
    }
    else
    {
        activity = [_allActivities objectAtIndex:indexPath.row];
    }
    
    //[cell.activityButton setTitle:[activity objectForKey:@"name"] forState:UIControlStateNormal];
    
    cell.activityLabel.text = [activity objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *activity = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        activity = [_searchResults objectAtIndex:indexPath.row];
    }
    else
    {
        activity = [_allActivities objectAtIndex:indexPath.row];
    }
    
    [self performSegueWithIdentifier:@"activitiesToActivity" sender:activity];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSString *segueIdentifier = [segue identifier];
    
    if ([segueIdentifier isEqualToString:@"activitiesToActivity"])
    {
        ActivityTableViewController *activityTableViewController = [segue destinationViewController];
        
        PFObject *activity = sender;
        
        ActivityDto *dto = [ActivityDto new];
        dto.activityId = [activity objectId];
        dto.name = [activity objectForKey:@"name"];
        
        activityTableViewController.activityDto = dto;
        
        // create a custom back button item, and set it
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        [self.navigationItem setBackBarButtonItem:backBarButtonItem];
    }
    
}
@end
