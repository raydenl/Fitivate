//
//  TimelineViewController.m
//  Fitivate
//
//  Created by Rayden Lee on 8/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "TimelineViewController.h"
#import "TimelineRequestHandler.h"
#import "TimelineTableViewCell.h"
#import "UserRequestHandler.h"
#import "AsyncOperationHandler.h"
#import "TimelineEventsResult.h"
#import "ITimelineEvent.h"

@interface TimelineViewController ()

@end

@implementation TimelineViewController
{
    TimelineRequestHandler *_timelineRequestHandler;
    UserRequestHandler *_userRequestHandler;
    AsyncOperationHandler *_fetchAsyncOperationHandler;
    NSMutableArray *_events;
    NSTimer *_timer;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self)
    {
        _timelineRequestHandler = [TimelineRequestHandler new];
        _userRequestHandler = [UserRequestHandler new];
        _fetchAsyncOperationHandler = [AsyncOperationHandler new];
        _events = [NSMutableArray new];
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
    
    // we only show the activity indicator on the first load of data
    [ActivityIndicator showWithView:self.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupEvents];
    
    // setup the run loop, and add the timer
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    // fire the timer immediately
    [self.timer fire];
    
    //[self.navigationController setToolbarHidden:YES animated:YES];
    
    // just reload the table view so we can update the event timestamps
    // let the timer handle the new data fetches
    //[self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    _timer = nil;
    
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
                                             selector:@selector(userLogoutSuccess:)
                                                 name:UserLogoutSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLogoutFailure:)
                                                 name:UserLogoutFailureEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchNumericMetricEventsSuccess:)
                                                 name:FetchNumericMetricEventsSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchNumericMetricEventsFailure:)
                                                 name:FetchNumericMetricEventsFailureEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchLastEventTimestampSuccess:)
                                                 name:FetchLastEventTimestampSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchLastEventTimestampFailure:)
                                                 name:FetchLastEventTimestampFailureEvent
                                               object:nil];
}

- (void)removeEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UserLogoutSuccessEvent
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UserLogoutFailureEvent
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FetchNumericMetricEventsSuccessEvent
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FetchNumericMetricEventsFailureEvent
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FetchLastEventTimestampSuccessEvent
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FetchLastEventTimestampFailureEvent
                                                  object:nil];
}

