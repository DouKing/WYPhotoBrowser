//
//  WYPhotoBrowserTransition.m
//  WYPhotoBrowser
//
//  Created by iosci on 2017/2/19.
//  Copyright © 2017年 secoo. All rights reserved.
//

#import "WYPhotoBrowserTransition.h"

@implementation WYPhotoBrowserTransition

- (instancetype)initWithTransitionType:(WYPhotoBrowserTransitionType)transitionType {
  if (self = [super init]) {
    _transitionType = transitionType;
  }
  return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  switch (self.transitionType) {
    case WYPhotoBrowserTransitionTypePresent:
      [self _presentAnimateTransition:transitionContext];
      break;
    case WYPhotoBrowserTransitionTypeDismiss:
      [self _dismissAnimateTransition:transitionContext];
      break;
  }
}

- (void)_presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIView *containerView = [transitionContext containerView];
  UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
  [containerView addSubview:toView];
  toView.alpha = 0;
  [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
    toView.alpha = 1;
  } completion:^(BOOL finished) {
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
  }];
}

- (void)_dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
//  UIView *containerView = [transitionContext containerView];
  UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
  [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
    fromView.alpha = 0;
  } completion:^(BOOL finished) {
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
  }];
}

@end
