Pod::Spec.new do |s|
    s.name = 'Ads'
    s.module_name = 'Ads'
    s.version = '1.0.0'
    s.summary = 'Pocket Ninja Ads'
    s.description = 'Pocket Ninja Ads'
    s.homepage = 'https://github.com/pocket-ninja/ads'
    s.license = { :type => 'Pivate', :file => 'LICENSE', :text => 'LICENSE' }
    s.author = { 'sroik' => 'vasili.kazhanouski@gmail.com' }
    s.source = { :git => 'git@github.com:pocket-ninja/ads.git', :tag => s.version.to_s }
    s.ios.deployment_target = '12.0'
    s.requires_arc = true
    s.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 arm64e armv7 armv7s x86_64' }
    s.static_framework = true
    s.swift_version = '5.3'
    s.default_subspec = 'Core'

    s.subspec 'Core' do |core|
      core.source_files = 'AdsCore/Sources/**/*.{h,m,swift}'
    end

    s.subspec 'AppodealMediator' do |appodeal|
      appodeal.source_files = 'AppodealMediator/Sources/**/*.{h,m,swift}'
      appodeal.dependency 'Ads/Core'
      
      appodeal.dependency 'Appodeal', '>= 2.7.5'
      appodeal.dependency 'APDAdColonyAdapter', '>= 2.7.5.1'
      appodeal.dependency 'APDAppLovinAdapter', '>= 2.7.5.1'
      appodeal.dependency 'APDAppodealAdExchangeAdapter', '>= 2.7.5.1'
      appodeal.dependency 'APDFacebookAudienceAdapter', '>= 2.7.5.1'
      appodeal.dependency 'APDGoogleAdMobAdapter', '>= 2.7.5.1'
      appodeal.dependency 'APDInMobiAdapter', '>= 2.7.5.1'
      appodeal.dependency 'APDInnerActiveAdapter', '>= 2.7.5.1'
      appodeal.dependency 'APDIronSourceAdapter', '>= 2.7.5.1'
      appodeal.dependency 'APDMyTargetAdapter', '>= 2.7.5.1'
      appodeal.dependency 'APDMintegralAdapter', '>= 2.7.5.1'
      appodeal.dependency 'APDPubnativeAdapter', '>= 2.7.5.1'
      appodeal.dependency 'APDVungleAdapter', '>= 2.7.5.1'
    end
  end
