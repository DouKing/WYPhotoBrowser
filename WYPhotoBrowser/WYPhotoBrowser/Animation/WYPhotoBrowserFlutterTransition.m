//
//  WYPhotoBrowserFlutterTransition.m
//  WYPhotoBrowser
//
//  Created by iosci on 2017/2/19.
//  Copyright © 2017年 secoo. All rights reserved.
//

#import "WYPhotoBrowserFlutterTransition.h"
#import "WYPhotoBrowserViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
  [imageView sd_setImageWithURL:[NSURL URLWithString:currentPhoto.wy_bigImageURL]
               placeholderImage:currentPhoto.wy_smallImage
                      completed:nil];
  [backgroundView addSubview:imageView];
  
  CGRect desFrame = toView.frame;
  UIImage *image = currentPhoto.wy_image;
  if (image) {
    CGFloat w = desFrame.size.width;
    CGFloat h = image.size.height / image.size.width * w;
    if (h > desFrame.size.height) {
      desFrame = CGRectMake(0, 0, w, h);
    }
  }
  [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
    imageView.frame = desFrame;
  } completion:^(BOOL finished) {
    [imageView removeFromSuperview];
    [containerView addSubview:toView];
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
  }];
}

- (void)_dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  WYPhotoBrowserViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIView *containerView = [transitionContext containerView];
  containerView.backgroundColor = [UIColor blackColor];
  for (UIView *v in [containerView subviews]) {
    [v removeFromSuperview];
  }
  
  WYPhoto *currentPhoto = fromVC.currentPhoto;
  CGRect toRect = [fromVC.dataSource photoBrowserViewController:fromVC sourceViewFrameAtScreenForIndex:fromVC.currentIndex];
  
  CGRect fromFrame = containerView.bounds;
  UIImage *image = currentPhoto.wy_image;
  if (image) {
    CGFloat w = containerView.bounds.size.width;
    CGFloat h = image.size.height / image.size.width * w;
    if (h > containerView.bounds.size.height) {
      fromFrame = CGRectMake(0, 0, w, h);
    }
  }
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:fromFrame];
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  imageView.clipsToBounds = YES;
  imageView.backgroundColor = [UIColor clearColor];
  imageView.image = image;
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
