#
# Be sure to run `pod lib lint DataStore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "DataStoreAdvanced"
s.version          = "2.1.7"
s.summary          = "Data Store (a Laravel Eloquent like ORM) syncs your Objects (or Models) to an underlying SQLite table."

s.description      = <<-DESC
DataStoreAdvanced is the Eloquent based ORM (for iOS) that also provides a beautiful, simple ActiveRecord implementation for working with your data storage. Each database table has a corresponding "Model" which is used to communicate. A Model allows you to insert new records into the table, query for data in your table, as well as update (and delete from) the table.

More can be found on the Eloquent Model here:

https://laravel.com/docs/5.2/eloquent#inserting-and-updating-models
https://laravel.com/api/5.2/Illuminate/Database/Eloquent/Model.html
DESC

s.homepage         = "https://github.com/the-mac/data-store-ios"
s.license          = 'MIT'
s.author           = { "Christopher Miller" => "christopher.d.miller.1@gmail.com" }
s.source           = { :git => "https://github.com/the-mac/data-store-ios.git", :tag => s.version.to_s }

s.ios.deployment_target = '8.0'
s.osx.deployment_target = '10.10'

s.source_files = 'Pods/FMDB/standard/*.{m,h}', 'DataStoreAdvanced/Classes/**/*', 'DataStoreAdvanced/Classes/*.{m,h}'
s.dependency 'FMDB'

end