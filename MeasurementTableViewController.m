//
//  MeasurementTableViewController.m
//  Fitivate
//
//  Created by Rayden Lee on 10/05/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "MeasurementTableViewController.h"
#import "MetricRequestHandler.h"
#import "MeasurementTableViewCell.h"
#import "AsyncOperationHandler.h"
#import "SaveNumericMetricResult.h"

@interface MeasurementTableViewController ()

@end

@implementation MeasurementTableViewController
{
    MetricRequestHandler *_metricRequestHandler;
    NSDictionary *_userMetrics;
    NSDictionary *_allMetrics;
    AsyncOperationHandler *_fetchAsyncOperationHandler;
    AsyncOperationHandler *_saveAsyncOperationHandler;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Custom initialization
        _metricRequestHandler = [MetricRequestHandler new];
        _userMetrics = [NSDictionary new];
        _allMetrics = [NSDictionary new];
        _fetchAsyncOperationHandler = [AsyncOperationHandler new];
        _saveAsyncOperationHandler = [AsyncOperationHandler new];
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
    NSLog(@"MeasurementViewController - viewDidAppear");
    
    [super viewDidAppear:animated];
    
    [self setupEvents];
    
    // setup weak references
    MetricRequestHandler *metricRequestHandler = _metricRequestHandler;
    
    [_fetchAsyncOperationHandler addOperation:^{
        [metricRequestHandler fetchAllMetrics];
    }];
    
    [_fetchAsyncOperationHandler addOperation:^{
        [metricRequestHandler fetchUserMetrics];
    }];
    
    [ActivityIndicator showWithView:self.view];
    
    [_fetchAsyncOperationHandler runWithFinallyBlock:^{
    } successBlock:^{
        [ActivityIndicator hideWithView:self.view];
        [self.tableView reloadData];
    } errorBlock:^(NSArray *errors) {
        [ActivityIndicator hideWithView:self.view];
        NSLog(@"%lu errors occurred", (unsigned long)errors.count);
        NSString *errorString = [Helpers getErrorMessageWithArray:errors];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ErrorTitle message:errorString delegate:self cancelButtonTitle:OkButtonName otherButtonTitles:nil];
        [alert show];
    }];
    
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
                                             selector:@selector(fetchUserMetricsSuccess:)
                                                 name:FetchUserMetricsSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchUserMetricsFailure:)
                                                 name:FetchUserMetricsFailureEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchAllMetricsSuccess:)
                                                 name:FetchAllMetricsSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchAllMetricsFailure:)
                                                 name:FetchAllMetricsFailureEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveMetricSuccess:)
                                                 name:SaveMetricSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveMetricFailure:)
                                                 name:SaveMetricFailureEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveMetricNothingToSave:)
                                                 name:SaveMetricNothingToSaveEvent
                                               object:nil];
}

- (void)removeEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FetchUserMetricsSuccessEvent
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FetchUserMetricsFailureEvent
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FetchAllMetricsSuccessEvent
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FetchAllMetricsFailureEvent
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SaveMetricSuccessEvent
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SaveMetricFailureEvent
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SaveMetricNothingToSaveEvent
                                                  object:nil];
}

- (void)fetchUserMetricsSuccess:(NSNotification *)notification
{
    // assign the fetched metrics
    _userMetrics = notification.userInfo;
    
    [_fetchAsyncOperationHandler handleResponse];
}

- (void)fetchUserMetricsFailure:(NSNotification *)notification
{
    NSString *errorString = [[notification userInfo] objectForKey:ErrorResultKey];
    
    [_fetchAsyncOperationHandler handleErrorResponse:errorString];
}

- (void)fetchAllMetricsSuccess:(NSNotification *)notification
{
    // assign the fetched metrics
    _allMetrics = notification.userInfo;
    
    [_fetchAsyncOperationHandler handleResponse];
}

- (void)fetchAllMetricsFailure:(NSNotification *)notification
{
    NSString *errorString = [[notification userInfo] objectForKey:ErrorResultKey];
    
    [_fetchAsyncOperationHandler handleErrorResponse:errorString];
}

