//
//  NotificationService.m
//  ServiceExtension
//
//  Created by Andrew on 06/08/16.
//  Copyright © 2016 Andrey Tokarev. All rights reserved.
//

#import "NotificationService.h"
#import "MediaAttachmentDownloader.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *mutableContent;
@property (nonatomic, strong) MediaAttachmentDownloader *attachmentDownloader;
@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.mutableContent = [request.content mutableCopy];
    
    [self.attachmentDownloader
     downloadAttchmentWithUrl:self.attachmentUrl
     completionHandler:^(UNNotificationAttachment *attachment, NSError *error) {
         
         if (attachment) {
             self.mutableContent.attachments = @[attachment];
         }
         if (error) {
             // we will show error in notification
             self.mutableContent.title = [NSString stringWithFormat:@"[error] %@", self.mutableContent.title];
             self.mutableContent.body  = error.localizedDescription;
             self.mutableContent.subtitle = @"⛔️";
         }
         
         self.contentHandler(self.mutableContent);
     }];

    /* self.contentHandler(nil); // this does not change anything and notification delivered as is */
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    
    // cancel download
    [self.attachmentDownloader cancel];
    
    // update content
    self.mutableContent.title = [NSString stringWithFormat:@"[expired] %@", self.mutableContent.title];
    
    // deliver
    self.contentHandler(self.mutableContent);
}

- (MediaAttachmentDownloader*) attachmentDownloader {
    if(!_attachmentDownloader) {
        _attachmentDownloader = [MediaAttachmentDownloader new];
    }
    return _attachmentDownloader;
}

- (NSURL*) attachmentUrl {
    return [NSURL URLWithString:self.mutableContent.userInfo[@"image"]];
}

@end
