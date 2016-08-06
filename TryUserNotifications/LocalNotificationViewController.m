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
@property (weak, nonatomic) IBOutlet UITextField *triggerParameterField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mediaAttachmentSegmentControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *triggerSegmentControl;

@property (weak, nonatomic) IBOutlet UISwitch * repeatSwitch;

@end

@implementation LocalNotificationViewController

- (BOOL) validateInput {
    if (self.bodyField.text.length == 0) {
        [self showAlertWithMessage:@"Please set Body"];
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
    notificationContent.attachments = [self createSelectedMediaAttachment];
    notificationContent.sound    = [UNNotificationSound defaultSound];
//    notificationContent.badge    = @1;
//    notificationContent.launchImageName = @"LaunchScreenFromNotification"; // ???
//    notificationContent.threadIdentifier
//    notificationContent.categoryIdentifier
//    notificationContent.userInfo = @{@"tag": @1};

    BOOL shouldRepeat = self.repeatSwitch.on;
    NSTimeInterval triggerTimeInterval = [self.triggerParameterField.text doubleValue];
    if (triggerTimeInterval == 0) {
        [self showAlertWithMessage:@"Time interval should be greater then 0"];
        return;
    }
    
//    UNLocationNotificationTrigger
//    UNCalendarNotificationTrigger
    UNTimeIntervalNotificationTrigger *
    notificationTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:triggerTimeInterval
                                                                             repeats:shouldRepeat];
    
    NSString * contentIdentifier = @"content-identifier-1";
    
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

- (NSArray<UNNotificationAttachment*> *)createSelectedMediaAttachment
{
    switch (self.mediaAttachmentSegmentControl.selectedSegmentIndex) {
        case 0:/*None*/
            return nil;

        case 1:/*JPG*/
            return [self createMediaAttachmentsWithId:@"attachment-1" ofType:@"jpg"];
        
        case 2:/*GIF*/
            return [self createMediaAttachmentsWithId:@"attachment-2" ofType:@"gif"];
 
        case 3:/*Video*/
            return [self createMediaAttachmentsWithId:@"attachment-3" ofType:@"mp4"];
        
        case 4:/*Audio*/
            return [self createMediaAttachmentsWithId:@"attachment-4" ofType:@"m4a"];
            
        default:
            return nil;
    }
}

- (NSArray<UNNotificationAttachment*> *)createMediaAttachmentsWithId:(NSString*)attachmentId
                                                              ofType:(NSString*)type
{
    NSURL * attachmentURL = [[NSBundle mainBundle] URLForResource:attachmentId
                                                    withExtension:type];
    NSError * error = nil;
    UNNotificationAttachment * notifcationAttachment = [UNNotificationAttachment
                                                        attachmentWithIdentifier:attachmentId
                                                        URL:attachmentURL
                                                        options:nil
                                                        error:&error];
    if (error) {
        [self showAlertWithError:error];
    }
    if (notifcationAttachment) {
        return @[notifcationAttachment];
    }
    return nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setupTimeIntervalPicker];
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

//- (void) setupTimeIntervalPicker {
//    UIDatePicker *
//    datePicker = [UIDatePicker new];
//    datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
//    
//    self.triggerParameterField.inputView = datePicker;
//}

@end
