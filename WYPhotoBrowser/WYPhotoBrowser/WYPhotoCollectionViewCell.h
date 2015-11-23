//
//  WYPhotoCollectionViewCell.h
//  WYPhotoBrowser
//
//  Created by WuYikai on 15/11/20.
//  Copyright © 2015年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WYPhoto;

@interface WYPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *wy_imageView;

- (void)wy_setupWithPhoto:(WYPhoto *)photo;

@end

NS_ASSUME_NONNULL_END