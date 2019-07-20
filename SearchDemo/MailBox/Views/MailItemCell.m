//
//  MailItemCell.m
//  SearchDemo
//
//  Created by 王欢 on 2019/7/13.
//  Copyright © 2019 王欢. All rights reserved.
//

#import "MailItemCell.h"
#import "Masonry.h"
#import "UIView+Layout.h"

// constants

static const CGFloat kVMargin = 8.0f;
static const CGFloat kLeftMargin = 30.0f;
static const CGFloat kRightMargin = 20.0f;
static const CGFloat kSpacing_title_time = 8.0f;
static const CGFloat kSpacing_title_subTitle = 5.0f;
static const CGFloat kSpacing_subTitle_brief = 3.0f;
static const CGFloat kSpacing_time_arrow = 10.0f;

@interface MailItemCell ()

@property (nonatomic, weak, readwrite) UILabel *titleLabel;
@property (nonatomic, weak, readwrite) UILabel *subTitleLabel;
@property (nonatomic, weak, readwrite) UILabel *briefLabel;
@property (nonatomic, weak, readwrite) UILabel *timeLabel;
@property (nonatomic, weak, readwrite) UIImageView *arrowImageView;

@end

@implementation MailItemCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

#pragma mark - Views

- (void)setupViews {
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:subTitleLabel];
    self.subTitleLabel = subTitleLabel;
    
    UILabel *briefLabel = [[UILabel alloc] init];
    briefLabel.numberOfLines = 2;
    [self.contentView addSubview:briefLabel];
    self.briefLabel = briefLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
    [self.contentView addSubview:arrowImageView];
    
    UIView *separator = [self createSeparator];
    [self.contentView addSubview:separator];
    
    // layouts
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.superview).offset(kVMargin);
        make.left.equalTo(titleLabel.superview).offset(kLeftMargin);
        [titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.left.equalTo(titleLabel.mas_right).offset(kSpacing_title_time);
        [timeLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [timeLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }];
    
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.right.equalTo(arrowImageView.superview).offset(-kRightMargin);
        make.left.equalTo(timeLabel.mas_right).offset(kSpacing_time_arrow);
        [arrowImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [arrowImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }];
    
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(subTitleLabel.superview).offset(kLeftMargin);
        make.right.equalTo(subTitleLabel.superview).offset(-kRightMargin);
        make.top.equalTo(titleLabel.mas_bottom).offset(kSpacing_title_subTitle);
    }];
    
    [briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(briefLabel.superview).offset(kLeftMargin);
        make.right.equalTo(briefLabel.superview).offset(-kRightMargin);
        make.top.equalTo(subTitleLabel.mas_bottom).offset(kSpacing_subTitle_brief);
    }];
    
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(separator.height);
        make.left.equalTo(separator.superview).offset(kLeftMargin);
        make.right.equalTo(separator.superview);
        make.bottom.equalTo(separator.superview);
    }];
}

- (UIView *)createSeparator {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.5)];
    view.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:199.0/255.0 blue:203.0/255.0 alpha:1.0];
    return view;
}

@end
