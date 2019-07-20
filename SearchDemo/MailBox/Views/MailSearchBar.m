//
//  MailSearchBar.m
//  SearchDemo
//
//  Created by 王欢 on 2019/7/21.
//  Copyright © 2019 王欢. All rights reserved.
//

#import "MailSearchBar.h"
#import "Masonry.h"
#import "UIView+Layout.h"

// constants
static const CGFloat kHMargin = 20.0f;
static const CGFloat kHeight = 44.0f;

@interface MailSearchBar ()

@property (nonatomic, weak) UITextField *textField;

@end

@implementation MailSearchBar

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
    UITextField *textField = [self createTextField];
    [self addSubview:textField];
    self.textField = textField;
    
    UIView *separator = [self createSeparator];
    [self addSubview:separator];
    
    // layout
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textField.superview).offset(kHMargin);
        make.right.equalTo(textField.superview).offset(-kHMargin);
        make.centerY.equalTo(textField.superview);
    }];
    
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(separator.height);
        make.left.right.equalTo(separator.superview);
        make.bottom.equalTo(separator.superview);
    }];
}

- (UITextField *)createTextField {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    textField.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:232.0/255.0 blue:234.0/255.0 alpha:1.0];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"搜索";
    textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}

- (UIView *)createSeparator {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.5)];
    view.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:199.0/255.0 blue:203.0/255.0 alpha:1.0];
    return view;
}

@end
