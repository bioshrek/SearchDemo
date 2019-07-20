//
//  MailSearchTextField.h
//  SearchDemo
//
//  Created by 王欢 on 2019/7/21.
//  Copyright © 2019 王欢. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MailSearchTextField : UIView

@property (nonatomic, weak, readonly) UITextField *textField;

@property (nonatomic, class, assign, readonly) CGFloat prefferedHeight;

@end

NS_ASSUME_NONNULL_END
