//
//  MediaAttachmentDownloader.m
//  TryUserNotifications
//
//  Created by Andrew on 14/08/16.
//  Copyright © 2016 Andrey Tokarev. All rights reserved.
//

#import "MediaAttachmentDownloader.h"

@interface MediaAttachmentDownloader()

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@end


@implementation MediaAttachmentDownloader

- (void) cancel {
    [self.downloadTask cancel];
}

- (void) downloadAttchmentWithUrl:(NSURL*)attchmentUrl
                completionHandler:(AttachmentDownloadCompletionHandler)completionHandler {
    
    if  (self.downloadTask) {
        [self.downloadTask cancel];
    }
    
    // Default configuration
    NSURLSessionConfiguration * sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Default session
    NSURLSession * session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    // Download task
    self.downloadTask = [session downloadTaskWithURL:attchmentUrl
                                   completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                       if (error) {
                                           completionHandler(nil, error);
                                       }
                                       else {
                                           [self handleDownloadedFileAtLocation:location
                                                                  fromSourceUrl:attchmentUrl
                                                              completionHandler:completionHandler];
                                       }
                                   }];
    // Start
    [self.downloadTask resume];
}

- (void) handleDownloadedFileAtLocation:(NSURL*)location
                          fromSourceUrl:(NSURL*)sourceUrl
                      completionHandler:(AttachmentDownloadCompletionHandler)completionHandler
{
    // Unfortunatelly we can't use location as is. UNNotificationAttachment infers type from file extension,
    // and temp url has something like xxx.tmp...
    // I hope this step will not be needed when iOS10 released
    
    // So we have to copy it temporary:
    NSError * error = nil;
    NSURL * temporaryAttachmentUrl = [self makeTemporaryCopyFileFromUrl:location
                                                                useName:[sourceUrl lastPathComponent]
                                                                  error:&error];
    if (error) {
        completionHandler(nil, error);
        return;
    }
    
    UNNotificationAttachment*
    notificationAttachment = [self createNotificationAttachment:temporaryAttachmentUrl
                                                          error:&error];
    if (notificationAttachment) {
        completionHandler(notificationAttachment, error);
    }
    if (error) {
        completionHandler(nil, error);
    }
    
    [self removeFileAtUrl: temporaryAttachmentUrl];
}

- (UNNotificationAttachment*) createNotificationAttachment:(NSURL*)attachmentUrl error:(NSError**)error
{
    NSLog(@"☝️Attachment Url: %@", attachmentUrl);
    
    return [UNNotificationAttachment
            attachmentWithIdentifier:@"image"
            URL:attachmentUrl
            options:nil
            error:error];
}

#pragma mark -

- (NSURL*) makeTemporaryCopyFileFromUrl:(NSURL*)location useName:(NSString*)name error:(NSError**)error
{
    if (!name) { name = location.lastPathComponent; }
    
    NSString * temporaryFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:name];
    NSURL * temporaryFileUrl = [NSURL fileURLWithPath:temporaryFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:temporaryFilePath]) {
        [[NSFileManager defaultManager] removeItemAtURL:temporaryFileUrl
                                                  error:nil];
    }
    if ([[NSFileManager defaultManager] copyItemAtURL:location
                                                toURL:temporaryFileUrl
                                                error:error]) {
        return temporaryFileUrl;
    }
    return nil;
}

- (void) removeFileAtUrl:(NSURL*)fileUrl {
    [[NSFileManager defaultManager]removeItemAtURL:fileUrl
                                             error:nil]; // handle?
}

@end