- (void)saveMetricSuccess:(NSNotification *)notification
{
    NSString *metricUnitId = [notification.userInfo objectForKey:SaveNumericMetricResultMetricUnitIdKey];
    PFObject *userNumericMetric = [notification.userInfo objectForKey:SaveNumericMetricResultSavedUserNumericMetricKey];
    
    // update the user metrics collection
    [_userMetrics setValue:userNumericMetric forKey:metricUnitId];
    
    [_saveAsyncOperationHandler handleResponse];
}

- (void)saveMetricFailure:(NSNotification *)notification
{
    NSString *errorString = [[notification userInfo] objectForKey:ErrorResultKey];
    
    [_saveAsyncOperationHandler handleErrorResponse:errorString];
}

- (void)saveMetricNothingToSave:(NSNotification *)notification
{
    [_saveAsyncOperationHandler handleResponse];
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
    return _allMetrics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *measurementIdentifier = @"measurementCell";
    
    MeasurementTableViewCell *cell = (MeasurementTableViewCell *)[tableView dequeueReusableCellWithIdentifier:measurementIdentifier];
    if (cell == nil) {
        cell = [[MeasurementTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:measurementIdentifier];
    }
    
    NSArray *allMetrics = [_allMetrics allValues];
    // order the metrics by the orderIndex
    NSArray *sorted = [allMetrics sortedArrayUsingComparator:^NSComparisonResult(PFObject *obj1, PFObject *obj2) {
        NSNumber *index1 = @([[[obj1 objectForKey:@"metric"] objectForKey:@"orderIndex"] intValue]);
        NSNumber *index2 = @([[[obj2 objectForKey:@"metric"] objectForKey:@"orderIndex"] intValue]);
        
        return [index1 compare:index2];
    }];
    PFObject *metricUnit = [sorted objectAtIndex:indexPath.row];
    
    PFObject *userMetric = [_userMetrics objectForKey:metricUnit.objectId];
    
    cell.nameUnitLabel.text = [self getNameWithObject:metricUnit];
    // store the metric unit id for use when saving
    cell.metricUnitId = metricUnit.objectId;
    // if we have a user metric object
    if ([Helpers isSetWithObject:userMetric])
    {
        cell.measurementTextField.text = [NSString stringWithFormat:@"%g", [[userMetric objectForKey:@"value"] floatValue]];
    }
    
    return cell;
}

- (NSString *) getNameWithObject:(PFObject *)object
{
    return [NSString stringWithFormat:@"%@ (%@)",
            [[object objectForKey:@"metric"] objectForKey:@"name"],
            [object objectForKey:@"unit"]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapSave:(id)sender
{
    [ActivityIndicator showWithView:self.view];
    
    // setup weak references
    MetricRequestHandler *metricRequestHandler = _metricRequestHandler;
    NSDictionary *userMetrics = _userMetrics;
    
    // loop through all of the rows in the table
    for (int row = 0; row < [self.tableView numberOfRowsInSection:0]; row++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        
        MeasurementTableViewCell *cell = (MeasurementTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        if ([Helpers isNotEmptyWithString:cell.measurementTextField.text])
        {
            NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:cell.measurementTextField.text];
            
            [_saveAsyncOperationHandler addOperation:^{
                [metricRequestHandler saveNumericMetricWithExistingValues:userMetrics newValue:value metricUnitId:cell.metricUnitId];
            }];
        }
    }
    
    [_saveAsyncOperationHandler runWithFinallyBlock:^{
    } successBlock:^{
        [self.tableView reloadData];
        [ActivityIndicator hideWithView:self.view];
    } errorBlock:^(NSArray *errors) {
        [ActivityIndicator hideWithView:self.view];
        NSLog(@"%lu errors occurred", (unsigned long)errors.count);
        NSString *errorString = [Helpers getErrorMessageWithArray:errors];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ErrorTitle message:errorString delegate:self cancelButtonTitle:OkButtonName otherButtonTitles:nil];
        [alert show];
    }];
}
@end
