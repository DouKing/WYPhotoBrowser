//
//  MasterViewController.m
//  WYPhotoBrowser
//
//  Created by WuYikai on 15/11/20.
//  Copyright © 2015年 secoo. All rights reserved.
//

#import "MasterViewController.h"
#import "WYPhotoBrowserAnimator.h"
#import <SDWebImage/UIButton+WebCache.h>

#define SCREEN_WIDTH  CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

@interface MasterViewController ()<WYPhotoBrowserAnimatorDataSource>
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (nonatomic, strong) WYPhotoBrowserAnimator *animator;

@end

@implementation MasterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:@"http://pic.secooimg.com/thumb/112/112/pic1.secoo.com/comment/15/10/b49bc924c89f4080a0b0b516ea7e0c72.jpg"] forState:UIControlStateNormal];
}

- (IBAction)_clickBtn:(UIButton *)sender {
  WYPhoto *photo = [[WYPhoto alloc] init];
  photo.wy_bigImageURL = @"http://pic.secooimg.com/comment/15/10/b49bc924c89f4080a0b0b516ea7e0c72.jpg";
  photo.wy_smallImage = [self.imageBtn backgroundImageForState:UIControlStateNormal];
  WYPhotoBrowserAnimator *animator = [[WYPhotoBrowserAnimator alloc] initWithPhotos:@[photo]];
  animator.wy_dataSource = self;
  self.animator = animator;
  [animator wy_showFromIndex:0];
}

#pragma mark - WYPhotoBrowserAnimatorDataSource
- (CGRect)wy_photoBrowserAnimator:(WYPhotoBrowserAnimator *)animator frameAtScreenForIndex:(NSInteger)index {
  if (0 == index) {
    return [self.view convertRect:self.imageBtn.frame toView:[UIApplication sharedApplication].keyWindow];
  }
  return CGRectMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0, 0, 0);
}

@end
