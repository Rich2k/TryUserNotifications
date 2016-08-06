//
//  SecondViewController.m
//  TryUserNotifications
//
//  Created by Andrew on 06/08/16.
//  Copyright © 2016 Andrey Tokarev. All rights reserved.
//

#import "LocalNotificationViewController.h"
#import "UIViewController+Alerts.h"

@import UserNotifications;

@interface LocalNotificationViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *subtitleField;
@property (weak, nonatomic) IBOutlet UITextField *bodyField;
@property (weak, nonatomic) IBOutlet UITextField *identifierField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mediaAttachmentSegmentControl;


@end

@implementation LocalNotificationViewController

- (BOOL) validateInput {
    if (self.bodyField.text.length == 0) {
        [self showAlertWithMessage:@"Please set Body"];
        return NO;
    }
    if (self.identifierField.text.length == 0) {
        [self showAlertWithMessage:@"Please set Content Identifier"];
        return NO;
    }
    
    return YES;
}

- (IBAction)onScheduleAction:(UIButton *)sender {
    
    if(![self validateInput]) {
        return;
    }
    
    UNMutableNotificationContent *
    notificationContent = [UNMutableNotificationContent new];
    notificationContent.title    = self.titleField.text;
    notificationContent.subtitle = self.subtitleField.text;
    notificationContent.body     = self.bodyField.text;
//    notificationContent.badge    = 1;
//    notificationContent.sound
//    notificationContent.launchImageName = @"LaunchScreenFromNotification"; // ???
//    notificationContent.threadIdentifier
//    notificationContent.categoryIdentifier
    notificationContent.attachments = [self createMediaAttachments];
//    notificationContent.userInfo = @{@"tag": @1};
    
//    UNLocationNotificationTrigger
//    UNCalendarNotificationTrigger
    UNTimeIntervalNotificationTrigger *
    notificationTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5
                                                                             repeats:NO];
    
    NSString * contentIdentifier = self.identifierField.text;
    
    UNNotificationRequest *
    notificationRequest = [UNNotificationRequest requestWithIdentifier:contentIdentifier
                                                               content:notificationContent
                                                               trigger:notificationTrigger];
    
    [[UNUserNotificationCenter currentNotificationCenter]
     addNotificationRequest:notificationRequest
     withCompletionHandler:^(NSError * _Nullable error) {
        
         if (error) {
             [self showAlertWithError:error];
         }
     }];
    
    
}

- (NSArray<UNNotificationAttachment*> *)createMediaAttachments
{
    NSURL * fileUrl1 = [[NSBundle mainBundle] URLForResource:@"attachment-1"
                                              withExtension:@"jpg"];
    NSURL * fileUrl2 = [[NSBundle mainBundle] URLForResource:@"attachment-2"
                                               withExtension:@"gif"];
    
    NSError * error = nil;
    UNNotificationAttachment *
    notifcationAttachment1 = [UNNotificationAttachment
                              attachmentWithIdentifier:@"attachment-1"
                              URL:fileUrl1
                              options:nil
                              error:&error];

    UNNotificationAttachment *
    notifcationAttachment2 = [UNNotificationAttachment
                              attachmentWithIdentifier:@"attachment-2"
                              URL:fileUrl2
                              options:nil
                              error:&error];

    if (error) {
        [self showAlertWithError:error];
    }
    if (notifcationAttachment1 && notifcationAttachment2) {
        return @[notifcationAttachment2, notifcationAttachment1];
    }
    
    
    return nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onBackgroundTap:(UITapGestureRecognizer *)recognizer {
    if  (recognizer.state == UIGestureRecognizerStateRecognized) {
        [recognizer.view endEditing:YES];
    }
}

@end
