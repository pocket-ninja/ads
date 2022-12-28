platform :ios, '14.0'
inhibit_all_warnings!
use_frameworks!

def appodeal
  pod 'Appodeal', '3.0.1'
end

target 'Demo' do
    pod 'PocketAds', :path => './PocketAds.podspec'
end

target 'AdsCore' do
end

target 'AppodealMediator' do
  appodeal
  pod 'PocketAds', :path => './PocketAds.podspec'
end
