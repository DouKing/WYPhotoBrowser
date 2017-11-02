//
//  WYPhoto.h
//  WYPhotoBrowser
//
//  Created by WuYikai on 15/11/20.
//  Copyright © 2015年 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYPhoto : NSObject
/// 根据`wy_bigImageURL`下载的完整图片
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImage *smallImage;
@property (nonatomic, copy)   NSString *bigImageURL;

@end

NS_ASSUME_NONNULL_END
