//
//  SecondViewController.m
//  TryUserNotifications
//
//  Created by Andrew on 06/08/16.
//  Copyright © 2016 Andrey Tokarev. All rights reserved.
//

#import "LocalNotificationViewController.h"
#import "UIViewController+Alerts.h"
#import "LocalNotification.h"

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
    if ([self triggerTimeInterval] < 0.5) {
        [self showAlertWithMessage:@"Time interval should be greater then 0.5"];
    }
    return YES;
}

- (IBAction)onScheduleAction:(UIButton *)sender {
    
    if(![self validateInput]) {
        return;
    }
    LocalNotification *
    localNotification = [LocalNotification new];
    localNotification.body     = self.bodyField.text;
    localNotification.title    = self.titleField.text;
    localNotification.subtitle = self.subtitleField.text;
    
    localNotification.contentIdentifier = @"content-identifier-1"; // otherwise it will be generated
    
    NSError * attachmentError = nil;
    [localNotification addAttachementFromUrl:[self selectedMediaAttachmentUrl]
                                       error:&attachmentError];

    if (attachmentError) {
        [self showAlertWithError:attachmentError];
    }

    [localNotification sheduleWithTimeInterval:self.triggerTimeInterval
                                  shouldRepeat:self.shouldRepeat
                         withCompletionHandler:^(NSError *error) {
                             
                             if (error) {
                                 [self showAlertWithError:error];
                             }
                         }];
}

#pragma mark - Helpers

- (BOOL) shouldRepeat {
    return self.repeatSwitch.on;
}

- (NSTimeInterval) triggerTimeInterval {
    return [self.triggerParameterField.text doubleValue];
}

- (NSURL*) selectedMediaAttachmentUrl
{
    switch (self.mediaAttachmentSegmentControl.selectedSegmentIndex) {
        case 0:/*None*/
            return nil;
            
        case 1:/*JPG*/
            return [self createMediaAttachmentUrlForFilename:@"attachment-1" ofType:@"jpg"];
            
        case 2:/*GIF*/
            return [self createMediaAttachmentUrlForFilename:@"attachment-2" ofType:@"gif"];
            
        case 3:/*Video*/
            return [self createMediaAttachmentUrlForFilename:@"attachment-3" ofType:@"mp4"];
            
        case 4:/*Audio*/
            return [self createMediaAttachmentUrlForFilename:@"attachment-4" ofType:@"m4a"];
            
        default:
            return nil;
    }
}

- (NSURL *)createMediaAttachmentUrlForFilename:(NSString*)filename
                                        ofType:(NSString*)type
{
    return [[NSBundle mainBundle] URLForResource:filename
                                   withExtension:type];
}

#pragma mark - View Stuff

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self setupTimeIntervalPicker];
}

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
