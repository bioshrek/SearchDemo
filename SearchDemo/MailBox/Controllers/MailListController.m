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

// constants

static const CGFloat kCellHeight = 88.0f;
static NSString * const kCellID = @"mail.item";

@interface MailListController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

// views

@property (nonatomic, weak) UICollectionView *collectionView;

// data

@property (nonatomic, strong) id<MailListViewModelProtocol> dataSource;

@end

@implementation MailListController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self loadData];
}

#pragma mark - Data

- (void)loadData {
    self.dataSource = [[MailListTestViewModel alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.dataSource loadDataCompleted:^{
        [weakSelf.collectionView reloadData];
    }];
}

#pragma mark - Views

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    MailListNavigationBar *navigationBar = [[MailListNavigationBar alloc] init];
    navigationBar.titleLabel.text = @"收件箱";
    [navigationBar setNeedsLayout];
    [self.view addSubview:navigationBar];
    
    UICollectionView *collectionView = [self createCollectionView];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
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
    [collectionView registerClass:MailItemCell.class forCellWithReuseIdentifier:kCellID];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    return collectionView;
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

@end
