//
//  ScrollViewTopDragHelper.m
//  SearchDemo
//
//  Created by 王欢 on 2019/7/21.
//  Copyright © 2019 王欢. All rights reserved.
//

#import "ScrollViewTopDragHelper.h"

@interface ScrollViewTopDragHelper ()

@property (nonatomic, assign) BOOL searchBarVisible;
@property (nonatomic, assign) UIEdgeInsets oldContentInsets;

@end

@implementation ScrollViewTopDragHelper

- (instancetype)initWithTopInset:(CGFloat)topInset {
    if (self = [super init]) {
        _topInset = topInset;
    }
    return self;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.searchBarVisible) {
        const BOOL searchBarVisible = scrollView.contentOffset.y <= 0;
        if (!searchBarVisible) {
            self.searchBarVisible = searchBarVisible;
            scrollView.contentInset = self.oldContentInsets;
        }
    } else {
        const BOOL searchBarVisible = scrollView.contentOffset.y <= -self.topInset;
        if (searchBarVisible) {
            self.searchBarVisible = searchBarVisible;
            self.oldContentInsets = scrollView.contentInset;
            scrollView.contentInset = UIEdgeInsetsMake(self.topInset + self.oldContentInsets.top,
                                                       self.oldContentInsets.left,
                                                       self.oldContentInsets.bottom,
                                                       self.oldContentInsets.right);
        }
    }
}

@end
