Pod::Spec.new do |s|
  s.name         = 'WYPhotoBrowser'
  s.version      = '2.0'
  s.summary      = '图片浏览器'
  s.homepage     = 'https://github.com/DouKing/WYPhotoBrowser'
  s.license      = 'MIT'
  s.author       = { 'Wu Yikai' => 'wyk8916@gmail.com' }
  s.platform     = :ios, '7.0'
  s.source       = { :git => 'https://github.com/DouKing/WYPhotoBrowser.git', :tag => s.version }
  s.source_files = 'WYPhotoBrowser/WYPhotoBrowser', 'WYPhotoBrowser/WYPhotoBrowser/**/*.{h,m}'
  s.requires_arc = true
  s.dependency 'SDWebImage'
end
