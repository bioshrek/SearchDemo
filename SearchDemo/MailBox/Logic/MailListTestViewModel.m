//
//  MailListTestViewModel.m
//  SearchDemo
//
//  Created by 王欢 on 2019/7/13.
//  Copyright © 2019 王欢. All rights reserved.
//

#import "MailListTestViewModel.h"
#import "MailItem.h"
#import "MailItemTestViewModel.h"
#import "NSDate+DateTools.h"
#import "NSDateFormatter+Create.h"

// constants

static const CGFloat kSenderFontSize = 15.0f;
static const CGFloat kSubjectFontSize = 13.0f;
static const CGFloat kContentFontSize = 13.0f;
static const CGFloat kTimeFontSize = 13.0f;

static NSString * const kDateFormatterKey_withinToday = @"within today";
static NSString * const kDateFormatterKey_withinWeek = @"within week";
static NSString * const kDateFormatterKey_other = @"other";

@interface MailListTestViewModel ()

@property (nonatomic, strong) NSArray<MailItemTestViewModel *> *viewModels;

@end

@implementation MailListTestViewModel

#pragma mark - MailListViewModelProtocol

- (void)loadDataCompleted:(void (^)(void))completionBlock {
    NSArray<MailItem *> *mails = [self loadMails];
    NSArray<MailItem *> *sortedMails = [mails sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:false] ]];
    self.viewModels = [self.class viewModelsFromMails:sortedMails];
    if (completionBlock) {
        completionBlock();
    }
}

- (NSInteger)mailCount {
    return self.viewModels.count;
}

- (id<MailItemViewModelProtocol>)mailViewModelAtIndex:(NSInteger)idx {
    const BOOL validIndex = (0 <= idx && idx < self.viewModels.count);
    return validIndex ? self.viewModels[idx] : nil;
}

#pragma mark - Mail -> View Model

+ (NSArray<MailItemTestViewModel *> *)viewModelsFromMails:(NSArray<MailItem *> *)mails {
    NSMutableArray<MailItemTestViewModel *> *viewModels = [[NSMutableArray<MailItemTestViewModel *> alloc] initWithCapacity:mails.count];
    for (MailItem *mail in mails) {
        @autoreleasepool {
            MailItemTestViewModel *viewModel = [[MailItemTestViewModel alloc] init];
            viewModel.titleText = [self attrTextFromSender:mail.sender];
            viewModel.subTitleText = [self attrTextFromSubject:mail.subject];
            viewModel.briefText = [self attrTextFromBrief:[self briefFromContent:mail.content]];
            viewModel.timeText = [self attrTextFromTime:mail.time];
            [viewModels addObject:viewModel];
            viewModel = nil;
        }
    }
    return viewModels.copy;
}

+ (NSAttributedString *)attrTextFromSender:(NSString *)sender {
    return [self attributedTextWithText:sender ?: @"[unknow]"
                                   font:[UIFont systemFontOfSize:kSenderFontSize weight:UIFontWeightBold]
                              textColor:[UIColor darkTextColor]];
}

+ (NSAttributedString *)attrTextFromSubject:(NSString *)subject {
    return [self attributedTextWithText:subject ?: @"[no subject]"
                                   font:[UIFont systemFontOfSize:kSubjectFontSize weight:UIFontWeightRegular]
                              textColor:[UIColor darkTextColor]];
}

+ (NSString *)briefFromContent:(NSString *)content {
    // TODO: get brief from content
    return content;
}

+ (NSAttributedString *)attrTextFromBrief:(NSString *)brief {
    return [self attributedTextWithText:brief
                                   font:[UIFont systemFontOfSize:kContentFontSize weight:UIFontWeightRegular]
                              textColor:self.lightGrayColor];
}

+ (NSAttributedString *)attrTextFromTime:(NSTimeInterval)time {
    return [self attributedTextWithText:[self textFromTime:time]
                                   font:[UIFont systemFontOfSize:kTimeFontSize weight:UIFontWeightRegular]
                              textColor:self.lightGrayColor];
}

