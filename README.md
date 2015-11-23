# WYPhotoBrowser
图片浏览器

## 封装逻辑

- `WYPhotoBrowserViewController`负责展示图片，每张图片是一个`WYPhoto`对象
- `WYPhotoBrowserAnimator`是对`WYPhotoBrowserViewController`的一层封装，负责展示和消失的动画

## 使用方法

- Step1: 生成`WYPhotoBrowserAnimator`对象，并强持有该对象
- Step2: 传入图片数组
- Step3: 调用`wy_showFromIndex:`方法将图片浏览器显示在屏幕上
- Step4: 实现协议`WYPhotoBrowserAnimatorDataSource`

```
  WYPhotoBrowserAnimator *animator = [[WYPhotoBrowserAnimator alloc] initWithPhotos:self.photos];
  animator.wy_dataSource = self;
  self.animator = animator;
  [animator wy_showFromIndex:index];
```

```
#pragma mark - WYPhotoBrowserAnimatorDataSource
- (CGRect)wy_photoBrowserAnimator:(WYPhotoBrowserAnimator *)animator frameAtScreenForIndex:(NSInteger)index {
  NSInteger tag = index + XXXXX;
  UIView *view = [self.view viewWithTag:tag];
  return [self.view convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow];
}
```

## 如何扩展

您可以仿照`WYPhotoBrowserAnimator`或继承`WYPhotoBrowserAnimator`继续给`WYPhotoBrowserViewController`添加动画效果

## 开始项目贡献

- 如果您想对该项目有所贡献，可以fork我的项目，并将`https://github.com/DouKing/WYPhotoBrowser.git`添加到您的远程仓库
- 如果您对该项目有任何疑问或建议，请给我留言，希望我们能携手打造出强大好用的图片浏览器