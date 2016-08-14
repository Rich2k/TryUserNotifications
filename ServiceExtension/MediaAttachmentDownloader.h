//
//  MediaAttachmentDownloader.h
//  TryUserNotifications
//
//  Created by Andrew on 14/08/16.
//  Copyright © 2016 Andrey Tokarev. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>

typedef void(^AttachmentDownloadCompletionHandler)(UNNotificationAttachment * attachment, NSError * error);

@interface MediaAttachmentDownloader : NSObject

- (void) downloadAttchmentWithUrl:(NSURL*)attchmentUrl
                completionHandler:(AttachmentDownloadCompletionHandler)completionHandler;

- (void) cancel;

@end
