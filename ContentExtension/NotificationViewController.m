//
//  NotificationViewController.m
//  ContentExtension
//
//  Created by Andrew on 14/08/16.
//  Copyright © 2016 Andrey Tokarev. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
    
    self.label.text = nil;
    
//  We can use this to set content size:
//    self.preferredContentSize = CGSizeMake(self.view.frame.size.width,
//                                           self.view.frame.size.width);
}

- (void)didReceiveNotification:(UNNotification *)notification {
    self.label.text = notification.request.content.userInfo[@"text"];
    
    if (self.label.text == nil) {
        self.label.text = @"👎";
    }
    
    // Temporary, to see basic animation
    [UIView animateWithDuration:1 animations:^{
        self.label.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    }];
}

//- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response
//                     completionHandler:(void (^)(UNNotificationContentExtensionResponseOption option))completion
//{
//    
//    completion(UNNotificationContentExtensionResponseOptionDoNotDismiss);
//}

@end
