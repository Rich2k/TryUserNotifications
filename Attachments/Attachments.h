//
//  Attachments.h
//  TryUserNotifications
//
//  Created by Andrew on 17/08/16.
//  Copyright © 2016 Andrey Tokarev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Attachments : NSObject

/* 
   index: 1 - 4 
 */
+ (NSURL*) mediaAttachmentUrlAtIndex:(NSInteger)index;

@end
