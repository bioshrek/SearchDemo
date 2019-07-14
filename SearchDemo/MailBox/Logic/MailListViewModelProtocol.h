//
//  MailListDataSource.h
//  SearchDemo
//
//  Created by 王欢 on 2019/7/13.
//  Copyright © 2019 王欢. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MailItemViewModelProtocol <NSObject>

@property (nonatomic, strong) NSAttributedString *titleText;
@property (nonatomic, strong) NSAttributedString *subTitleText;
@property (nonatomic, strong) NSAttributedString *briefText;
@property (nonatomic, strong) NSAttributedString *timeText;

@end

@protocol MailListViewModelProtocol <NSObject>

- (void)loadDataCompleted:(void (^)(void))completionBlock;

- (NSInteger)mailCount;
- (id<MailItemViewModelProtocol>)mailViewModelAtIndex:(NSInteger)idx;

@end

NS_ASSUME_NONNULL_END
