//
//  LocalNotification.m
//  TryUserNotifications
//
//  Created by Andrew on 07/08/16.
//  Copyright © 2016 Andrey Tokarev. All rights reserved.
//

#import "LocalNotification.h"
@import UserNotifications;

@interface LocalNotification()
@property (nonatomic, strong) NSMutableArray<UNNotificationAttachment*> * attachments;
@end

@implementation LocalNotification

- (UNNotificationContent*)createNotificationContent
{
    UNMutableNotificationContent *
    notificationContent = [UNMutableNotificationContent new];
    notificationContent.title    = self.title;
    notificationContent.subtitle = self.subtitle;
    notificationContent.body     = self.body;
    notificationContent.sound    = [UNNotificationSound defaultSound];
    
    if (_attachments) {  
        notificationContent.attachments = [self.attachments copy];
    }

    // TODO: to be supported:
    
    //    notificationContent.badge    = @1;
    //    notificationContent.launchImageName = @"LaunchScreenFromNotification"; // ???
    //    notificationContent.threadIdentifier
    //    notificationContent.categoryIdentifier
    //    notificationContent.userInfo = @{@"tag": @1};
    
    return notificationContent;
}

- (void) addAttachementFromUrl:(NSURL*)attachmentUrl
                         error:(NSError**)error
{
    if (attachmentUrl == nil) return;
    
    NSString * attachmentIdentifier = attachmentUrl.lastPathComponent;
    
    UNNotificationAttachment * notifcationAttachment = [UNNotificationAttachment
                                                        attachmentWithIdentifier:attachmentIdentifier
                                                        URL:attachmentUrl
                                                        options:nil
                                                        error:error];
    if (notifcationAttachment) {
        [self.attachments addObject:notifcationAttachment];
    }
}

//    UNLocationNotificationTrigger
//    UNCalendarNotificationTrigger
- (void) sheduleWithTimeInterval:(NSTimeInterval)triggerTimeInterval
                    shouldRepeat:(BOOL)shouldRepeat
           withCompletionHandler:(void(^)(NSError * error))completionHandler
{
    if (triggerTimeInterval == 0) {
        return;
    }

    UNNotificationContent * notificationContent = [self createNotificationContent];

    UNTimeIntervalNotificationTrigger *
    notificationTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:triggerTimeInterval
                                                                             repeats:shouldRepeat];
    
    NSString * contentIdentifier = self.contentIdentifier ?: [self generateRandomContentIdentifier];
    
    UNNotificationRequest *
    notificationRequest = [UNNotificationRequest requestWithIdentifier:contentIdentifier
                                                               content:notificationContent
                                                               trigger:notificationTrigger];

    [[UNUserNotificationCenter currentNotificationCenter]
     addNotificationRequest:notificationRequest
     withCompletionHandler:completionHandler];
}

#pragma mark -

- (NSString*) generateRandomContentIdentifier
{
    return [[NSUUID UUID] UUIDString];
}

#pragma mark - 

- (NSMutableArray<UNNotificationAttachment*>*) attachments {
    if(!_attachments) {
        _attachments = [NSMutableArray<UNNotificationAttachment*> new];
    }
    return _attachments;
}

@end
