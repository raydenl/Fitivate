//
//  ProfileViewController.m
//  Fitivate
//
//  Created by Rayden Lee on 19/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "ProfileViewController.h"
#import "MetricRequestHandler.h"
#import "SaveNumericMetricResult.h"
#import "AsyncOperationHandler.h"
#import "UserDetailsResult.h"
#import "UserRequestHandler.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
{
    UserRequestHandler *_userRequestHandler;
    NSDateFormatter *_dateFormatter;
    BOOL _datePickerIsVisible;
    UITextField *_activeTextField;
    AsyncOperationHandler *_fetchAsyncOperationHandler;
    AsyncOperationHandler *_saveAsyncOperationHandler;
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self)
    {
        _dateFormatter = [NSDateFormatter new];
        _fetchAsyncOperationHandler = [[AsyncOperationHandler alloc] init];
        _saveAsyncOperationHandler = [[AsyncOperationHandler alloc] init];
        _userRequestHandler = [[UserRequestHandler alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [self signUpForKeyboardNotifications];
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.heightTextField.delegate = self;
    self.weightTextField.delegate = self;
    
    self.firstNameTextField.textColor = [UIColor blueColor];
    self.lastNameTextField.textColor = [UIColor blueColor];
    self.dateOfBirthLabel.textColor = [UIColor blueColor];
    self.heightTextField.textColor = [UIColor blueColor];
    self.weightTextField.textColor = [UIColor blueColor];
    
    // set the default date picker date
    NSString *dateString = @"19800101";
    [_dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [_dateFormatter dateFromString:dateString];
    [self.dateOfBirthDatePicker setDate:date];
    
    // we need to hide the date picker the first time the view is loaded, as for some
    // reason it is not hidden when the cells row height = 0
    self.dateOfBirthDatePicker.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"ProfileViewController - viewDidAppear");
    
    [super viewDidAppear:animated];
    
    [self setupEvents];
    
    // setup weak references
    UserRequestHandler *userRequestHandler = _userRequestHandler;
    
    [_fetchAsyncOperationHandler addOperation:^{
        [userRequestHandler fetchUserDetails];
    }];
    
    [ActivityIndicator showWithView:self.view];
    
    [_fetchAsyncOperationHandler runWithFinallyBlock:^{
        NSLog(@"fetch - everything has finished");
    } successBlock:^{
        [ActivityIndicator hideWithView:self.view];
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
                                             selector:@selector(fetchUserDetailsSuccess:)
                                                 name:FetchUserDetailsSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchUserDetailsFailure:)
                                                 name:FetchUserDetailsFailureEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveUserDetailsSuccess:)
                                                 name:SaveUserDetailsSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveUserDetailsFailure:)
                                                 name:SaveUserDetailsFailureEvent
                                               object:nil];
}

- (void)removeEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:FetchUserDetailsSuccessEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:FetchUserDetailsFailureEvent
                                               object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SaveUserDetailsSuccessEvent
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SaveUserDetailsFailureEvent
                                                  object:nil];
}

- (void)fetchUserDetailsSuccess:(NSNotification *)notification
{
    NSString *firstName = [[notification userInfo] objectForKey:UserDetailsResultFirstNameKey];
    [self.firstNameTextField setText:[firstName isEqual:[NSNull null]] ? @"" : firstName];
    
    NSString *lastName = [[notification userInfo] objectForKey:UserDetailsResultLastNameKey];
    [self.lastNameTextField setText:[lastName isEqual:[NSNull null]] ? @"" : lastName];
    
    NSDate *dateOfBirth = [[notification userInfo] objectForKey:UserDetailsResultDateOfBirthKey];
    [self setDateOfBirth:[dateOfBirth isEqual:[NSNull null]] ? nil : dateOfBirth];
    
    // handle the fetch success
    [_fetchAsyncOperationHandler handleResponse];
}

- (void)fetchUserDetailsFailure:(NSNotification *)notification
{
    NSString *errorString = [[notification userInfo] objectForKey:ErrorResultKey];
    
    // handle fetch failures
    [_fetchAsyncOperationHandler handleErrorResponse:errorString];
}

- (void)saveUserDetailsSuccess:(NSNotification *)notification
{
    [_saveAsyncOperationHandler handleResponse];
}

- (void)saveUserDetailsFailure:(NSNotification *)notification
{
    NSString *errorString = [[notification userInfo] objectForKey:ErrorResultKey];
    
    // handle save failures
    [_saveAsyncOperationHandler handleErrorResponse:errorString];
}

//- (void)setTextFieldNumericValue:(UITextField *)textField object:(PFObject *)object format:(NSString *)format
//{
//    NSNumber *number = [object objectForKey:@"value"];
//    if (number == nil)
//    {
//        [textField setText:@""];
//    }
//    else
//    {
//        [textField setText:[NSString stringWithFormat:format, number]];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#define kDatePickerIndex 3

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.tableView.rowHeight;
    
    if (indexPath.row == kDatePickerIndex)
    {
        height = _datePickerIsVisible ? DatePickerHeight : 0.0f;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2){
        
        if (_datePickerIsVisible){
            
            // hide the date picker
            [self hideDatePickerCell];
            
        }else {
            
            // first set the label to the date picker value, this is needed the first time
            // the date picker is opened
            [self setDateOfBirth:self.dateOfBirthDatePicker.date];
            // then show the date picker
            [self showDatePickerCell];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) showDatePickerCell
{
    // hides the keyboard, if it is visible
    [_activeTextField resignFirstResponder];
    
    _datePickerIsVisible = YES;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    self.dateOfBirthDatePicker.hidden = NO;
    self.dateOfBirthDatePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.dateOfBirthDatePicker.alpha = 1.0f;
    }];
}

-(void) hideDatePickerCell
{
    _datePickerIsVisible = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.dateOfBirthDatePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.dateOfBirthDatePicker.hidden = YES;
                     }];
}

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender
{
    [self setDateOfBirth:sender.date];
}

- (IBAction)didTapSave:(id)sender
{
    NSString *firstName = self.firstNameTextField.text;
    NSString *lastName = self.lastNameTextField.text;
    NSDate *dateOfBirth = (self.dateOfBirthLabel.text == nil) ? nil : self.dateOfBirthDatePicker.date;
    
    // setup weak references
    UserRequestHandler *userRequestHandler = _userRequestHandler;
    
    [_saveAsyncOperationHandler addOperation:^{
        [userRequestHandler saveUserDetailsWithFirstName:firstName lastName:lastName dateOfBirth:dateOfBirth];
    }];

    [ActivityIndicator showWithView:self.view];
    
    [_saveAsyncOperationHandler runWithFinallyBlock:^{
        NSLog(@"save - everything has finished");
        // hides the keyboard, if it is visible
        [_activeTextField resignFirstResponder];
        // hides the datepicker, if it is visible
        [self keyboardWillShow];
    } successBlock:^{
        [ActivityIndicator hideWithView:self.view];
    } errorBlock:^(NSArray *errors) {
        [ActivityIndicator hideWithView:self.view];
        NSLog(@"%lu errors occurred", (unsigned long)errors.count);
        NSString *errorString = [Helpers getErrorMessageWithArray:errors];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ErrorTitle message:errorString delegate:self cancelButtonTitle:OkButtonName otherButtonTitles:nil];
        [alert show];
    }];
}

-(void) setDateOfBirth:(NSDate *)date
{
    [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.dateOfBirthLabel.text = [_dateFormatter stringFromDate:date];
}

- (void)signUpForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)keyboardWillShow
{
    if (_datePickerIsVisible)
    {
        [self hideDatePickerCell];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeTextField = textField;
}
@end
