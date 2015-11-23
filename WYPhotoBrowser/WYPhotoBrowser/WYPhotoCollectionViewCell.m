//
//  WYPhotoCollectionViewCell.m
//  WYPhotoBrowser
//
//  Created by WuYikai on 15/11/20.
//  Copyright © 2015年 secoo. All rights reserved.
//

#import "WYPhotoCollectionViewCell.h"
#import "WYPhoto.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation WYPhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self _setupSubViews];
  }
  return self;
}

- (void)wy_setupWithPhoto:(WYPhoto *)photo {
  [self.wy_imageView sd_setImageWithURL:[NSURL URLWithString:photo.wy_bigImageURL]
                       placeholderImage:photo.wy_smallImage
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                photo.wy_image = image;
                       }];
}

#pragma mark - Pravite Methods -
- (void)_setupSubViews {
  [self _setupImageView];
}

- (void)_setupImageView {
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  imageView.clipsToBounds = YES;
  _wy_imageView = imageView;
  [self.contentView addSubview:imageView];
}

@end
