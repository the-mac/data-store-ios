# Data Store iOS
[DataStoreAdvanced](http://cocoadocs.org/docsets/DataStoreAdvanced) is the [Eloquent](https://laravel.com/docs/5.2/eloquent) based ORM (for iOS) that also provides a beautiful, simple ActiveRecord implementation for working with your data storage. Each database table has a corresponding [Model](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html) which is used to interact with a table by the same name. The Model class allows us to insert new records into the table, query for data in our table, as well as update (and delete from) the table.

## Motivation
This project was started due to the [many issues](https://www.objc.io/issues/4-core-data/SQLite-instead-of-core-data/) that came with depending upon Core Data. We tried to have a pre-populated database that would speed up the application load times, and were also looking to simplify how we save data (because the assumption is that CoreData is part of iOS, so it should be easy to use and just work). Boy, were we wrong:

Here is a simplified example of how to get a database table's count with Core Data, without querying for all objects from a table into an array and accessing the count property of the array:
```

NSManagedObjectContext *moc = [ReelAPIProvider managedObjects];
NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Reel" inManagedObjectContext:moc];
NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
[fetch setEntity:entityDescription];


NSExpression *reel_id = [NSExpression expressionForKeyPath:@"reel_id"];
NSExpression *countExpression = [NSExpression expressionForFunction:@"count:" arguments:@[reel_id]];
NSExpressionDescription *countED = [[NSExpressionDescription alloc] init];

countED.expression = countExpression;
countED.name = @"countOfReels";
countED.expressionResultType = NSDoubleAttributeType;
fetch.propertiesToFetch = @[countED];
fetch.resultType = NSDictionaryResultType;

NSArray *reelCounts = [moc executeFetchRequest:fetch error:nil];
int reelCount = [reelCounts[0][@"countOfReels"] intValue];
```
Even after finding examples like this, we were still willing to accept the (memory usage) overhead of using Core Data, but just recently it simply stopped working and in multiple projects (which baffled us), so we decided to create our own ORM, but in the likeness of Laravel Eloquent Models (a very well put together PHP Framework component). Here is an example of how our ORM gets a count:

```
int reelCount = [Reel count];
```

Both CoreData and DataStoreAdvanced use SQLite databases under the hood, but our framework has all of it's wheels (including the one that steers). Oh and this isn't magic (we're using FMDB underneath, with simple SQL queries to the underlying SQLite db), but simply a framework that is considerate of what the developer needs to do to use it.

More can be found on the system that layed the foundation for DataStoreAdvanced (Eloquent ORMs) here:
- https://laravel.com/docs/5.2/eloquent#inserting-and-updating-models
- https://laravel.com/api/5.2/Illuminate/Database/Eloquent/Model.html

## Setup

### Installation

DataStoreAdvanced is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DataStoreAdvanced', :git => 'https://github.com/the-mac/data-store-ios.git', :branch => 'advanced'
```

### Defining Models

You can update any class to implement [Model](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html) in Objective-C:

```
@interface Flight : Model
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *departing;
@property (strong, nonatomic) NSString *departingAbbr;
@property (strong, nonatomic) NSString *arriving;
@property (strong, nonatomic) NSString *arrivingAbbr;
@end

@implementation Flight
@end
```

Alternatively [Model](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html) subclasses can be defined in Swift as well:
```    
class Flight : Model {
    var name: String?
    var departing: String?
    var departingAbbr: String?
    var arriving: String?
    var arrivingAbbr: String?
}
```

### Basic Inserts / Updates
To create a new record in the database, simply create a new instance of your [Model](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html) subclass, set the attributes on that model, and then call the [save](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/save) method on your model instance.

```
- (IBAction)bookFlight {

    Flight *flight = [[Flight alloc] init];
    flight.name = self.navigationController.navigationBar.topItem.title;
    flight.departing = self.flightDepartingLabel.text;
    flight.departingAbbr = self.flightDepartingAbbr.text;
    flight.arriving = self.flightArrivingLabel.text;
    flight.arrivingAbbr = self.flightArrivingAbbr.text;

    [flight save];

    [self.navigationController popViewControllerAnimated:YES];
}
```
In the example above, we simply assign to the attributes of the Flight model instance. Then we call the save method, and the model instance will be inserted into the database. Alternatively, if you make another change to the model instance and save it again, it will update the database record instead.


Another way to update a record in the database is to simply call update on your [Model](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html) subclass, passing the attributes to update method on that model.

```
- (IBAction)shutDownAirport {

    NSString *arriving = @"Cancelled";
    [Flight update:[@{ @"arriving" : arriving } mutableCopy]];

    [self.navigationController popViewControllerAnimated:YES];
}
```
In the example above, we simply pass to the class function an arriving attribute for all Flight records in the database. Alternatively, if you would like to filter what records need to be updated, then you can prepend one or more where clauses.

```
- (IBAction)delayFlight {

    [Flight where:@"arriving" is:@"San Diego, CA"
    update:[@{ @"delayed" : @1 } mutableCopy]];

    [self.navigationController popViewControllerAnimated:YES];
}
```
The update method expects an NSDictionary (of column and value pairs) representing the columns that should be updated in the db table. In the above example, all flights that are active and have an arriving attribute of San Diego will be marked as delayed.


### Retrieving Multiple Records
Now that we have seen how to use the [save](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/save) method on a [Model](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html), we are ready to start retrieving data from our database.

Next we will query the database table associated with the model for all records, with the [all](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/all) function:
```
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSArray * all = [Flight all];
    for (Flight* flight in all) {
        ...
    }
}
```
In this example, we simply assign the NSArray from the [all](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/all) function of the Flight class. As you can see, with a single function call we can get all the records of a specific database table.


Next we will query the database table associated with the model for a subset of records, with the [where:inside](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/where:inside) function:
```
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSArray *insideResults = [[Flight where:@"name" inside: @[@"Flight 1137", @"Flight 843", @"Flight 845"]] get];
    for (Flight* flight in insideResults) {
        ...
    }
}
```

Alternatively, if you want to query a subset you can also use one (or more) of the query builder functions [where](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.1/Classes/Model.html#//api/name/where:is:) or the [orWhere](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.1/Classes/Model.html#//api/name/orWhere:is:), with the [get](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.1/Classes/Model.html#//api/name/get) function to execute the query. Here is an example of using all three functions together: 
```
- (void)updateFilteredContentFromInput:(NSString *)flightSearch {

    if (flightSearch == nil) {
        self.searchResults = [self.flights mutableCopy];
    } else {
        NSString *searchingFor = [NSString stringWithFormat:@"%%%@%%", flightSearch];
        self.searchResults = [[[[Flight where:@"name" is:searchingFor]
            orWhere:@"departing" is:searchingFor]  orWhere:@"arriving" is:searchingFor] get];
    }
    [self.tableView reloadData];
}
```

### Retrieving A Single Record
In addition to retrieving records for a given table or subset, you can also retrieve a single table record. Instead of returning a collection of records like with the [all](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/all) function, the [find](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/find) function returns a single [Model](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html) instance:
```
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    Flight *flight = (Flight *)[Flight find:1];
    self.flightLabel.text = flight.name;
}
```
Once you have a [Model](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html) instance, you can use the column values of the table by accessing the corresponding property. For example, above we get a Flight instance from the [find](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/find) function, and begin accessing the name column from the Flight database table.


### Retrieving Aggregates
You also have access to the [count](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/count) function provided by the Model class. This function returns the appropriate scalar value instead of a full model instance (or collection of instances):
```
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSInteger count = [Flight count];
    self.flightCountLabel.text = [NSString stringWithFormat:@"%d Flight(s) Booked", count];
}
```
In this example, we simply assign the count variable from the Flight model class' [count](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/count) function and report it to the UI component.


### Deleting Records
To delete a record, call the [remove](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/remove) method on a model instance:
```
- (IBAction)cancelFlight {

    Flight *flight = (Flight *)[Flight find:1];
    [flight remove];
}
```

Alternatively, to delete all records from a database table, call the [truncate](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/truncate) function:
```
- (IBAction)cancelAllFlights {

    [Flight truncate];
}
```

## Example Project
The Example Project has 3 screens that display advanced [Model](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html) CRUD operations, using the Flight class as an example.

![launch](0launch.png "Launch Screen") ![bookflight](1bookflight.png "Book Flight") ![showflights](2showflights.png "Show Flights")

The CRUD operations are completed using the [count](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/count), [truncate](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/truncate), [remove](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/remove), [update](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/update), [save](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/save), [where](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/where:is), [orWhere](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/orWhere:is), [get](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/get) and [all](http://cocoadocs.org/docsets/DataStoreAdvanced/2.1.7/Classes/Model.html#//api/name/all) functions. 

If you think we could have more advanced operations, we're accepting pull requests [here](https://github.com/the-mac/data-store-ios/compare). As a reference (or foundation), take a look at what the [Laravel Eloquent](https://laravel.com/docs/5.2/eloquent) model implementation looks like.

To run the advanced example project, clone the repo, checkout the advanced branch, and run `pod install` from the Example directory first.
```
git clone https://github.com/the-mac/data-store-ios.git
cd data-store-ios
git checkout advanced
cd Example
pod install
```
## Requirements
This pod uses the [FMDB](http://cocoadocs.org/docsets/FMDB/2.6.2/) Framework, and is already included in the Example Project's Podfile. For your own project (and Podfile), our DataStoreAdvanced reference could look as follows:
```
platform :ios, '8.0'
target 'MyApp'
pod 'FMDB'
pod 'DataStoreAdvanced', :git => 'https://github.com/the-mac/data-store-ios.git', :branch => 'advanced'
```

## Author: Christopher Miller
Android/iOS Project Manager

- [Github Profile](https://github.com/cdm2012)
- [Linked-In Profile](https://www.linkedin.com/in/christophermiller64)

## Contributing
See [CONTRIBUTING.md](#) for more on what is required to contribute.

### Current Contributors

Fork the [repo](https://github.com/the-mac/data-store-ios), and be the first to [add a pull request](https://github.com/the-mac/data-store-ios/compare) to our [advanced branch](https://github.com/the-mac/data-store-ios/tree/advanced).

## License

DataStoreAdvanced is available under the MIT license. See the LICENSE file for more info.