+ (NSString *)textFromTime:(NSTimeInterval)time {
    // within today: 下午 10:50，上午 3:30
    // within yestody: 昨天
    // within this week: 星期四，星期三
    // Year/Month/Day
    
    static NSDictionary<NSString *, NSDateFormatter *> *formatterDict;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        formatterDict = @{
                          kDateFormatterKey_withinToday : [NSDateFormatter dateFormatterWithFormat:@"a h:m"],
                          kDateFormatterKey_withinWeek : [NSDateFormatter dateFormatterWithFormat:@"EEEE"],
                          kDateFormatterKey_other : [NSDateFormatter dateFormatterWithFormat:@"YYYY/M/d"],
                          };
    });
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    if (date.isToday) {
        return [formatterDict[kDateFormatterKey_withinToday] stringFromDate:date];
    }
    if (date.isYesterday) {
        return @"昨天";
    }
    const BOOL sameWeek = date.weekOfYear == [NSDate date].weekOfYear;
    if (sameWeek) {
        return [formatterDict[kDateFormatterKey_withinWeek] stringFromDate:date];
    }
    
    return [formatterDict[kDateFormatterKey_other] stringFromDate:date];
}

+ (UIColor *)lightGrayColor {
    return [UIColor colorWithRed:126.0/255.0 green:128.0/255.0 blue:129.0/255.0 alpha:1.0];
}

+ (NSAttributedString *)attributedTextWithText:(NSString *)text
                                          font:(UIFont *)font
                                     textColor:(UIColor *)textColor {
    return [[NSAttributedString alloc] initWithString:text ?: @""
                                           attributes:@{
                                                        NSFontAttributeName : font ?: [UIFont systemFontOfSize:UIFont.systemFontSize],
                                                        NSForegroundColorAttributeName : textColor ?: [UIColor darkTextColor],
                                                        }];
}

#pragma mark - Loading Mails

