Pod::Spec.new do |s|
    s.name = 'PocketAds'
    s.version = '1.2.7'
    s.summary = 'Pocket Ninja Ads'
    s.description = 'Pocket Ninja Ads'
    s.homepage = 'https://github.com/pocket-ninja/ads'
    s.license = { :type => 'MIT', :text => 'LICENSE' }
    s.author = { 'sroik' => 'vasili.kazhanouski@gmail.com' }
    s.source = { :git => 'git@github.com:pocket-ninja/ads.git', :tag => s.version.to_s }
    s.ios.deployment_target = '12.0'
    s.requires_arc = true
    s.static_framework = true
    s.swift_version = '5.3'
    s.source_files = 'AdsCore/Sources/**/*.{h,m,swift}'
  end
