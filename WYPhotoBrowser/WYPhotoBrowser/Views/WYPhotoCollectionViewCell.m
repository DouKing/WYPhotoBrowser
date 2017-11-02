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

CGFloat const kWYPhotoImageViewInsert = 5;

@interface WYPhotoCollectionViewCell ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) WYPhoto *photo;

@end

@implementation WYPhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self _setupSubViews];
  }
  return self;
}

- (void)setupWithPhoto:(WYPhoto *)photo {
  if (self.photo == photo) {
    return;
  }
  self.photo = photo;
  [self.scrollView setZoomScale:1];
  __weak typeof(self) weakSelf = self;
  [self.imageView sd_setImageWithURL:[NSURL URLWithString:photo.bigImageURL] placeholderImage:photo.smallImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    photo.image = image;
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if ((image && !error)) {
      [strongSelf _resetFrame];
    }
  }];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect frame = CGRectMake(kWYPhotoImageViewInsert, 0,
                            CGRectGetWidth(self.contentView.bounds) -
                            kWYPhotoImageViewInsert * 2,
                            CGRectGetHeight(self.contentView.bounds));
  self.scrollView.frame = frame;
  self.imageView.frame = self.scrollView.bounds;
  if (self.photo.image) {
    [self _resetFrame];
  }
}

#pragma mark - Pravite Methods -

- (void)_setupSubViews {
  [self _setupScrollView];
  [self _setupImageView];
}

- (void)_setupScrollView {
  UIScrollView *scrollView = [[UIScrollView alloc] init];
  scrollView.delegate = self;
  scrollView.maximumZoomScale = 3;
  scrollView.minimumZoomScale = 1;
  scrollView.showsHorizontalScrollIndicator = NO;
  scrollView.showsVerticalScrollIndicator = NO;
  scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  if (@available(iOS 11.0, *)) {
    scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
  }
  _scrollView = scrollView;
  [self.contentView addSubview:scrollView];
}

- (void)_setupImageView {
  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  imageView.clipsToBounds = YES;
  _imageView = imageView;
  [self.scrollView addSubview:imageView];
  
  imageView.userInteractionEnabled = YES;
  UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleDoubleTapAction:)];
  doubleTapGesture.numberOfTapsRequired = 2;
  [imageView addGestureRecognizer:doubleTapGesture];
  
  UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleSingleTapAction:)];
  [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
  [imageView addGestureRecognizer:singleTapGesture];
}

- (void)_resetFrame {
  CGFloat width = CGRectGetWidth(self.scrollView.bounds);
  CGFloat height = CGRectGetHeight(self.scrollView.bounds);
  if (width <= 0 || height <= 0) { return; }
  UIImage *image = [self.imageView image];
  CGFloat imgWidth = image.size.width;
  CGFloat imgHeight = image.size.height;
  if (imgWidth <= 0 || imgHeight <= 0 ) { return; }
  CGFloat radio = 1.5;
  if (imgHeight / imgWidth < radio && imgWidth / imgHeight < radio) { return; }

  CGFloat w = imgWidth, h = imgHeight;
  CGFloat x = 0, y = 0;

  if (imgHeight >= imgWidth) {
    if (imgWidth > width) {
      w = width;
      h = imgHeight / imgWidth * w;
      self.scrollView.contentSize = CGSizeMake(0, h);
    }
  } else {
    if (imgHeight > height) {
      h = height;
      w = imgWidth / imgHeight * h;
      self.scrollView.contentSize = CGSizeMake(w, 0);
    }
  }
  if (h < height) {
    y = (height - h) / 2.0;
  }
  if (w < width) {
    x = (width - w) / 2.0;
  }
  self.imageView.frame = CGRectMake(x, y, w, h);
}

#pragma mark -

- (void)_handleSingleTapAction:(UITapGestureRecognizer *)gesture {
  if (self.delegate && [self.delegate respondsToSelector:@selector(photoCollectionViewCell:didTapImageView:)]) {
    [self.delegate photoCollectionViewCell:self didTapImageView:(UIImageView *)gesture.view];
  }
}

- (void)_handleDoubleTapAction:(UITapGestureRecognizer *)gesture {
  CGPoint touchPoint = [gesture locationInView:self.scrollView];
  if (self.scrollView.zoomScale == self.scrollView.maximumZoomScale) {
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
  } else {
    [self.scrollView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
  }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.imageView;
}

@end
