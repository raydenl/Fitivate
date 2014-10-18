//
//  ActivityIndicator.m
//  Fitivate
//
//  Created by Rayden Lee on 18/04/14.
//  Copyright (c) 2014 Rayden Lee. All rights reserved.
//

#import "ActivityIndicator.h"
#import "MBProgressHud.h"

@implementation ActivityIndicator

+ (void) showWithView:(UIView *)view
{
    // show the activity indicator
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //hud.labelText = label;
    
    // do not allow interactions
    hud.userInteractionEnabled = false;
}

+ (void) hideWithView:(UIView *)view
{
    // hide the activity indicator
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
