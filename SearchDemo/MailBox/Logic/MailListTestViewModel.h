//
//  MailListTestViewModel.h
//  SearchDemo
//
//  Created by 王欢 on 2019/7/13.
//  Copyright © 2019 王欢. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailListViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Testing data for mail list
 *
 * !!!fix me: not thread safety
 */
@interface MailListTestViewModel : NSObject <MailListViewModelProtocol>

@end

NS_ASSUME_NONNULL_END
