platform :ios, '12.0'
inhibit_all_warnings!
use_frameworks!

def appodeal
  pod 'Appodeal', '2.8.1'
end

target 'Demo' do
    pod 'Ads/Core', :path => './Ads.podspec'
#    pod 'Ads/AppodealAdapters', :path => './Ads.podspec'
end

target 'AdsCore' do
end

target 'AppodealMediator' do
  appodeal
end
