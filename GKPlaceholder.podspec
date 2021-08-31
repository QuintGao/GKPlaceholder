Pod::Spec.new do |s|
  s.name             = 'GKPlaceholder'
  s.version          = '1.0.0'
  s.summary          = '一行代码实现UIScrollView空数据占位图'
  s.description      = <<-DESC
UIScrollView空数据占位图，支持UITableView和UICollectionView
                       DESC
  s.homepage         = 'https://github.com/QuintGao/GKPlaceholder'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1094887059@qq.com' => 'QuintGao' }
  s.source           = { :git => 'https://github.com/QuintGao/GKPlaceholder.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'GKPlaceholder/**/*'
end
