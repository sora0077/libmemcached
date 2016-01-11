#
# Be sure to run `pod lib lint libmemcached.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "libmemcached"
  s.version          = "0.1.0"
  s.summary          = "import libmemcached in Swift."

  s.homepage         = "https://github.com/sora0077/libmemcached"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "sora0077" => "t_hayashi0077@gmail.com" }
  s.source           = { :git => "https://github.com/sora0077/libmemcached.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.preserve_paths = 'libmemcached/**/*'
  s.xcconfig  = {
    'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/libmemcached',
    'HEADER_SEARCH_PATHS' => '/usr/local/include',
    'LIBRARY_SEARCH_PATHS' => '/usr/local/lib',
  }

  s.platform = :osx
end
