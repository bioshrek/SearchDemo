//
//  MailItem.h
//  SearchDemo
//
//  Created by 王欢 on 2019/7/13.
//  Copyright © 2019 王欢. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MailItem : NSObject

@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSTimeInterval time;

+ (instancetype)mailWithSender:(NSString *)sender
                       subject:(NSString *)subject
                       cotnent:(NSString *)content
                          time:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
