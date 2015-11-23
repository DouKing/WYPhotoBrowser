//
//  WYPhotoBrowserAnimator.h
//  WYPhotoBrowser
//
//  Created by WuYikai on 15/11/23.
//  Copyright © 2015年 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "WYPhoto.h"

NS_ASSUME_NONNULL_BEGIN

@class WYPhotoBrowserAnimator;

@protocol WYPhotoBrowserAnimatorDataSource <NSObject>
@required
/// 相对于屏幕的frame
- (CGRect)wy_photoBrowserAnimator:(WYPhotoBrowserAnimator *)animator frameAtScreenForIndex:(NSInteger)index;
@end

@interface WYPhotoBrowserAnimator : NSObject
@property (nonatomic, weak) id<WYPhotoBrowserAnimatorDataSource> wy_dataSource;
@property (nonatomic, assign, readonly) NSInteger wy_currentIndex;

- (instancetype)initWithSmallImages:(NSArray<UIImage *> *)smallImages
                       bigImageURLs:(NSArray<NSString *> *)bigImageURLs;
- (instancetype)initWithPhotos:(NSArray<WYPhoto *> * _Nullable)photos NS_DESIGNATED_INITIALIZER;
- (void)wy_showFromIndex:(NSInteger)fromIndex;
@end

NS_ASSUME_NONNULL_END
