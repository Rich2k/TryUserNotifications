//
//  SettingsViewController.m
//  TryUserNotifications
//
//  Created by Andrew on 06/08/16.
//  Copyright © 2016 Andrey Tokarev. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIViewController+Alerts.h"

@import UserNotifications;

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@end

@implementation SettingsViewController

- (void) registerForNotifications {
    
    [[UNUserNotificationCenter currentNotificationCenter]
     requestAuthorizationWithOptions:UNAuthorizationOptionAlert|UNAuthorizationOptionSound|UNAuthorizationOptionBadge
     completionHandler:^(BOOL granted, NSError * _Nullable error) {
         
         if (error) {
             [self showAlertWithError:error];
         }
         
     }];

    
}

- (void) getNotificaionSettings {
    
    [[UNUserNotificationCenter currentNotificationCenter]
     getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
         // called on some other thread
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [self updateSettingsView:settings];
         });
    }];
    
}

- (IBAction)onRegisterAction:(UIButton *)sender {
    
    [self registerForNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getNotificaionSettings];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 

- (void) updateSettingsView:(UNNotificationSettings*)settings
{
    UIView * view = nil;
    while((view = self.stackView.arrangedSubviews.firstObject)) {
        [self.stackView removeArrangedSubview:view];
        [view removeFromSuperview];
    }
    
    [self.stackView addArrangedSubview:[self createLabelWithTitle:@"authorizationStatus"
                                                          setting:settings.authorizationStatus]];
    
    [self.stackView addArrangedSubview:[self createLabelWithTitle:@"soundSetting"
                                                          setting:settings.soundSetting]];
    
    [self.stackView addArrangedSubview:[self createLabelWithTitle:@"badgeSetting"
                                                          setting:settings.badgeSetting]];
    
    [self.stackView addArrangedSubview:[self createLabelWithTitle:@"alertSetting"
                                                          setting:settings.alertSetting]];
    
    [self.stackView addArrangedSubview:[self createLabelWithTitle:@"notificationCenterSetting"
                                                          setting:settings.notificationCenterSetting]];
    
    [self.stackView addArrangedSubview:[self createLabelWithTitle:@"lockScreenSetting"
                                                          setting:settings.lockScreenSetting]];
    
    [self.stackView addArrangedSubview:[self createLabelWithTitle:@"carPlaySetting"
                                                          setting:settings.carPlaySetting]];
    
    [self.stackView addArrangedSubview:[self createLabelWithTitle:@"alertStyle"
                                                          setting:settings.alertStyle]];
    
}

- (UILabel*) createLabelWithTitle:(NSString*)title setting:(NSInteger)settingId
{
    NSArray * settingNames = @[@"❓", @"👍", @"👎"];
    
    UILabel * label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%@:%@", title, settingNames[settingId]];
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

@end
