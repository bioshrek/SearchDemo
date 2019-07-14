//
//  MailItemCell.m
//  SearchDemo
//
//  Created by 王欢 on 2019/7/13.
//  Copyright © 2019 王欢. All rights reserved.
//

#import "MailItemCell.h"
#import "Masonry.h"

// constants

static const CGFloat kVMargin = 8.0f;
static const CGFloat kLeftMargin = 30.0f;
static const CGFloat kRightMargin = 8.0f;

@interface MailItemCell ()

@property (nonatomic, weak, readwrite) UILabel *titleLabel;
@property (nonatomic, weak, readwrite) UILabel *subTitleLabel;
@property (nonatomic, weak, readwrite) UILabel *briefLabel;
@property (nonatomic, weak, readwrite) UILabel *timeLabel;

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
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    [self addSubview:subTitleLabel];
    self.subTitleLabel = subTitleLabel;
    
    UILabel *briefLabel = [[UILabel alloc] init];
    [self addSubview:briefLabel];
    self.briefLabel = briefLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
}

@end
