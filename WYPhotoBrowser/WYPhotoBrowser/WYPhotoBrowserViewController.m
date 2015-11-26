//
//  WYPhotoBrowserViewController.m
//  WYPhotoBrowser
//
//  Created by WuYikai on 15/11/20.
//  Copyright © 2015年 secoo. All rights reserved.
//

#import "WYPhotoBrowserViewController.h"
#import "WYPhotoCollectionViewCell.h"
#import "WYPhoto.h"

static NSString * const kWYPhotoCollectionViewCellId = @"kWYPhotoCollectionViewCellId";
static CGFloat const kWYPageControlHeight = 20;
static CGFloat const kWYPageControlBottomSpace = 50;

@interface WYPhotoBrowserViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray<WYPhoto *> *photos;
@property (nonatomic, assign) NSInteger photoNumbers;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation WYPhotoBrowserViewController

- (instancetype)initWithPhotos:(NSArray<WYPhoto *> * _Nullable)photos {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    NSAssert(photos.count > 0, @"没图片啊！！");
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
  [self _setupCollectionView];
  [self _setupPageControl];
}

- (void)_setupCollectionView {
  CGFloat width = CGRectGetWidth(self.view.bounds) + kWYPhotoImageViewInsert * 2;
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  flowLayout.itemSize = CGSizeMake(width, CGRectGetHeight(self.view.bounds));
  flowLayout.minimumInteritemSpacing = 0;
  flowLayout.minimumLineSpacing = 0;
  flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  
  CGRect frame = CGRectMake(-kWYPhotoImageViewInsert, 0, width, CGRectGetHeight(self.view.bounds));
  UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame
                                                        collectionViewLayout:flowLayout];
  collectionView.dataSource = self;
  collectionView.delegate = self;
  collectionView.alwaysBounceHorizontal = YES;
  collectionView.pagingEnabled = YES;
  [collectionView registerClass:[WYPhotoCollectionViewCell class]
     forCellWithReuseIdentifier:kWYPhotoCollectionViewCellId];
  self.collectionView = collectionView;
  [self.view addSubview:collectionView];
  
  [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.wy_currentIndex + 1 inSection:0]
                         atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)_setupPageControl {
  CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - kWYPageControlBottomSpace,
                            CGRectGetWidth(self.view.bounds), kWYPageControlHeight);
  UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:frame];
  pageControl.numberOfPages = self.photos.count - 2;
  pageControl.hidesForSinglePage = YES;
  pageControl.currentPage = self.wy_currentIndex;
  self.pageControl = pageControl;
  [self.view addSubview:pageControl];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  WYPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWYPhotoCollectionViewCellId
                                                                              forIndexPath:indexPath];
  [cell wy_setupWithPhoto:self.photos[indexPath.item]];
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger index = indexPath.item;
  if (self.photoNumbers > 1) {
    if (0 == index) {
      index = self.photoNumbers;
    } else if (index == self.photoNumbers + 1) {
      index = 1;
    }
  }
  if (self.wy_delegate && [self.wy_delegate respondsToSelector:
                           @selector(wy_photoBrowserViewController:didClickImageViewAtIndex:)]) {
    [self.wy_delegate wy_photoBrowserViewController:self didClickImageViewAtIndex:index];
  }
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

@end