- (NSArray<MailItem *> *)loadMails {
    return @[
             [MailItem mailWithSender:@"DigitalOcean - Thanks for using DigitalOcean bla bla bla bla bla bla bla bla" subject:@"[DigitalOcean] Thanks for your payment" cotnent:@"Thanks for using DigitalOcean\nYour past due balance is now settled, so you’re all set!\nSummary for shrekwang1\nPast due balance$1.91\nAmount paid$5.00" time:[NSDate dateWithTimeIntervalSinceNow:-3600*24*10].timeIntervalSince1970],
             [MailItem mailWithSender:@"Steam" subject:@"An item on your Steam wishlist is on sale!" cotnent:@"Hello shrekwang1!\nThe following items on your wishlist are on sale:\nTrine 3: The Artifacts of Power\nTrine 3: The Artifacts of Power\nSPECIAL PROMOTION! Offer ends 26 Jul 1:00am CST\n-75%    ¥ 72\n¥ 18\nSpecific pricing and discounts may be subject to change. Please check the Steam store page for details.\nYou're receiving this mail because the item(s) above are on your Steam Wishlist.\nIf you prefer not to receive wishlist notification mails in the future, you can modify your email preferences or unsubscribe." time:[NSDate dateWithTimeIntervalSinceNow:-3600*24*6].timeIntervalSince1970],
             [MailItem mailWithSender:@"拉勾网" subject:@"阿里内部技术干货流出！速看！" cotnent:@"社招进阿里最重要的是什么？\n\n阿里招人最不看重学历？\n\n阿里技术大佬平时都怎么工作？\n\n阿里P5、P6、P7层级究竟怎么划分？\n\n程序员不转管理就死路一条？\n\n日常工作偏向业务，那么如何提升自己的架构能力？\n\n\n\n你想知道这些内幕消息吗？\n\n扫描下方二维码，加程序员B计划好友，B哥为你揭秘" time:[NSDate dateWithTimeIntervalSinceNow:-3600*24*4].timeIntervalSince1970],
             [MailItem mailWithSender:@"Steam" subject:@"An item on your Steam wishlist is on sale!" cotnent:@"Hello shrekwang1!\nThe following items on your wishlist are on sale:\nTrine 3: The Artifacts of Power\nTrine 3: The Artifacts of Power\nSPECIAL PROMOTION! Offer ends 26 Jul 1:00am CST\n-75%    ¥ 72\n¥ 18\nSpecific pricing and discounts may be subject to change. Please check the Steam store page for details.\nYou're receiving this mail because the item(s) above are on your Steam Wishlist.\nIf you prefer not to receive wishlist notification mails in the future, you can modify your email preferences or unsubscribe." time:[NSDate dateWithTimeIntervalSinceNow:-3600*24*5].timeIntervalSince1970],
             [MailItem mailWithSender:@"DigitalOcean" subject:@"[DigitalOcean] Thanks for your payment" cotnent:@"Thanks for using DigitalOcean\nYour past due balance is now settled, so you’re all set!\nSummary for shrekwang1\nPast due balance$1.91\nAmount paid$5.00" time:[NSDate dateWithTimeIntervalSinceNow:-3600*24*2].timeIntervalSince1970],
             [MailItem mailWithSender:@"Steam" subject:@"An item on your Steam wishlist is on sale!" cotnent:@"Hello shrekwang1!\nThe following items on your wishlist are on sale:\nTrine 3: The Artifacts of Power\nTrine 3: The Artifacts of Power\nSPECIAL PROMOTION! Offer ends 26 Jul 1:00am CST\n-75%    ¥ 72\n¥ 18\nSpecific pricing and discounts may be subject to change. Please check the Steam store page for details.\nYou're receiving this mail because the item(s) above are on your Steam Wishlist.\nIf you prefer not to receive wishlist notification mails in the future, you can modify your email preferences or unsubscribe." time:[NSDate dateWithTimeIntervalSinceNow:-3600*24].timeIntervalSince1970],
             [MailItem mailWithSender:@"拉勾网" subject:@"阿里内部技术干货流出！速看！" cotnent:@"社招进阿里最重要的是什么？\n\n阿里招人最不看重学历？\n\n阿里技术大佬平时都怎么工作？\n\n阿里P5、P6、P7层级究竟怎么划分？\n\n程序员不转管理就死路一条？\n\n日常工作偏向业务，那么如何提升自己的架构能力？\n\n\n\n你想知道这些内幕消息吗？\n\n扫描下方二维码，加程序员B计划好友，B哥为你揭秘" time:[NSDate dateWithTimeIntervalSinceNow:-3600*14].timeIntervalSince1970],
             [MailItem mailWithSender:@"Steam" subject:@"An item on your Steam wishlist is on sale!" cotnent:@"Hello shrekwang1!\nThe following items on your wishlist are on sale:\nTrine 3: The Artifacts of Power\nTrine 3: The Artifacts of Power\nSPECIAL PROMOTION! Offer ends 26 Jul 1:00am CST\n-75%    ¥ 72\n¥ 18\nSpecific pricing and discounts may be subject to change. Please check the Steam store page for details.\nYou're receiving this mail because the item(s) above are on your Steam Wishlist.\nIf you prefer not to receive wishlist notification mails in the future, you can modify your email preferences or unsubscribe." time:NSDate.date.timeIntervalSince1970],
             [MailItem mailWithSender:@"DigitalOcean - Thanks for using DigitalOcean bla bla bla bla bla bla bla bla" subject:@"[DigitalOcean] Thanks for your payment" cotnent:@"Thanks for using DigitalOcean\nYour past due balance is now settled, so you’re all set!\nSummary for shrekwang1\nPast due balance$1.91\nAmount paid$5.00" time:[NSDate dateWithTimeIntervalSinceNow:-3600*24*10].timeIntervalSince1970],
             [MailItem mailWithSender:@"Steam" subject:@"An item on your Steam wishlist is on sale!" cotnent:@"Hello shrekwang1!\nThe following items on your wishlist are on sale:\nTrine 3: The Artifacts of Power\nTrine 3: The Artifacts of Power\nSPECIAL PROMOTION! Offer ends 26 Jul 1:00am CST\n-75%    ¥ 72\n¥ 18\nSpecific pricing and discounts may be subject to change. Please check the Steam store page for details.\nYou're receiving this mail because the item(s) above are on your Steam Wishlist.\nIf you prefer not to receive wishlist notification mails in the future, you can modify your email preferences or unsubscribe." time:[NSDate dateWithTimeIntervalSinceNow:-3600*24*6].timeIntervalSince1970],
             [MailItem mailWithSender:@"拉勾网" subject:@"阿里内部技术干货流出！速看！" cotnent:@"社招进阿里最重要的是什么？\n\n阿里招人最不看重学历？\n\n阿里技术大佬平时都怎么工作？\n\n阿里P5、P6、P7层级究竟怎么划分？\n\n程序员不转管理就死路一条？\n\n日常工作偏向业务，那么如何提升自己的架构能力？\n\n\n\n你想知道这些内幕消息吗？\n\n扫描下方二维码，加程序员B计划好友，B哥为你揭秘" time:[NSDate dateWithTimeIntervalSinceNow:-3600*24*4].timeIntervalSince1970],
             [MailItem mailWithSender:@"Steam" subject:@"An item on your Steam wishlist is on sale!" cotnent:@"Hello shrekwang1!\nThe following items on your wishlist are on sale:\nTrine 3: The Artifacts of Power\nTrine 3: The Artifacts of Power\nSPECIAL PROMOTION! Offer ends 26 Jul 1:00am CST\n-75%    ¥ 72\n¥ 18\nSpecific pricing and discounts may be subject to change. Please check the Steam store page for details.\nYou're receiving this mail because the item(s) above are on your Steam Wishlist.\nIf you prefer not to receive wishlist notification mails in the future, you can modify your email preferences or unsubscribe." time:[NSDate dateWithTimeIntervalSinceNow:-3600*24*5].timeIntervalSince1970],
             [MailItem mailWithSender:@"DigitalOcean" subject:@"[DigitalOcean] Thanks for your payment" cotnent:@"Thanks for using DigitalOcean\nYour past due balance is now settled, so you’re all set!\nSummary for shrekwang1\nPast due balance$1.91\nAmount paid$5.00" time:[NSDate dateWithTimeIntervalSinceNow:-3600*24*2].timeIntervalSince1970],
             [MailItem mailWithSender:@"Steam" subject:@"An item on your Steam wishlist is on sale!" cotnent:@"Hello shrekwang1!\nThe following items on your wishlist are on sale:\nTrine 3: The Artifacts of Power\nTrine 3: The Artifacts of Power\nSPECIAL PROMOTION! Offer ends 26 Jul 1:00am CST\n-75%    ¥ 72\n¥ 18\nSpecific pricing and discounts may be subject to change. Please check the Steam store page for details.\nYou're receiving this mail because the item(s) above are on your Steam Wishlist.\nIf you prefer not to receive wishlist notification mails in the future, you can modify your email preferences or unsubscribe." time:[NSDate dateWithTimeIntervalSinceNow:-3600*24].timeIntervalSince1970],
             [MailItem mailWithSender:@"拉勾网" subject:@"阿里内部技术干货流出！速看！" cotnent:@"社招进阿里最重要的是什么？\n\n阿里招人最不看重学历？\n\n阿里技术大佬平时都怎么工作？\n\n阿里P5、P6、P7层级究竟怎么划分？\n\n程序员不转管理就死路一条？\n\n日常工作偏向业务，那么如何提升自己的架构能力？\n\n\n\n你想知道这些内幕消息吗？\n\n扫描下方二维码，加程序员B计划好友，B哥为你揭秘" time:[NSDate dateWithTimeIntervalSinceNow:-3600*14].timeIntervalSince1970],
             [MailItem mailWithSender:@"Steam" subject:@"An item on your Steam wishlist is on sale!" cotnent:@"Hello shrekwang1!\nThe following items on your wishlist are on sale:\nTrine 3: The Artifacts of Power\nTrine 3: The Artifacts of Power\nSPECIAL PROMOTION! Offer ends 26 Jul 1:00am CST\n-75%    ¥ 72\n¥ 18\nSpecific pricing and discounts may be subject to change. Please check the Steam store page for details.\nYou're receiving this mail because the item(s) above are on your Steam Wishlist.\nIf you prefer not to receive wishlist notification mails in the future, you can modify your email preferences or unsubscribe." time:NSDate.date.timeIntervalSince1970],
             [MailItem mailWithSender:@"DigitalOcean - Thanks for using DigitalOcean bla bla bla bla bla bla bla bla" subject:@"[DigitalOcean] Thanks for your payment" cotnent:@"Thanks for using DigitalOcean\nYour past due balance is now settled, so you’re all set!\nSummary for shrekwang1\nPast due balance$1.91\nAmount paid$5.00" time:[NSDate dateWithTimeIntervalSinceNow:-3600*24*10].timeIntervalSince1970],
             [MailItem mailWithSender:@"Steam" subject:@"An item on your Steam wishlist is on sale!" cotnent:@"Hello shrekwang1!\nThe following items on your wishlist are on sale:\nTrine 3: The Artifacts of Power\nTrine 3: The Artifacts of Power\nSPECIAL PROMOTION! Offer ends 26 Jul 1:00am CST\n-75%    ¥ 72\n¥ 18\nSpecific pricing and discounts may be subject to change. Please check the Steam store page for details.\nYou're receiving this mail because the item(s) above are on your Steam Wishlist.\nIf you prefer not to receive wishlist notification mails in the future, you can modify your email preferences or unsubscribe." time:[NSDate dateWithTimeIntervalSinceNow:-3600*24*6].timeIntervalSince1970],
             [MailItem mailWithSender:@"拉勾网" subject:@"阿里内部技术干货流出！速看！" cotnent:@"社招进阿里最重要的是什么？\n\n阿里招人最不看重学历？\n\n阿里技术大佬平时都怎么工作？\n\n阿里P5、P6、P7层级究竟怎么划分？\n\n程序员不转管理就死路一条？\n\n日常工作偏向业务，那么如何提升自己的架构能力？\n\n\n\n你想知道这些内幕消息吗？\n\n扫描下方二维码，加程序员B计划好友，B哥为你揭秘" time:[NSDate dateWithTimeIntervalSinceNow:-3600*24*4].timeIntervalSince1970],
             [MailItem mailWithSender:@"Steam" subject:@"An item on your Steam wishlist is on sale!" cotnent:@"Hello shrekwang1!\nThe following items on your wishlist are on sale:\nTrine 3: The Artifacts of Power\nTrine 3: The Artifacts of Power\nSPECIAL PROMOTION! Offer ends 26 Jul 1:00am CST\n-75%    ¥ 72\n¥ 18\nSpecific pricing and discounts may be subject to change. Please check the Steam store page for details.\nYou're receiving this mail because the item(s) above are on your Steam Wishlist.\nIf you prefer not to receive wishlist notification mails in the future, you can modify your email preferences or unsubscribe." time:[NSDate dateWithTimeIntervalSinceNow:-3600*24*5].timeIntervalSince1970],
             [MailItem mailWithSender:@"DigitalOcean" subject:@"[DigitalOcean] Thanks for your payment" cotnent:@"Thanks for using DigitalOcean\nYour past due balance is now settled, so you’re all set!\nSummary for shrekwang1\nPast due balance$1.91\nAmount paid$5.00" time:[NSDate dateWithTimeIntervalSinceNow:-3600*24*2].timeIntervalSince1970],
             [MailItem mailWithSender:@"Steam" subject:@"An item on your Steam wishlist is on sale!" cotnent:@"Hello shrekwang1!\nThe following items on your wishlist are on sale:\nTrine 3: The Artifacts of Power\nTrine 3: The Artifacts of Power\nSPECIAL PROMOTION! Offer ends 26 Jul 1:00am CST\n-75%    ¥ 72\n¥ 18\nSpecific pricing and discounts may be subject to change. Please check the Steam store page for details.\nYou're receiving this mail because the item(s) above are on your Steam Wishlist.\nIf you prefer not to receive wishlist notification mails in the future, you can modify your email preferences or unsubscribe." time:[NSDate dateWithTimeIntervalSinceNow:-3600*24].timeIntervalSince1970],
             [MailItem mailWithSender:@"拉勾网" subject:@"阿里内部技术干货流出！速看！" cotnent:@"社招进阿里最重要的是什么？\n\n阿里招人最不看重学历？\n\n阿里技术大佬平时都怎么工作？\n\n阿里P5、P6、P7层级究竟怎么划分？\n\n程序员不转管理就死路一条？\n\n日常工作偏向业务，那么如何提升自己的架构能力？\n\n\n\n你想知道这些内幕消息吗？\n\n扫描下方二维码，加程序员B计划好友，B哥为你揭秘" time:[NSDate dateWithTimeIntervalSinceNow:-3600*14].timeIntervalSince1970],
             [MailItem mailWithSender:@"Steam" subject:@"An item on your Steam wishlist is on sale!" cotnent:@"Hello shrekwang1!\nThe following items on your wishlist are on sale:\nTrine 3: The Artifacts of Power\nTrine 3: The Artifacts of Power\nSPECIAL PROMOTION! Offer ends 26 Jul 1:00am CST\n-75%    ¥ 72\n¥ 18\nSpecific pricing and discounts may be subject to change. Please check the Steam store page for details.\nYou're receiving this mail because the item(s) above are on your Steam Wishlist.\nIf you prefer not to receive wishlist notification mails in the future, you can modify your email preferences or unsubscribe." time:NSDate.date.timeIntervalSince1970],
             ];
}

@end
