//
//  WYPhotoBrowserViewController.m
//  WYPhotoBrowser
//
//  Created by WuYikai on 15/11/20.
//  Copyright © 2015年 secoo. All rights reserved.
//

#import "WYPhotoBrowserViewController.h"
#import "WYPhotoBrowserFlutterTransition.h"
#import "WYPhotoCollectionViewCell.h"

static NSString * const kWYPhotoCollectionViewCellId = @"kWYPhotoCollectionViewCellId";
static CGFloat const kWYPageControlHeight = 20;
static CGFloat const kWYPageControlBottomSpace = 50;

@interface WYPhotoBrowserViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate, WYPhotoCollectionViewCellDelegate>

@property (nonatomic, strong) NSArray<WYPhoto *> *photos;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation WYPhotoBrowserViewController

- (instancetype)initWithPhotos:(NSArray<WYPhoto *> * _Nullable)photos {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    NSAssert(photos.count > 0, @"没图片啊！！");
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    NSMutableArray *temp = [NSMutableArray arrayWithArray:photos];
    [temp insertObject:photos.lastObject atIndex:0];
    [temp addObject:photos.firstObject];
    _photos = [NSArray arrayWithArray:temp];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blackColor];
  [self.view addSubview:self.collectionView];
  [self.view addSubview:self.pageControl];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex + 1 inSection:0]
                              atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
  CGRect frame = CGRectMake(-kWYPhotoImageViewInsert, 0, [self _itemWidth], CGRectGetHeight(self.view.bounds));
  self.collectionView.frame = frame;
  frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - kWYPageControlBottomSpace,
                     CGRectGetWidth(self.view.bounds), kWYPageControlHeight);
  self.pageControl.frame = frame;
}

#pragma mark - WYPhotoCollectionViewCellDelegate
- (void)photoCollectionViewCell:(WYPhotoCollectionViewCell *)cell didTapImageView:(UIImageView *)imageView {
  NSInteger index = self.pageControl.currentPage;
  __weak typeof(self) weakSelf = self;
  [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if ([strongSelf.delegate respondsToSelector:@selector(photoBrowserViewController:didClickImageViewAtIndex:)]) {
      [strongSelf.delegate photoBrowserViewController:strongSelf didClickImageViewAtIndex:index];
    }
  }];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  WYPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWYPhotoCollectionViewCellId
                                                                              forIndexPath:indexPath];
  cell.delegate = self;
  [cell setupWithPhoto:self.photos[indexPath.item]];
  return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (scrollView != self.collectionView) {
    return;
  }
  
  CGFloat offsetX = scrollView.contentOffset.x;
  if (offsetX < CGRectGetWidth(self.collectionView.bounds)) {
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:self.photos.count - 2 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:lastIndexPath
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];
    self.currentIndex = lastIndexPath.item - 1;
  } else if (offsetX > CGRectGetWidth(self.collectionView.bounds) * (self.photos.count - 2)) {
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:firstIndexPath
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];
    self.currentIndex = 0;
  } else {
    NSInteger index = offsetX / CGRectGetWidth(scrollView.bounds) - 1;
    self.currentIndex = index;
  }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
  WYPhotoBrowserFlutterTransition *transition = [[WYPhotoBrowserFlutterTransition alloc] initWithTransitionType:WYPhotoBrowserTransitionTypePresent];
  return transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  WYPhotoBrowserFlutterTransition *transition = [[WYPhotoBrowserFlutterTransition alloc] initWithTransitionType:WYPhotoBrowserTransitionTypePresent];
  return transition;
}

#pragma mark - Helper

- (CGFloat)_itemWidth {
  return CGRectGetWidth(self.view.bounds) + kWYPhotoImageViewInsert * 2;
}

#pragma mark - setter & getter

- (UICollectionView *)collectionView {
  if (!_collectionView) {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake([self _itemWidth], CGRectGetHeight(self.view.bounds));
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceHorizontal = YES;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollEnabled = self.photos.count > 3;
    [_collectionView registerClass:[WYPhotoCollectionViewCell class]
        forCellWithReuseIdentifier:kWYPhotoCollectionViewCellId];
  }
  return _collectionView;
}

- (UIPageControl *)pageControl {
  if (!_pageControl) {
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = self.photos.count - 2;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.currentPage = self.currentIndex;
  }
  return _pageControl;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
  _currentIndex = currentIndex;
  self.pageControl.currentPage = currentIndex;
}

@end
