#
# Be sure to run `pod lib lint DataStore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "DataStore"
s.version          = "0.1.0"
s.summary          = "Data Store (a Laravel Eloquent like ORM) syncs your Objects (or Models) to an underlying SQLite table."

s.description      = <<-DESC
This Eloquent based ORM (for iOS) also provides a beautiful, simple ActiveRecord implementation for working with your data storage. Each database table has a corresponding "Model" which is used to interact with that table. Models allow you to query for data in your tables, insert new records into the table, as well as update the table.
DESC

s.homepage         = "https://github.com/the-mac/data-store-ios"
# s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
s.license          = 'MIT'
s.author           = { "Christopher Miller" => "christopher.d.miller.1@gmail.com" }
s.source           = { :git => "https://github.com/the-mac/data-store-ios.git", :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '9.0'

s.source_files = 'Pods/FMDB/standard/*.{m,h}', 'DataStore/Classes/**/*', 'DataStore/Classes/*.{m,h}'
s.dependency 'FMDB'

# s.resource_bundles = {
#   'DataStore' => ['DataStore/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'

end