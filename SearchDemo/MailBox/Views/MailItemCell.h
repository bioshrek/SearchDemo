//
//  MailItemCell.h
//  SearchDemo
//
//  Created by 王欢 on 2019/7/13.
//  Copyright © 2019 王欢. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MailItemCell : UICollectionViewCell

@property (nonatomic, weak, readonly) UILabel *titleLabel;
@property (nonatomic, weak, readonly) UILabel *subTitleLabel;
@property (nonatomic, weak, readonly) UILabel *briefLabel;
@property (nonatomic, weak, readonly) UILabel *timeLabel;

@end

NS_ASSUME_NONNULL_END
