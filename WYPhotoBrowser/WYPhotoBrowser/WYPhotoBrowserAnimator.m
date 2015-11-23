//
//  WYPhotoBrowserAnimator.m
//  WYPhotoBrowser
//
//  Created by WuYikai on 15/11/23.
//  Copyright © 2015年 secoo. All rights reserved.
//

#import "WYPhotoBrowserAnimator.h"
#import "WYPhotoBrowserViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WYPhotoBrowserAnimator ()<UIViewControllerTransitioningDelegate,
                                      UIViewControllerAnimatedTransitioning,
                                      WYPhotoBrowserViewControllerDelegate>
@property (nonatomic, strong) NSArray<WYPhoto *> *photos;
@property (nonatomic, assign) BOOL isBeingPresented;
@end

@implementation WYPhotoBrowserAnimator
- (instancetype)initWithPhotos:(NSArray<WYPhoto *> *)photos {
  self = [super init];
  if (self) {
    NSAssert(photos.count > 0, @"参数错误");
    _photos = photos;
  }
  return self;
}

- (instancetype)initWithSmallImages:(NSArray<UIImage *> *)smallImages bigImageURLs:(NSArray<NSString *> *)bigImageURLs {
  NSAssert(smallImages.count == bigImageURLs.count, @"参数错误");
  NSMutableArray *tempArray = [NSMutableArray array];
  for (NSInteger i = 0; i < smallImages.count; ++i) {
    WYPhoto *photo = [[WYPhoto alloc] init];
    photo.wy_smallImage = smallImages[i];
    photo.wy_bigImageURL = bigImageURLs[i];
    [tempArray addObject:photo];
  }
  self = [self initWithPhotos:[NSArray arrayWithArray:tempArray]];
  return self;
}

- (instancetype)init {
  self = [self initWithPhotos:nil];
  return self;
}

#pragma mark - Public Methods
- (void)wy_showFromIndex:(NSInteger)fromIndex {
  _wy_currentIndex = fromIndex;
  WYPhotoBrowserViewController *vc = [[WYPhotoBrowserViewController alloc] initWithPhotos:self.photos];
  vc.wy_delegate = self;
  vc.transitioningDelegate = self;
  vc.modalPresentationStyle = UIModalPresentationCustom;
  UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
  [keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Pravite Methods 
- (void)_animateToFullScreenWithTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
  WYPhotoBrowserViewController *vc = [transitionContext viewControllerForKey:
                                      UITransitionContextToViewControllerKey];

  WYPhoto *currentPhoto = self.photos[_wy_currentIndex];
  UIView *containerView = [transitionContext containerView];
  UIView *toView = vc.view;
  CGRect fromRect = [self.wy_dataSource wy_photoBrowserAnimator:self frameAtScreenForIndex:self.wy_currentIndex];
  
  UIView *backgroundView = [[UIView alloc] initWithFrame:[containerView bounds]];
  backgroundView.backgroundColor = [UIColor blackColor];
  [containerView addSubview:backgroundView];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:fromRect];
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  imageView.clipsToBounds = YES;
  imageView.backgroundColor = [UIColor clearColor];
  [imageView sd_setImageWithURL:[NSURL URLWithString:currentPhoto.wy_bigImageURL]
               placeholderImage:currentPhoto.wy_smallImage];
  [backgroundView addSubview:imageView];
  
  [UIView animateWithDuration:0.5f animations:^{
    imageView.frame = toView.frame;
  } completion:^(BOOL finished) {
    [imageView removeFromSuperview];
    [containerView addSubview:toView];
    [transitionContext completeTransition:YES];
  }];
}

- (void)_animateToDismissWithTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
  WYPhotoBrowserViewController *vc = [transitionContext viewControllerForKey:
                                      UITransitionContextFromViewControllerKey];
  [vc.view removeFromSuperview];
  [transitionContext completeTransition:YES];

  WYPhoto *currentPhoto = self.photos[_wy_currentIndex];
  UIView *containerView = [UIApplication sharedApplication].keyWindow;
  CGRect toRect = [self.wy_dataSource wy_photoBrowserAnimator:self frameAtScreenForIndex:self.wy_currentIndex];

  UIView *backgroundView = [[UIView alloc] initWithFrame:[containerView bounds]];
  backgroundView.backgroundColor = [UIColor blackColor];
  [containerView addSubview:backgroundView];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:[containerView bounds]];
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  imageView.clipsToBounds = YES;
  imageView.backgroundColor = [UIColor clearColor];
  imageView.image = currentPhoto.wy_image;
  [containerView addSubview:imageView];
  
  [UIView animateWithDuration:0.5f animations:^{
    imageView.frame = toRect;
  } completion:^(BOOL finished) {
    [imageView removeFromSuperview];
  }];
  
  [UIView animateWithDuration:0.5f animations:^{
    backgroundView.alpha = 0;
  } completion:^(BOOL finished) {
    [backgroundView removeFromSuperview];
  }];
}

#pragma mark - Delegates -
#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
  self.isBeingPresented = YES;
  return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  self.isBeingPresented = NO;
  return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
  return 0.6;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
  if ([self isBeingPresented]) {
    //显示
    [self _animateToFullScreenWithTransition:transitionContext];
  } else {
    //消失
    [self _animateToDismissWithTransition:transitionContext];
  }
}

#pragma mark - WYPhotoBrowserViewControllerDelegate
- (void)wy_photoBrowserViewController:(WYPhotoBrowserViewController *)photoBrowserViewController didClickImageViewAtIndex:(NSInteger)index {
  _wy_currentIndex = index;
  [photoBrowserViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
