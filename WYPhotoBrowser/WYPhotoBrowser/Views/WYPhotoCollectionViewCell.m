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
  [self.imageView sd_setImageWithURL:[NSURL URLWithString:photo.wy_bigImageURL] placeholderImage:photo.wy_smallImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    photo.wy_image = image;
    __strong typeof(weakSelf) strongSelf = weakSelf;
    [strongSelf _resetFrame:(image && !error)];
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
  [self _resetFrame:self.photo.wy_image];
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

- (void)_resetFrame:(BOOL)succeed {
  CGFloat width = CGRectGetWidth(self.scrollView.bounds);
  CGFloat height = CGRectGetHeight(self.scrollView.bounds);
  if (width <= 0 || height <= 0) { return; }
  if (succeed) {
    UIImage *image = [self.imageView image];
    CGFloat w = width;
    CGFloat h = height;
    if (height < width) {
      w = image.size.width / image.size.height * h;
      if (w > width) {
        self.imageView.frame = CGRectMake(0, 0, w, h);
        self.scrollView.contentSize = CGSizeMake(w, 0);
      }
    } else {
      h = image.size.height / image.size.width * w;
      if (h > height) {
        self.imageView.frame = CGRectMake(0, 0, w, h);
        self.scrollView.contentSize = CGSizeMake(0, h);
      }
    }
  } else {
    self.scrollView.contentSize = CGSizeZero;
    self.imageView.frame = self.scrollView.bounds;
  }
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
