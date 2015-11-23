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

@interface WYPhotoBrowserViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray<WYPhoto *> *photos;
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation WYPhotoBrowserViewController

- (instancetype)initWithPhotos:(NSArray<WYPhoto *> * _Nullable)photos {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    NSAssert(photos.count > 0, @"没图片啊！！");
    _photos = photos;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blackColor];
  [self _setupCollectionView];
}

- (void)_setupCollectionView {
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  flowLayout.itemSize = self.view.bounds.size;
  flowLayout.minimumInteritemSpacing = 0;
  flowLayout.minimumLineSpacing = 0;
  flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  
  UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                        collectionViewLayout:flowLayout];
  collectionView.dataSource = self;
  collectionView.delegate = self;
  collectionView.alwaysBounceHorizontal = YES;
  collectionView.pagingEnabled = YES;
  [collectionView registerClass:[WYPhotoCollectionViewCell class]
     forCellWithReuseIdentifier:kWYPhotoCollectionViewCellId];
  self.collectionView = collectionView;
  [self.view addSubview:collectionView];
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
  if (self.wy_delegate && [self.wy_delegate respondsToSelector:
                           @selector(wy_photoBrowserViewController:didClickImageViewAtIndex:)]) {
    [self.wy_delegate wy_photoBrowserViewController:self didClickImageViewAtIndex:indexPath.item];
  }
}

@end
