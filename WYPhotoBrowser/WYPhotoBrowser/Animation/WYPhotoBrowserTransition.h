//
//  WYPhotoBrowserTransition.h
//  WYPhotoBrowser
//
//  Created by iosci on 2017/2/19.
//  Copyright © 2017年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WYPhotoBrowserTransitionType) {
  WYPhotoBrowserTransitionTypePresent,
  WYPhotoBrowserTransitionTypeDismiss
};

@interface WYPhotoBrowserTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, readonly) WYPhotoBrowserTransitionType transitionType;

- (instancetype)initWithTransitionType:(WYPhotoBrowserTransitionType)transitionType;

@end
