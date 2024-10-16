Pod::Spec.new do |s|
    s.name = 'PocketAds'
    s.version = '1.3.6'
    s.summary = 'Pocket Ninja Ads'
    s.description = 'Pocket Ninja Ads'
    s.homepage = 'https://github.com/pocket-ninja/ads'
    s.license = { :type => 'MIT', :text => 'LICENSE' }
    s.author = { 'sroik' => 'vasili.kazhanouski@gmail.com' }
    s.source = { :git => 'git@github.com:pocket-ninja/ads.git', :tag => s.version.to_s }
    s.ios.deployment_target = '14.0'
    s.requires_arc = true
    s.static_framework = true
    s.swift_version = '5.7'
    s.default_subspec = 'Core'
    s.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 arm64e armv7 armv7s x86_64' }
    
    s.subspec 'Core' do |core|
      core.source_files = 'AdsCore/Sources/**/*.{h,m,swift}'
    end
    
    s.subspec 'AppodealMediator' do |appodeal|
      appodeal.source_files = 'AppodealMediator/Sources/**/*.{h,m,swift}'
      appodeal.dependency 'PocketAds/Core'
      appodeal.dependency 'Appodeal'
    end

    s.subspec 'ApplovinMediator' do |applovin|
      applovin.source_files = 'ApplovinMediator/Sources/**/*.{h,m,swift}'
      applovin.dependency 'PocketAds/Core'
      applovin.dependency 'AppLovinSDK'
    end
  end
