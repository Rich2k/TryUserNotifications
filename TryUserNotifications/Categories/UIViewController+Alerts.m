//
//  UIViewController+Alerts.m
//  TryUserNotifications
//
//  Created by Andrew on 06/08/16.
//  Copyright © 2016 Andrey Tokarev. All rights reserved.
//

#import "UIViewController+Alerts.h"

@implementation UIViewController (Alerts)

static NSString * const kAlertActionOkTitle = @"ok";

- (void) showAlertWithMessage:(NSString*)message title:(NSString*)title
{
    UIAlertController *
    alert = [UIAlertController alertControllerWithTitle:title
                                                message:message
                                         preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:kAlertActionOkTitle
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [alert dismissViewControllerAnimated:YES
                                                                          completion:nil];
                                            }]];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];    
}

- (void) showAlertWithMessage:(NSString*)message
{
    [self showAlertWithMessage:message title:nil];
}

- (void) showAlertWithError:(NSError*)error
{
    [self showAlertWithMessage:error.localizedDescription title:@"Error"];
}

@end
