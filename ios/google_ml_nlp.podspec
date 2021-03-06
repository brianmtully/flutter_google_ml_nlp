#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint google_ml_nlp.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'google_ml_nlp'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for Google ML Kit Natural Language Processing'
  s.description      = <<-DESC
Flutter plugin for Google ML Kit Natural Language Processing
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.static_framework = true
  s.dependency 'Flutter'
  s.dependency 'GoogleMLKit/EntityExtraction'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
