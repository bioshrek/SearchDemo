//
//  ScrollViewTopDragHelper.h
//  SearchDemo
//
//  Created by 王欢 on 2019/7/21.
//  Copyright © 2019 王欢. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollViewTopDragHelper : NSObject <UIScrollViewDelegate>

@property (nonatomic, assign, readonly) CGFloat topInset;

- (instancetype)initWithTopInset:(CGFloat)topInset;

@end

NS_ASSUME_NONNULL_END
