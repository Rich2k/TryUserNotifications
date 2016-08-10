//
//  LocalNotificationTests.m
//  TryUserNotifications
//
//  Created by Andrew on 10/08/16.
//  Copyright © 2016 Andrey Tokarev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocalNotification.h"
@import UserNotifications;

@interface LocalNotification(/*private*/)
- (UNNotificationContent*)createNotificationContent;
@end

@interface LocalNotificationTests : XCTestCase
@end

@implementation LocalNotificationTests

- (void)testAddAttachmentTitle {
    LocalNotification *
    localNotification = [LocalNotification new];
    localNotification.title = @"text";
    
    UNNotificationContent * content = [localNotification createNotificationContent];
    
    XCTAssertEqual(@"text", content.title);
}

- (void)testAddAttachmentBody {
    LocalNotification *
    localNotification = [LocalNotification new];
    localNotification.body = @"text";
    
    UNNotificationContent * content = [localNotification createNotificationContent];
    
    XCTAssertEqual(@"text", content.body);
}

- (void)testAddAttachmentSubtitle {
    LocalNotification *
    localNotification = [LocalNotification new];
    localNotification.subtitle = @"text";
    
    UNNotificationContent * content = [localNotification createNotificationContent];
    
    XCTAssertEqual(@"text", content.subtitle);
}

- (void)testAddAttachmentNil;
{
    NSURL   * attachmentUrl = nil;
    NSError * error = nil;
    
    LocalNotification *
    localNotification = [LocalNotification new];
    [localNotification addAttachementFromUrl:attachmentUrl
                                       error:&error];

    XCTAssertNil(error);
    
    UNNotificationContent * content = [localNotification createNotificationContent];
    
    XCTAssertEqual(0, content.attachments.count);
}

- (void)testAddAttachment
{
    NSURL   * attachmentUrl = [self createAttachmentUrl];
    NSError * error = nil;
    
    

    LocalNotification *
     localNotification = [LocalNotification new];
    [localNotification addAttachementFromUrl:attachmentUrl
                                       error:&error];
    XCTAssertNil(error);
    
    UNNotificationContent * content = [localNotification createNotificationContent];
    UNNotificationAttachment * attachment = [content.attachments firstObject];
    
    XCTAssertNotNil(attachment);
    
    XCTAssertEqualObjects(attachmentUrl,       attachment.URL);
    XCTAssertEqualObjects(@"attachment-1.jpg", attachment.identifier);
    XCTAssertEqualObjects(@"public.jpeg",      attachment.type);
}

- (void) testCreateAttachmentUrl {
    NSURL * attachmentUrl = [self createAttachmentUrl];
    XCTAssertNotNil(attachmentUrl);
    
    NSData * data = [NSData dataWithContentsOfURL:attachmentUrl];
    
    XCTAssertNotNil(data);
    
    UIImage * image = [UIImage imageWithData:data];
    XCTAssertNotNil(image);
}

- (NSURL*) createAttachmentUrl {
    return [[NSBundle mainBundle] URLForResource:@"attachment-1" withExtension:@"jpg"];
}

@end
