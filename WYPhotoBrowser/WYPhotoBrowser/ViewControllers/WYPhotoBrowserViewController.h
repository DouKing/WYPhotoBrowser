//
//  WYPhotoBrowserViewController.h
//  WYPhotoBrowser
//
//  Created by WuYikai on 15/11/20.
//  Copyright © 2015年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPhoto.h"

NS_ASSUME_NONNULL_BEGIN

@class WYPhoto, WYPhotoBrowserViewController;

@protocol WYPhotoBrowserViewControllerDelegate <NSObject>

- (void)photoBrowserViewController:(WYPhotoBrowserViewController *)photoBrowserViewController
          didClickImageViewAtIndex:(NSInteger)index;

@end

@protocol WYPhotoBrowserViewControllerDataSource <NSObject>

@required
/// 相对于屏幕的frame
- (CGRect)photoBrowserViewController:(WYPhotoBrowserViewController *)browserViewController
     sourceViewFrameAtScreenForIndex:(NSInteger)index;

@end

@interface WYPhotoBrowserViewController : UIViewController

@property (nonatomic, weak) id<WYPhotoBrowserViewControllerDelegate> delegate;
@property (nonatomic, weak) id<WYPhotoBrowserViewControllerDataSource> dataSource;

@property (nonatomic, assign) NSInteger currentIndex;

- (instancetype)initWithPhotos:(NSArray<WYPhoto *> * _Nullable)photos;

@end

NS_ASSUME_NONNULL_END
