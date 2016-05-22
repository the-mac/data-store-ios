//
//  DataStore.h
//  Pods
//
//  Created by Christopher Miller on 20/05/16.
//
//

#import <Foundation/Foundation.h>

/** DataStore is a utility class for data containment, made to support the Object Relational Model (ORM) class. The Model class works just like any other ORM, except it is loosely based upon the Laravel Eloquent Model and the following is a basic implementation of the Model class in Objective-C and Swift:
 
 OBJ-C
 ```
     @interface Flight : Model
     @property (strong, nonatomic) NSString *name;
     @property (strong, nonatomic) NSString *destination;
     @end
     
     @implementation Flight
     @end
 ```
 
 SWIFT
 ```
     class Flight : Model {
         var name: String?
         var destination: String?
     }
 ```
 */
@interface DataStore : NSObject

/**
 Accesses NSDictionary of Model and Database properties for a specific Model.
 @param class The class type of the properties to return
 @return An array of NSDictionary objects @[ @{ @"column":@"...", @"type":@"...", @"dataType":@"..." } ]
 */
+ (NSMutableArray *) getFields:(Class) class;

/**
 Sets up the sqlite database for the application
 @param database The SQLite database name, that can also be a prepopulated and bundled db.
 @param tables The collection of Model class references to be used with the database
 */
+ (void) setup:(NSString*) database with:(NSArray*) tables;

/**
 Accesses path of database (placed securely within Library Directory).
 @return the database path used internally for the path to the database
 */
+ (NSString*) databasePath;
@end
