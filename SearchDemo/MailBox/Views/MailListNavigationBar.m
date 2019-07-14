//
//  MailListNavigationBar.m
//  SearchDemo
//
//  Created by 王欢 on 2019/7/13.
//  Copyright © 2019 王欢. All rights reserved.
//

#import "MailListNavigationBar.h"
#import "Masonry.h"

// constants

static const CGFloat kTitleFontSize = 17.0f;
static const CGFloat kNavigationBarHeight = 44.0f;
static const CGFloat kDefaultStatusBarHeight = 20.0f;

@interface MailListNavigationBar ()

@property (nonatomic, weak, readwrite) UILabel *titleLabel;

@end

@implementation MailListNavigationBar

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)safeAreaInsetsDidChange {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(self.navigationBarHeight);
    }];
    [self.superview setNeedsLayout];
}

#pragma mark - Views

- (void)setupViews {
    UILabel *titleLabel = [self createTitleLabel];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(titleLabel.superview);
        make.centerY.equalTo(titleLabel.superview.mas_bottom).offset(-floor(kNavigationBarHeight/2.0f));
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(self.navigationBarHeight);
    }];
}

- (CGFloat)navigationBarHeight {
    return kNavigationBarHeight + (self.safeAreaInsets.top ?: kDefaultStatusBarHeight);
}

- (UILabel *)createTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor darkTextColor];
    label.font = [UIFont systemFontOfSize:kTitleFontSize weight:UIFontWeightBold];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end
