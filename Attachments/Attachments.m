//
//  Attachments.m
//  TryUserNotifications
//
//  Created by Andrew on 17/08/16.
//  Copyright © 2016 Andrey Tokarev. All rights reserved.
//

#import "Attachments.h"

@implementation Attachments

+ (NSURL*) mediaAttachmentUrlAtIndex:(NSInteger)index
{
    switch (index) {
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

+ (NSURL *)createMediaAttachmentUrlForFilename:(NSString*)filename
                                        ofType:(NSString*)type
{
    return [[NSBundle mainBundle] URLForResource:filename
                                   withExtension:type];
}

@end
