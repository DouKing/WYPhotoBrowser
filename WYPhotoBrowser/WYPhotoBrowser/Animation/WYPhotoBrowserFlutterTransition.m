//
//  WYPhotoBrowserFlutterTransition.m
//  WYPhotoBrowser
//
//  Created by iosci on 2017/2/19.
//  Copyright © 2017年 secoo. All rights reserved.
//

#import "WYPhotoBrowserFlutterTransition.h"
#import "WYPhotoBrowserViewController.h"
#import <UIImageView+WebCache.h>

@implementation WYPhotoBrowserFlutterTransition

- (void)_presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  WYPhotoBrowserViewController *vc = [transitionContext viewControllerForKey:
                                      UITransitionContextToViewControllerKey];
  WYPhoto *currentPhoto = vc.currentPhoto;
  
  UIView *containerView = [transitionContext containerView];
  UIView *toView = vc.view;
  CGRect fromRect = [vc.dataSource photoBrowserViewController:vc sourceViewFrameAtScreenForIndex:vc.currentIndex];
  
  UIView *backgroundView = [[UIView alloc] initWithFrame:[containerView bounds]];
  backgroundView.backgroundColor = [UIColor blackColor];
  [containerView addSubview:backgroundView];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:fromRect];
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  imageView.clipsToBounds = YES;
  imageView.backgroundColor = [UIColor clearColor];
  [imageView sd_setImageWithURL:[NSURL URLWithString:currentPhoto.wy_bigImageURL] placeholderImage:currentPhoto.wy_smallImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    
  }];
  [backgroundView addSubview:imageView];

  [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
    imageView.frame = toView.frame;
  } completion:^(BOOL finished) {
    [imageView removeFromSuperview];
    [containerView addSubview:toView];
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
  }];
}

- (void)_dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  WYPhotoBrowserViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIView *containerView = [transitionContext containerView];
  
  WYPhoto *currentPhoto = fromVC.currentPhoto;
  CGRect toRect = [fromVC.dataSource photoBrowserViewController:fromVC sourceViewFrameAtScreenForIndex:fromVC.currentIndex];
  
  [fromVC.view removeFromSuperview];
  containerView.backgroundColor = [UIColor blackColor];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:[containerView bounds]];
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  imageView.clipsToBounds = YES;
  imageView.backgroundColor = [UIColor clearColor];
  imageView.image = currentPhoto.wy_image;
  [containerView addSubview:imageView];
  
  [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
    containerView.backgroundColor = [UIColor clearColor];
    imageView.frame = toRect;
  } completion:^(BOOL finished) {
    [imageView removeFromSuperview];
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
  }];
}

@end
