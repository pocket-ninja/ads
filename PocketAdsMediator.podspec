Pod::Spec.new do |s|
    s.name = 'PocketAdsMediator'
    s.version = '1.2.19'
    s.summary = 'Pocket Ninja Ads'
    s.description = 'Pocket Ninja Ads'
    s.homepage = 'https://github.com/pocket-ninja/ads'
    s.license = { :type => 'MIT', :text => 'LICENSE' }
    s.author = { 'sroik' => 'vasili.kazhanouski@gmail.com' }
    s.source = { :git => 'git@github.com:pocket-ninja/ads.git', :tag => s.version.to_s }
    s.ios.deployment_target = '13.0'
    s.requires_arc = true
    s.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 arm64e armv7 armv7s x86_64' }
    s.static_framework = true
    s.swift_version = '5.3'
    s.default_subspec = 'Core'

    s.subspec 'Core' do |c|
      c.dependency 'PocketAds'
    end

    s.subspec 'AppodealMediator' do |appodeal|
      appodeal.source_files = 'AppodealMediator/Sources/**/*.{h,m,swift}'
      appodeal.dependency 'PocketAds'
      appodeal.dependency 'Appodeal', '>= 2.11.1'
    end

    s.subspec 'AppodealAdapters' do |appodeal|
      appodeal.dependency 'APDAdColonyAdapter', '>= 2.11.1.1' 
      appodeal.dependency 'APDAmazonAdsAdapter', '>= 2.11.1.1' 
      appodeal.dependency 'APDAppLovinAdapter', '>= 2.11.1.1' 
      appodeal.dependency 'APDBidMachineAdapter', '>= 2.11.1.1' 
      appodeal.dependency 'APDFacebookAudienceAdapter', '>= 2.11.1.1' 
      appodeal.dependency 'APDGoogleAdMobAdapter', '>= 2.11.1.1' 
      appodeal.dependency 'APDIronSourceAdapter', '>= 2.11.1.1' 
      appodeal.dependency 'APDMyTargetAdapter', '>= 2.11.1.1' 
      appodeal.dependency 'APDOguryAdapter', '>= 2.11.1.1' 
      appodeal.dependency 'APDUnityAdapter', '>= 2.11.1.1' 
      appodeal.dependency 'APDVungleAdapter', '>= 2.11.1.1'
      # appodeal.dependency 'APDYandexAdapter', '>= 2.11.1.1'
    end
  end
