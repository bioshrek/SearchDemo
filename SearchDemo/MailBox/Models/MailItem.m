//
//  MailItem.m
//  SearchDemo
//
//  Created by 王欢 on 2019/7/13.
//  Copyright © 2019 王欢. All rights reserved.
//

#import "MailItem.h"

@implementation MailItem

+ (instancetype)mailWithSender:(NSString *)sender
                       subject:(NSString *)subject
                       cotnent:(NSString *)content
                          time:(NSTimeInterval)time {
    MailItem *mail = [[MailItem alloc] init];
    mail.sender = sender;
    mail.subject = sender;
    mail.content = content;
    mail.time = time;
    return mail;
}

@end
