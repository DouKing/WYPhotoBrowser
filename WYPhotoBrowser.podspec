Pod::Spec.new do |s|
  s.name         = 'WYPhotoBrowser'
  s.version      = '0.0.1'
  s.summary      = 'Photo Browser'
  s.homepage     = 'https://github.com/DouKing/WYPhotoBrowser'
  s.license      = 'MIT'
  s.author       = { 'Wu Yikai' => 'wuyikai@secoo.com' }
  s.platform     = :ios, '7.0'
  s.source       = { :git => 'https://github.com/DouKing/WYPhotoBrowser.git', :tag => s.version }
  s.source_files = 'WYPhotoBrowser/WYPhotoBrowser', 'WYPhotoBrowser/WYPhotoBrowser/**/*.{h,m}'
  s.requires_arc = true
  s.dependency 'SDWebImage', '~> 3.7.3'
end
