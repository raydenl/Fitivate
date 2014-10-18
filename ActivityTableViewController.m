//
//  ActivityTableViewController.m
//  Fitivate
//
//  Created by Rayden Lee on 21/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "ActivityTableViewController.h"
#import "ActivityRequestHandler.h"
//#import "ActivityMetricsResult.h"

@interface ActivityTableViewController ()

@end

@implementation ActivityTableViewController
{
    ActivityRequestHandler *_activityRequestHandler;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Custom initialization
        _activityRequestHandler = [ActivityRequestHandler new];
        
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
    
    self.title = self.activityDto.name;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"ActivityTableViewController - viewDidAppear");
    
    [super viewDidAppear:animated];
    
    [self setupEvents];
    
    //[_activityRequestHandler fetchUserActivityWithActivityId:self.activityDto.activityId];
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
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(fetchUserActivitySuccess:)
//                                                 name:FetchUserActivitySuccessEvent
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(fetchUserActivityFailure:)
//                                                 name:FetchUserActivityFailureEvent
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(fetchUserActivityNoData:)
//                                                 name:FetchUserActivityNoDataEvent
//                                               object:nil];
}

- (void)removeEvents
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:FetchUserActivitySuccessEvent
//                                                  object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:FetchUserActivityFailureEvent
//                                                  object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:FetchUserActivityNoDataEvent
//                                                  object:nil];
}

//- (void)fetchUserActivitySuccess:(NSNotification *)notification
//{
//    NSNumber *mintuesPerformed = [[notification userInfo] objectForKey:ActivityMetricsResult_MinutesPerformedKey];
//    [self.minutesPerformedTextField setText:[mintuesPerformed isEqual:[NSNull null]] ? @"" : [mintuesPerformed stringValue]];
//    
//    NSNumber *caloriesBurned = [[notification userInfo] objectForKey:ActivityMetricsResult_CaloriesBurnedKey];
//    [self.caloriesBurnedTextField setText:[caloriesBurned isEqual:[NSNull null]] ? @"" : [caloriesBurned stringValue]];
//}
//
//- (void)fetchUserActivityFailure:(NSNotification *)notification
//{
//    NSString *errorMessage = [[notification userInfo] objectForKey:ErrorResultKey];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ErrorTitle message:errorMessage delegate:self cancelButtonTitle:OkButtonName otherButtonTitles:nil];
//    [alert show];
//}
//
//- (void)fetchUserActivityNoData:(NSNotification *)notification
//{
//    // do nothing?
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapSave:(id)sender {
}
@end
