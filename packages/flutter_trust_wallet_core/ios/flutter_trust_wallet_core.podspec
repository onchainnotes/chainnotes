#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_trust_wallet_core.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_trust_wallet_core'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => '' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.library = 'c++'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
  }
  s.swift_version = '5.0'

  local_xcframeworks = Dir[File.join(__dir__, 'Frameworks', '*.xcframework')]
  if local_xcframeworks.any?
    # Local prebuilt binaries (ab_pay workflow; not committed to git).
    s.vendored_frameworks = 'Frameworks/*.xcframework'
  else
    # WalletCore + SwiftProtobuf via CocoaPods when local Frameworks/ is empty.
    s.dependency 'TrustWalletCore', '~> 4.6.9'
  end

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'flutter_trust_wallet_core_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
