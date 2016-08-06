//
//  UIViewController+Alerts.h
//  TryUserNotifications
//
//  Created by Andrew on 06/08/16.
//  Copyright © 2016 Andrey Tokarev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alerts)

- (void) showAlertWithMessage:(NSString*)message title:(NSString*)title;
- (void) showAlertWithMessage:(NSString*)message;
- (void) showAlertWithError:(NSError*)error;

@end
