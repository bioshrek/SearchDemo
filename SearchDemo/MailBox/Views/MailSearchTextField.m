//
//  MailSearchTextField.m
//  SearchDemo
//
//  Created by 王欢 on 2019/7/21.
//  Copyright © 2019 王欢. All rights reserved.
//

#import "MailSearchTextField.h"
#import "Masonry.h"

// constants

static const CGFloat kHeight = 35.0f;
static const CGFloat kCornerRadius = 10.0f;
static const CGFloat kLeftViewHMargin = 8.0f;

@interface MailSearchTextField ()

@property (nonatomic, weak, readwrite) UITextField *textField;

@end

@implementation MailSearchTextField

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    const CGSize boundingSize = [super sizeThatFits:size];
    return CGSizeMake(boundingSize.width, kHeight);
}

+ (CGFloat)prefferedHeight {
    return kHeight;
}

#pragma mark - Views

- (void)setupViews {
    self.layer.cornerRadius = kCornerRadius;
    self.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:232.0/255.0 blue:234.0/255.0 alpha:1.0];
    self.clipsToBounds = YES;
    
    UITextField *textField = [self createTextField];
    [self addSubview:textField];
    self.textField = textField;
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    [self addSubview:leftImageView];
    
    // layout
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.superview).offset(kLeftViewHMargin);
        make.centerY.equalTo(leftImageView.superview);
        [leftImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [leftImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.mas_right).offset(kLeftViewHMargin);
        make.right.equalTo(textField.superview);
        make.centerY.equalTo(textField.superview);
        [textField setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [textField setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }];
}

- (UITextField *)createTextField {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    textField.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:232.0/255.0 blue:234.0/255.0 alpha:1.0];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = @"搜索";
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}

@end
