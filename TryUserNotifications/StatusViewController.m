//
//  FirstViewController.m
//  TryUserNotifications
//
//  Created by Andrew on 06/08/16.
//  Copyright © 2016 Andrey Tokarev. All rights reserved.
//

#import "StatusViewController.h"
@import UserNotifications;

@interface StatusViewController ()

@end

@implementation StatusViewController

- (IBAction)onRemoveAllPendingNotificatinsAction:(UIButton *)sender {
    
    [[UNUserNotificationCenter currentNotificationCenter]
     removeAllPendingNotificationRequests];
}

- (IBAction)onRemoveAllDeliveredNotificatinsAction:(UIButton *)sender {
    
    [[UNUserNotificationCenter currentNotificationCenter]
     removeAllDeliveredNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updatePendingNotificationsStatus];
    [self updateDeliverdNotificationsStatus];
}

- (void) updatePendingNotificationsStatus {
    [[UNUserNotificationCenter currentNotificationCenter]
     getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
         
         NSLog(@"Pending Requests >> %@", requests);
     }];
}

- (void) updateDeliverdNotificationsStatus {
    [[UNUserNotificationCenter currentNotificationCenter]
     getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
         
         NSLog(@"Delivered >> %@", notifications);
     }];
}


@end
