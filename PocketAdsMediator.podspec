Pod::Spec.new do |s|
    s.name = 'PocketAdsMediator'
    s.version = '1.3.1'
    s.summary = 'Pocket Ninja Ads'
    s.description = 'Pocket Ninja Ads'
    s.homepage = 'https://github.com/pocket-ninja/ads'
    s.license = { :type => 'MIT', :text => 'LICENSE' }
    s.author = { 'sroik' => 'vasili.kazhanouski@gmail.com' }
    s.source = { :git => 'git@github.com:pocket-ninja/ads.git', :tag => s.version.to_s }
    s.ios.deployment_target = '14.0'
    s.requires_arc = true
    s.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 arm64e armv7 armv7s x86_64' }
    s.static_framework = true
    s.swift_version = '5.5'
    s.default_subspec = 'Core'

    s.subspec 'Core' do |c|
      c.dependency 'PocketAds'
    end

    s.subspec 'AppodealMediator' do |appodeal|
      appodeal.source_files = 'AppodealMediator/Sources/**/*.{h,m,swift}'
      appodeal.dependency 'PocketAds'
      appodeal.dependency 'Appodeal', '>= 3.0.1'
    end
  end
