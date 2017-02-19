# WYPhotoBrowser
图片浏览器

## 封装逻辑

- `WYPhotoBrowserViewController`负责展示图片，每张图片是一个`WYPhoto`对象
- `WYPhotoBrowserTransition`是展示和消失的动画的基类

## 使用方法

- Step1: 根据图片数组生成`WYPhotoBrowserViewController`对象
- Step2: 指定数据源 `dataSource`
- Step3: 调用 `presentViewController:animated:completion:` 或 `pushViewController:animated:`弹出vc
- Step4: 实现协议`WYPhotoBrowserViewControllerDataSource`

```
  NSInteger index = xxx;
  WYPhotoBrowserViewController *vc = [[WYPhotoBrowserViewController alloc] initWithPhotos:self.photos];
  vc.dataSource = self;
  vc.currentIndex = index;
  [self presentViewController:vc animated:YES completion:nil];
```

```
#pragma mark - WYPhotoBrowserViewControllerDataSource

- (CGRect)photoBrowserViewController:(WYPhotoBrowserViewController *)browserViewController sourceViewFrameAtScreenForIndex:(NSInteger)index {
  NSInteger tag = index + yyyyy;
  UIView *imgView = [self.view viewWithTag:xxxxx];
  return [self.view convertRect:imgView toView:[UIApplication sharedApplication].keyWindow];
}
```

## 如何扩展

您可以继承`WYPhotoBrowserTransition`继续给`WYPhotoBrowserViewController`添加动画效果

## 开始项目贡献

- 如果您想对该项目有所贡献，可以fork我的项目，并将`https://github.com/DouKing/WYPhotoBrowser.git`添加到您的远程仓库
- 如果您对该项目有任何疑问或建议，请给我留言，希望我们能携手打造出强大好用的图片浏览器
