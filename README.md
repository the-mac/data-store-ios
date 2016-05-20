# Data Store iOS
[DataStore](http://the-mac.github.io/data-store-ios) is the [Eloquent](https://laravel.com/docs/5.1/eloquent) based ORM (for iOS) that also provides a beautiful, simple ActiveRecord implementation for working with your data storage. Each database table has a corresponding "[Model](http://the-mac.github.io/data-store-ios/Classes/Model.html)" which is used to interact with that table. Models allow you to insert new records into the table, query for data in your tables, as well as update (and delete from) the table.

## Setup

### Installation

DataStore is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DataStore"
```

### Defining Models

The [Model](http://the-mac.github.io/data-store-ios/Classes/Model.html) can be defined in Objective-C:


* First update your class to implement [Model](http://the-mac.github.io/data-store-ios/Classes/Model.html)
```
@interface Flight : Model
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *destination;
@end

@implementation Flight
@end
```

Alternatively [Model](http://the-mac.github.io/data-store-ios/Classes/Model.html) can be defined in Swift as well:
```    
class Flight : Model {
var name: String?
var destination: String?
}
```

### Getting Started
Now you can begin to use some basic functions like [[Model save]](), [[Model count]]() or even [[Model all]]() on your model.
```
- (void)viewDidAppear:(BOOL)animated {
[super viewDidAppear:animated];

Flight *flight = [[Flight alloc] init];
flight.name = @"Flight 143";
flight.destination = @"Lovemade, CA";

[flight save];


NSInteger count = [Flight count];
self.flightCountLabel.text = [NSString stringWithFormat:@"%d Flights Available", count];


NSArray* flights = [Flight all];
NSLog(@"All Flights = %@", flights);

flight = flights[0];
NSLog(@"First Flight (name = %@, destination = %@)", flight.name, flight.destination);
}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Author

[Christopher Miller, Android/iOS Project Manager](https://github.com/cdm2012)

## Contributors

[Your Name Here](#)

## License

DataStore is available under the MIT license. See the LICENSE file for more info.