- (NSTimer *) timer
{
    if (!_timer)
    {
        _timer = [NSTimer timerWithTimeInterval:TimelineTimeIntervalSeconds target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
    }
    
    return _timer;
}

-(void) onTick:(NSTimer *)timer
{
    NSLog(@"Tick...");
    
    if ([_events count] == 0)
    {
        // no cache, so get all events
        [self fetchEvents];
    }
    else
    {
        // we have some events, so get the timestamp of the last event
        // so we can see if there are newer events available
        [_timelineRequestHandler fetchNumericMetricLastEventTimestamp];
    }
}

-(void) fetchEvents
{
    [self fetchEventsWithLastEventTimestamp:nil];
}

-(void) fetchEventsWithLastEventTimestamp:(NSDate *)lastEventTimestamp
{
    // setup weak references
    TimelineRequestHandler *timelineRequestHandler = _timelineRequestHandler;
    
    [_fetchAsyncOperationHandler addOperation:^{
        [timelineRequestHandler fetchNumericMetricEventsWithLastEventTimestamp:lastEventTimestamp];
    }];
    
    // add other operations here
    
    [_fetchAsyncOperationHandler runWithFinallyBlock:^{
        // put this in the finally block so we always refresh timestamps regardless of whether we have new data
        [self.tableView reloadData];
        [ActivityIndicator hideWithView:self.view];
    } successBlock:^{
        // success
    } errorBlock:^(NSArray *errors) {
        // hide the activity indicator before we show the error popup
        [ActivityIndicator hideWithView:self.view];
        NSLog(@"%lu errors occurred", (unsigned long)errors.count);
        NSString *errorString = [Helpers getErrorMessageWithArray:errors];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ErrorTitle message:errorString delegate:self cancelButtonTitle:OkButtonName otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)userLogoutSuccess:(NSNotification *)notification
{
    [ActivityIndicator hideWithView:self.view];
    
    [self.parentViewController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)userLogoutFailure:(NSNotification *)notification
{
    [ActivityIndicator hideWithView:self.view];
    
    NSString *errorString = [[notification userInfo] objectForKey:ErrorResultKey];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ErrorTitle message:errorString delegate:self cancelButtonTitle:OkButtonName otherButtonTitles:nil];
    [alert show];
}

- (void)fetchNumericMetricEventsSuccess:(NSNotification *)notification
{
    if ([_events count] == 0)
    {
        // no existing events so add all at once
        _events = [notification.userInfo objectForKey:TimelineEventsResultEventsArrayKey];
    }
    else
    {
        // we already have some events, so we need to add the new ones at the beginning of the existing ones
        int insertIndex = 0;
        
        id event;
        for (event in [notification.userInfo objectForKey:TimelineEventsResultEventsArrayKey])
        {
            [_events insertObject:event atIndex:insertIndex];
            insertIndex++;
        }
    }
    
    [_fetchAsyncOperationHandler handleResponse];
}

- (void)fetchNumericMetricEventsFailure:(NSNotification *)notification
{
    NSString *errorString = [[notification userInfo] objectForKey:ErrorResultKey];
    
    [_fetchAsyncOperationHandler handleErrorResponse:errorString];
}

- (void)fetchLastEventTimestampSuccess:(NSNotification *)notification
{
    NSDate *lastEventTimestamp = [[notification.userInfo allValues] objectAtIndex:0];
    
    if (![[NSNull null] isEqual:lastEventTimestamp])
    {
        // get the last already fetched event
        id <ITimelineEvent> event = (id <ITimelineEvent>)[_events firstObject];
        
        // if a later event exists on the server than what we already have, then fetch the new events
        if ([lastEventTimestamp timeIntervalSinceDate:event.timestamp] > 0)
        {
            // fetch events, passing in the last fetched event timestamp so we only get the newer records
            [self fetchEventsWithLastEventTimestamp:event.timestamp];
        }
    }
    
    // always reload the table data to refresh the timestamps
    // this will happen on all paths, so we might end up refreshing twice in a row
    [self.tableView reloadData];
}

- (void)fetchLastEventTimestampFailure:(NSNotification *)notification
{
    //do nothing?
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *timelineIdentifier = @"timelineCell";
    
    TimelineTableViewCell *cell = (TimelineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:timelineIdentifier];
    if (cell == nil) {
        cell = [[TimelineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:timelineIdentifier];
    }
    
    id <ITimelineEvent> event = (id <ITimelineEvent>)[_events objectAtIndex:indexPath.row];
    
    cell.profileImageView = [[UIImageView alloc] initWithImage:event.profilePhoto];
    cell.nameLabel.text = event.displayName;
    cell.eventDateTimeLabel.text = event.timestampString;
    cell.eventLabel.text = event.eventText;
    
    return cell;
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
//- (PFQuery *)queryForTable
//{
//    // all confirmed friends
//    PFQuery *confirmedFriendQuery = [PFQuery queryWithClassName:UserFriend];
//    [confirmedFriendQuery whereKey:@"user" equalTo:[PFUser currentUser]];
//    [confirmedFriendQuery whereKeyDoesNotExist:@"friendRequestCancelledAt"];
//    [confirmedFriendQuery whereKeyDoesNotExist:@"deletedAt"];
//    [confirmedFriendQuery whereKeyExists:@"relationshipConfirmedAt"];
//    
//    // get numeric metric updates for current user
//    PFQuery *numericMetricUpdateQuery = [PFQuery queryWithClassName:UserNumericMetric];
//    [numericMetricUpdateQuery whereKey:@"user" equalTo:[PFUser currentUser]];
//    
//    // get numeric metric updates for all confirmed friends
//    PFQuery *friendNumericMetricUpdateQuery = [PFQuery queryWithClassName:UserNumericMetric];
//    [friendNumericMetricUpdateQuery whereKey:@"user" matchesKey:@"friend" inQuery:confirmedFriendQuery];
//    
//    PFQuery *query = [PFQuery orQueryWithSubqueries:@[numericMetricUpdateQuery,friendNumericMetricUpdateQuery]];
//    [query includeKey:@"user"];
//    [query includeKey:@"metricWithUnit.metric"];
//    [query setLimit:50];
//    
//    [query orderByDescending:@"createdAt"];
//    
//    return query;
//}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
//{
//    static NSString *timelineIdentifier = @"timelineCell";
//    
//    PFUser *user = [object objectForKey:@"user"];
//    
//    TimelineTableViewCell *cell = (TimelineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:timelineIdentifier];
//    if (cell == nil) {
//        cell = [[TimelineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:timelineIdentifier];
//    }
//    
//    cell.nameLabel.text = [self getNameWithUser:user];
//    cell.eventDateTimeLabel.text = [self convertToStringWithDate:object.createdAt];
//    cell.eventLabel.text = [NSString stringWithFormat:@"%@ metric updated.", [[object[@"metricWithUnit"] objectForKey:@"metric"] objectForKey:@"name"]];
//    
//    return cell;
//}

//- (NSString *) getNameWithUser:(PFUser *)user
//{
//    if (user[@"firstName"] == nil)
//    {
//        return user.username;
//    }
//    
//    if (user[@"lastName"] == nil)
//    {
//        return user[@"firstName"];
//    }
//    
//    return [NSString stringWithFormat:@"%@ %@", user[@"firstName"], user[@"lastName"]];
//}

//- (NSString *) convertToStringWithDate:(NSDate *)date
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    [dateFormatter setDateFormat:@"d/MM/yyyy h:mm:ss aaa"];
//    
//    return [dateFormatter stringFromDate:date];
//}

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
    
    if ([segueIdentifier isEqualToString:@"timelineToMeasurement"])
    {
        // create a custom back button item, and set it
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        [self.navigationItem setBackBarButtonItem:backBarButtonItem];
    }
    
    if ([segueIdentifier isEqualToString:@"timelineToActivities"])
    {
        // create a custom back button item, and set it
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        [self.navigationItem setBackBarButtonItem:backBarButtonItem];
    }
}


- (IBAction)didTapEnterMeasurement:(id)sender
{
    [self performSegueWithIdentifier:@"timelineToMeasurement" sender:self];
}

- (IBAction)didTapEnterActivity:(id)sender
{
    [self performSegueWithIdentifier:@"timelineToActivities" sender:self];
}

- (IBAction)didTapLogout:(id)sender
{
    [ActivityIndicator showWithView:self.view];
    
    [_userRequestHandler logoutUser];
}
@end
