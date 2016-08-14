//
//  LocalNotification.h
//  TryUserNotifications
//
//  Created by Andrew on 07/08/16.
//  Copyright © 2016 Andrey Tokarev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotification : NSObject // Builder

@property (nonatomic, strong) NSString * body;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * subtitle;
@property (nonatomic, strong) NSString * contentIdentifier;
@property (nonatomic, strong) NSString * categoryIdentifier;

- (void) addAttachementFromUrl:(NSURL*)attachmentUrl
                         error:(NSError**)error;

- (void) sheduleWithTimeInterval:(NSTimeInterval)triggerTimeInterval
                    shouldRepeat:(BOOL)shouldRepeat
           withCompletionHandler:(void(^)(NSError * error))completionHandler;

@end
