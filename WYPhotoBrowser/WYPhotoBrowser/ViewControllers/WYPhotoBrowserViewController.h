//
//  WYPhotoBrowserViewController.h
//  WYPhotoBrowser
//
//  Created by WuYikai on 15/11/20.
//  Copyright © 2015年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WYPhoto, WYPhotoBrowserViewController;

@protocol WYPhotoBrowserViewControllerDelegate <NSObject>

- (void)wy_photoBrowserViewController:(WYPhotoBrowserViewController *)photoBrowserViewController
             didClickImageViewAtIndex:(NSInteger)index;

@end

@interface WYPhotoBrowserViewController : UIViewController
@property (nonatomic, weak) id<WYPhotoBrowserViewControllerDelegate> wy_delegate;
@property (nonatomic, assign) NSInteger wy_currentIndex;

- (instancetype)initWithPhotos:(NSArray<WYPhoto *> * _Nullable)photos;
@end

NS_ASSUME_NONNULL_END
