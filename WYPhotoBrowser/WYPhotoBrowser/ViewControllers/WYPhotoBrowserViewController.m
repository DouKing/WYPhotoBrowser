//
//  WYPhotoBrowserViewController.m
//  WYPhotoBrowser
//
//  Created by WuYikai on 15/11/20.
//  Copyright © 2015年 secoo. All rights reserved.
//

#import "WYPhotoBrowserViewController.h"
#import "WYPhotoCollectionViewCell.h"

static NSString * const kWYPhotoCollectionViewCellId = @"kWYPhotoCollectionViewCellId";
static CGFloat const kWYPageControlHeight = 20;
static CGFloat const kWYPageControlBottomSpace = 50;

@interface WYPhotoBrowserViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, WYPhotoCollectionViewCellDelegate>

@property (nonatomic, strong) NSArray<WYPhoto *> *photos;
@property (nonatomic, assign) NSInteger photoNumbers;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation WYPhotoBrowserViewController

- (instancetype)initWithPhotos:(NSArray<WYPhoto *> * _Nullable)photos {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    NSAssert(photos.count > 0, @"没图片啊！！");
    self.automaticallyAdjustsScrollViewInsets = NO;
    _photoNumbers = photos.count;
    NSMutableArray *temp = [NSMutableArray arrayWithArray:photos];
    if (_photoNumbers > 1) {
      [temp insertObject:photos.lastObject atIndex:0];
      [temp addObject:photos.firstObject];
    }
    _photos = [NSArray arrayWithArray:temp];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blackColor];
  [self.view addSubview:self.collectionView];
  [self.view addSubview:self.pageControl];
  
  [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.wy_currentIndex + 1 inSection:0]
                              atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  CGRect frame = CGRectMake(-kWYPhotoImageViewInsert, 0, [self _itemWidth], CGRectGetHeight(self.view.bounds));
  self.collectionView.frame = frame;
  frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - kWYPageControlBottomSpace,
                     CGRectGetWidth(self.view.bounds), kWYPageControlHeight);
  self.pageControl.frame = frame;
}

#pragma mark - WYPhotoCollectionViewCellDelegate
- (void)wy_photoCollectionViewCell:(WYPhotoCollectionViewCell *)cell didTapImageView:(UIImageView *)imageView {
  NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
  NSInteger index = indexPath.item;
  if (self.photoNumbers > 1) {
    if (0 == index) {
      index = self.photoNumbers;
    } else if (index == self.photoNumbers + 1) {
      index = 1;
    }
  }
  
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  WYPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWYPhotoCollectionViewCellId
                                                                              forIndexPath:indexPath];
  cell.wy_delegate = self;
  [cell wy_setupWithPhoto:self.photos[indexPath.item]];
  return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (_photoNumbers <= 1) { return; }
  CGFloat offsetX = scrollView.contentOffset.x;
  if (offsetX < CGRectGetWidth(self.collectionView.bounds)) {
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:self.photoNumbers inSection:0];
    [self.collectionView scrollToItemAtIndexPath:lastIndexPath
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];
    self.pageControl.currentPage = self.photoNumbers - 1;
    self.wy_currentIndex = self.photoNumbers - 1;
  } else if (offsetX > CGRectGetWidth(self.collectionView.bounds) * self.photoNumbers) {
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:firstIndexPath
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];
    self.pageControl.currentPage = 0;
    self.wy_currentIndex = 0;
  } else {
    NSInteger index = offsetX / CGRectGetWidth(scrollView.bounds) - 1;
    self.pageControl.currentPage = index;
    self.wy_currentIndex = index;
  }
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
    [_collectionView registerClass:[WYPhotoCollectionViewCell class]
        forCellWithReuseIdentifier:kWYPhotoCollectionViewCellId];
  }
  return _collectionView;
}

- (UIPageControl *)pageControl {
  if (!_pageControl) {
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = _photoNumbers;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.currentPage = self.wy_currentIndex;
  }
  return _pageControl;
}

@end
