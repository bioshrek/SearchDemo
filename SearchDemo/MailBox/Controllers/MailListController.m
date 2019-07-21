//
//  MailListController.
//  SearchDemo
//
//  Created by 王欢 on 2019/7/13.
//  Copyright © 2019 王欢. All rights reserved.
//

#import "MailListController.h"
#import "Masonry.h"
#import "MailListNavigationBar.h"
#import "UIView+Layout.h"
#import "MailItemCell.h"
#import "MailListTestViewModel.h"
#import "ScrollViewTopDragHelper.h"
#import "MailSearchTextField.h"

// constants

static const CGFloat kCellHeight = 88.0f;
static const CGFloat kSearchTextFieldHMargin = 20.0f;
static const CGFloat kSpacing_searchTextField_collectionView = 15.0f;
static NSString * const kCellID = @"mail.item";

@interface MailListController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITextFieldDelegate>

// views
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) MailSearchTextField *searchTextField;
@property (nonatomic, weak) UIView *separator;

// data
@property (nonatomic, strong) id<MailListViewModelProtocol> dataSource;

// service
@property (nonatomic, strong) ScrollViewTopDragHelper *topDragHelper;

@end

@implementation MailListController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self loadData];
    [self setupServices];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self updateSearchTextFieldPositionWithScrollView:self.collectionView];
}

#pragma mark - Data & Service

- (void)loadData {
    self.dataSource = [[MailListTestViewModel alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.dataSource loadDataCompleted:^{
        [weakSelf.collectionView reloadData];
    }];
}

- (void)setupServices {
    self.topDragHelper = [[ScrollViewTopDragHelper alloc] initWithTopInset:2 * kSpacing_searchTextField_collectionView + self.searchTextField.height];
}

#pragma mark - Views

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionView *collectionView = [self createCollectionView];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    MailSearchTextField *searchTextField = [[MailSearchTextField alloc] initWithFrame:CGRectMake(kSearchTextFieldHMargin, 0, self.view.width - 2 * kSearchTextFieldHMargin, 0)];
    searchTextField.textField.delegate = self;
    [searchTextField sizeToFit];  // height
    [self.view addSubview:searchTextField];
    self.searchTextField = searchTextField;
    
    UIView *separator = [self createSeparator];
    separator.width = self.view.width;
    [self.view addSubview:separator];
    self.separator = separator;
    
    MailListNavigationBar *navigationBar = [[MailListNavigationBar alloc] init];
    navigationBar.backgroundColor = [UIColor whiteColor];
    navigationBar.titleLabel.text = @"收件箱";
    [navigationBar setNeedsLayout];
    [self.view addSubview:navigationBar];
    
    // layout
    [navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(navigationBar.superview);
    }];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(collectionView.superview);
        make.top.equalTo(navigationBar.mas_bottom);
    }];
}

- (UICollectionView *)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.view.width, kCellHeight);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [collectionView registerClass:MailItemCell.class forCellWithReuseIdentifier:kCellID];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    return collectionView;
}

- (UIView *)createSeparator {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.5)];
    view.backgroundColor = [UIColor colorWithRed:177.0/255.0 green:178.0/255.0 blue:179.0/255.0 alpha:1.0];
    return view;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.mailCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MailItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    id<MailItemViewModelProtocol> viewModel = [self.dataSource mailViewModelAtIndex:indexPath.item];
    if (viewModel) {
        cell.titleLabel.attributedText = viewModel.titleText;
        cell.subTitleLabel.attributedText = viewModel.subTitleText;
        cell.briefLabel.attributedText = viewModel.briefText;
        cell.timeLabel.attributedText = viewModel.timeText;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.topDragHelper scrollViewDidScroll:scrollView];
    [self updateSearchTextFieldPositionWithScrollView:scrollView];
}

#pragma mark - Search TextField

- (void)updateSearchTextFieldPositionWithScrollView:(UIScrollView *)scrollView {
    const CGFloat collectionViewContentTop = MAX(scrollView.top, scrollView.top - scrollView.contentOffset.y);
    self.searchTextField.bottom = collectionViewContentTop - kSpacing_searchTextField_collectionView;
    self.separator.top = collectionViewContentTop;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // TODO: 
}

@end
