# Data Store iOS
[DataStore](http://the-mac.github.io/data-store-ios) is the [Eloquent](https://laravel.com/docs/5.1/eloquent) based ORM (for iOS) that also provides a beautiful, simple ActiveRecord implementation for working with your data storage. Each database table has a corresponding "[Model](http://the-mac.github.io/data-store-ios/Classes/Model.html)" which is used to interact with that table. Models allow you to insert new records into the table, query for data in your tables, as well as update (and delete from) the table.

More can be found on the Eloquent Model here:
- https://laravel.com/docs/5.2/eloquent#inserting-and-updating-models
- https://laravel.com/api/5.2/Illuminate/Database/Eloquent/Model.html

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

### Basic Inserts / Updates
To create a new record in the database, simply create a new model instance, set attributes on the model, then call the [save]() method on your model.
```
- (IBAction)bookFlight {

    Flight *flight = [[Flight alloc] init];
    flight.name = self.flightNumberLabel.text;
    flight.destination = self.flightDestinationLabel.text;

    [flight save];

    [self.navigationController popViewControllerAnimated:YES];
}
```
In this example, we simply assign the name and destination attributes of the Flight model instance. When we call the save method, a record will be inserted into the database. Alternatively, if you make another change to the Model instance and save again it will update the database record.

### Retrieving Multiple Models
We are ready to start retrieving data from your database. Think of each Model as a powerful query builder allowing you to fluently query the database table associated with the model. Take the Flight class for example:
```
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSArray * all = [Flight all];
    NSInteger count = all.count;
    self.flightCountLabel.text = [NSString stringWithFormat:@"%d Flight(s) Booked", count];
}
```

### Retrieving Single Models
In addition to retrieving all of the records for a given table, you may also retrieve single records using find and first. Instead of returning a collection of models, the find method returns a single model instance:
```
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    Flight *flight = (Flight *)[Flight find:1];
    self.flightLabel.text = flight.name;
}
```
Once you have a Model instance, you can access the column values of the Model by accessing the corresponding property. For example, above we have a Flight instance accessing the name column.


### Retrieving Aggregates
Of course, you may also use the count method provided by the Model class. This method returns the appropriate scalar value instead of a full model instance (or collection of instances):
```
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSInteger count = [Flight count];
    self.flightCountLabel.text = [NSString stringWithFormat:@"%d Flight(s) Booked", count];
}
```
In this example, we simply assign the count variable from the Flight model class' count method and report it to the UI component.


### Deleting Models
To delete a model, call the remove method on a model instance:
```
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    Flight *flight = (Flight *)[Flight find:1];
    [flight remove];
}
```

Alternatively, to delete all models, call the truncate method:
```
- (void)viewDidAppear:(BOOL)animated {
[super viewDidAppear:animated];

    [Flight truncate];
}
```



## Example Project

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Author

[Christopher Miller, Android/iOS Project Manager](https://github.com/cdm2012)

## Contributors

[Your Name Here](#)

## License

DataStore is available under the MIT license. See the LICENSE file for more info.
