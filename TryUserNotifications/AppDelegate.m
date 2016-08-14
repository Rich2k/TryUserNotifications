//
//  AppDelegate.m
//  TryUserNotifications
//
//  Created by Andrew on 06/08/16.
//  Copyright © 2016 Andrey Tokarev. All rights reserved.
//

#import "AppDelegate.h"
#import "LocalNotification.h"
#import "Constants.h"

@import UserNotifications;

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (void) setupCustomNotificationActions {
 
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationCategoriesWithCompletionHandler:^(NSSet<UNNotificationCategory *> * _Nonnull categories) {
        
        NSLog(@"Notification Categories: %@", categories);
    }];
    
//    UNNotificationAction * action = [UNNotificationAction actionWithIdentifier:@"reply"
//                                                                         title:@"Reply"
//                                                                       options:0]; /*UNNotificationActionOptionAuthenticationRequired,UNNotificationActionOptionDestructive,UNNotificationActionOptionForeground*/
    
    UNNotificationCategory * category = [UNNotificationCategory categoryWithIdentifier:kCustomNotificationCategoryForDismis
                                                                               actions:@[]
                                                                     intentIdentifiers:@[]
                                                                               options:UNNotificationCategoryOptionCustomDismissAction]; // UNNotificationCategoryOptionNone, UNNotificationCategoryOptionCustomDismissAction

    NSSet * categorySet = [NSSet setWithArray:@[category]];
    
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categorySet];
}

- (void) setupUserNotificationCenterDelegate {
    // The delegate can only be set from an application
    [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
}

- (void) selectDefaultTab {
    // temporary hack
    ((UITabBarController*)self.window.rootViewController).selectedIndex = 1;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupUserNotificationCenterDelegate];
    [self setupCustomNotificationActions];
    [self selectDefaultTab];
    
    // Enable Remote Notificaitons
    [application registerForRemoteNotifications];
    
    return YES;
}

#pragma mark - Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    NSLog(@"Remote Notification Device Token: %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error
{
    NSLog(@"Did Fail To Register for Remote Notifications: %@", error);
}

// Not called, as we have fetchCompletionHandler version
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//}

// For Silent Pushes
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    NSLog(@"Received Push : %@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNoData);
}

#pragma mark -

// The method will be called on the delegate only if the application is in the foreground.
// If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented.
// The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list.
// This decision should be based on whether the information in the notification is otherwise visible to the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
 
    NSLog(@"Notification: %@", notification.request.content.userInfo);
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction.
// The delegate must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)())completionHandler
{
    [self handleNotificationResponse:response];
 
    completionHandler();
}

#pragma mark - Action Identifier

- (void) handleNotificationResponse:(UNNotificationResponse*)notificationResponse
{
    NSString * actionIdentifier = notificationResponse.actionIdentifier;
    
    // Custom Dismiss Action, good for tracking
    if ([actionIdentifier isEqualToString:UNNotificationDismissActionIdentifier]) { // iOS10
     
        [self sheduleLocalNotificationWhat];
        
        return;
    }
    
    // Default open action, when user taps on notification
    if ([actionIdentifier isEqualToString:UNNotificationDefaultActionIdentifier]) { // iOS10
        
        return;
    }
    
    // else we have own custom identifier
}

- (void) sheduleLocalNotificationWhat
{
    LocalNotification *
    localNotification = [LocalNotification new];
    localNotification.title = @"I can't beleive it...";
    localNotification.body  = @"How could you possibly dismiss that piece of art?";
    localNotification.subtitle = @"😱";
    [localNotification sheduleWithTimeInterval:3
                                  shouldRepeat:NO
                         withCompletionHandler:nil];
}

@end
