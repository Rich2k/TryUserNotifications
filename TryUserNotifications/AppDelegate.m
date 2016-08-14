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


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
