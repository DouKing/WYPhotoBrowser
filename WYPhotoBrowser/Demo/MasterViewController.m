//
//  MasterViewController.m
//  WYPhotoBrowser
//
//  Created by WuYikai on 15/11/20.
//  Copyright © 2015年 secoo. All rights reserved.
//

#import "MasterViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "WYPhotoBrowserViewController.h"

#define SCREEN_WIDTH  CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

@interface MasterViewController ()<WYPhotoBrowserViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn2;

@property (nonatomic, strong) NSArray *bigImageURLs;
@property (nonatomic, strong) NSArray *smallImageURLs;
@property (nonatomic, strong) NSArray *photos;
@end

@implementation MasterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.smallImageURLs[0]] forState:UIControlStateNormal];
  [self.imageBtn2 sd_setBackgroundImageWithURL:[NSURL URLWithString:self.smallImageURLs[1]] forState:UIControlStateNormal];
}

- (IBAction)_handleClickAction:(UIButton *)sender {
  NSInteger index = sender.tag - 1000;
  WYPhotoBrowserViewController *vc = [[WYPhotoBrowserViewController alloc] initWithPhotos:self.photos];
  vc.dataSource = self;
  vc.currentIndex = index;
  if (0 == index) {
    [self presentViewController:vc animated:YES completion:nil];
  } else {
    [self.navigationController pushViewController:vc animated:YES];
  }
}

#pragma mark - WYPhotoBrowserViewControllerDataSource

- (CGRect)photoBrowserViewController:(WYPhotoBrowserViewController *)browserViewController sourceViewFrameAtScreenForIndex:(NSInteger)index {
  if (0 == index) {
    return [self.view convertRect:self.imageBtn.frame toView:[UIApplication sharedApplication].keyWindow];
  }
  if (1 == index) {
    return [self.view convertRect:self.imageBtn2.frame toView:[UIApplication sharedApplication].keyWindow];
  }
  return CGRectMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0, 0, 0);
}

#pragma mark - setter & getter
- (NSArray *)smallImageURLs {
  if (!_smallImageURLs) {
    _smallImageURLs = @[@"http://pic.secooimg.com/thumb/112/112/pic1.secoo.com/comment/15/11/878ca70019fb4057ba9df62dea1d5bc0.jpg",
                        @"http://pic.secooimg.com/thumb/112/112/pic1.secoo.com/comment/15/11/951c285b4ef34dffa2a30a08ce2e2b4a.jpg"];
  }
  return _smallImageURLs;
}

- (NSArray *)bigImageURLs {
  if (!_bigImageURLs) {
    _bigImageURLs = @[@"http://pic.secooimg.com/comment/15/11/878ca70019fb4057ba9df62dea1d5bc0.jpg",
                      @"http://pic.secooimg.com/comment/15/11/951c285b4ef34dffa2a30a08ce2e2b4a.jpg"];
  }
  return _bigImageURLs;
}

- (NSArray *)photos {
  if (!_photos) {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 2; ++i) {
      WYPhoto *photo = [[WYPhoto alloc] init];
      photo.wy_bigImageURL = self.bigImageURLs[i];
      photo.wy_smallImage = [(UIButton *)[self.view viewWithTag:1000 + i] backgroundImageForState:UIControlStateNormal];
      [tempArray addObject:photo];
    }
    _photos = [NSArray arrayWithArray:tempArray];
  }
  return _photos;
}

@end
