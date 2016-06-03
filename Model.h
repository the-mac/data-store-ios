//
//  Model.h
//  Store
//
//  Created by Christopher Miller on 18/05/16.
//  Copyright © 2016 Operators. All rights reserved.
//

#import <Foundation/Foundation.h>

/** The Model class is a new Object Relational Model (ORM) based upon Laravel Eloquent Models, and made specifically for iOS development.<br/><br/>Each property of the Model class implementation will generate the appropriate column in the underlying database table.<br/><br/>As in the example below, to pass data to a Flight database table, the Model class needs to be subclassed and a save message needs to be passed to the Flight instance.
 
 ```
 Flight *flight = [[Flight alloc] init];    // Or in Swift: let flight = Flight()
 
 flight.name = @"Flight 143";               // Or in Swift: flight.name = "Flight 143"
 
 [flight save];                             // Or in Swift: flight.save()
 ```
 */
@interface Model : NSObject
/*!
 @brief         The database id for Model records
 @discussion    This property can be used to find records, as well as update records.
 @return        <b>NSNumber</b> A reference to the Model autoincrementing primary key.
 */
@property (readonly, nonatomic) NSNumber *_id;

/*!
 @discussion    Execute this function when you want the current Model's class type.
 @return        <b>Class</b> The Model type.
 */
//+ (Class) classType;

/*!
 @brief         The function counts the total number of records in a table
 @discussion    Execute this function when you want the current count of your Model.
 @return        <b>int</b> The Model count.
 */
+ (int) count;

/*!
 @brief         The method for counting the total of your Model in database
 @discussion    Execute this method when you want the current count of your Model.
 @return        <b>int</b> The Model count.
 */
//- (int) count;

/*!
 @brief         Creation method for inserting into the database
 @discussion    Execute this method when you want to insert an record.
 @return        <b>Model</b> The new Model result of the query.
 */
+ (Model *) create:(NSDictionary*)data;

/*!
 @brief         Search method for first record in the database
 @discussion    Execute this method when you want to find the first record.
 @return        <b>Model</b> The results of the query, or returns nil when not found.
 */
//- (Model *) first;

/*!
 @brief         Search method for first record meeting criteria, or create one
 @discussion    Execute this method when you want to find the first record in the database and creates one when no result exists.
 @return        <b>NSArray</b> The results of the query, or creates a new one.
 */
//- (NSArray *) firstOrCreate:(NSDictionary*)data;

/*!
 @brief         Search method for first record meeting criteria, or instantiates one
 @discussion    Execute this method when you want to find the first record in the database and instantiates one when no result exists.
 @return        <b>NSArray</b> The results of the query, or instantiates a new one.
 */
//- (NSArray *) firstOrNew:(NSDictionary*)data;

/*!
 @brief         Search method for first record, that fails when data is not found
 @discussion    Execute this method when you want to find the first record in the database and fail when no results.
 @return        <b>NSArray</b> The results of the query, or fails with Exception.
 */
//- (NSArray *) firstOrFail;

/*!
 @brief         Search method for queries to the database
 @discussion    Execute this method when you want to start a query.
 @return        <b>Model</b> The query record, which allows appending query components.
 */
//- (Model *) query;

/*!
 @brief         Searches for a specific record in the database
 @discussion    Execute this function when you want to find a record by its autoincrement _id.
 @return        <b>Model</b> A model intance, or returns nil when not found.
 */
+ (Model *) find:(int)identifier;

/*!
 @brief         Search method for queries to the database, that fails when data not found
 @discussion    Execute this method when you want to find data by the database primaryKey.
 @return        <b>NSArray</b> The results of the query, or fails with Exception.
 */
//- (NSArray *) findOrFail:(id)identifier;

/*!
 @discussion    Execute this method when you want to add a where clause to a query to the database.
 @return        <b>Model</b> The model which allows appending query components.
 */
+ (Model*) where:(NSString*) column is:(NSObject*) value;

/*!
 @discussion    Execute this method when you want to add a where clause to a query to the database.
 @return        <b>Model</b> The model which allows appending query components.
 */
- (Model*) where:(NSString*) column is:(NSObject*) value;

/*!
 @discussion    Execute this method when you want to add a where clause to a query to the database.
 @return        <b>Model</b> The model which allows appending query components.
 */
+ (Model*) where:(NSString*) column inside:(NSArray*) values;

/*!
 @discussion    Execute this method when you want to add a where clause to a query to the database.
 @return        <b>Model</b> The model which allows appending query components.
 */
- (Model*) where:(NSString*) column inside:(NSArray*) values;

/*!
 @brief         Builder method for queries to the database, with comparison operator included
 @discussion    Execute this method when you want to add a where clause to a query to the database.
 @return        <b>Model</b> The query record, which allows appending query components.
 */
//- (Model *) where:(NSString*)field comparisonOperator:(char) queryOperator is:(id);

/*!
 @brief         Builder method for queries to the database
 @discussion    Execute this method when you want to add a where clause to a query to the database.
 @return        <b>Model</b> The query record, which allows appending query components.
 */
- (Model *) orWhere:(NSString*)field is:(NSObject*)obj;

/*!
 @brief         Builder method for queries to the database, with comparison operator included
 @discussion    Execute this method when you want to add a where clause to a query to the database.
 @return        <b>Model</b> The query record, which allows appending query components.
 */
//- (Model *) orWhere:(NSString*)field comparisonOperator:(char) queryOperator is:(id);

/*!
 @brief         Builder method for ordering to the database
 @discussion    Execute this method when you want to order the results from the database.
 @return        <b>Model</b> The query record, which allows appending query components.
 */
//- (Model *) orderBy:(NSString*)field direction:(NSString*)direction;

/*!
 @brief         Builder method for limiting results from the database
 @discussion    Execute this method when you want to limit the results from the database.
 @return        <b>Model</b> The query record, which allows appending query components.
 */
//- (Model *) take:(NSInteger)amount;

/*!
 @brief         Retrieve records from the database table
 @discussion    Execute this method when you want to get the results from your query to the database table.
 @return        <b>NSArray</b> The results array.
 */
- (NSArray *) get;

/*!
 @brief         Retrieves all records from the table
 @discussion    Execute this function when you want to get all results from your database table.
 @return        <b>NSArray</b> The results array.
 */
+ (NSArray *) all;

/*!
 @brief         Retrieve all records from the database table
 @discussion    Execute this method when you want to get all results from your query to the database table.
 @return        <b>NSArray</b> The results array.
 */
//- (NSArray *) all;

/*!
 @brief         Retrieve all records from the database table, with specific fields
 @discussion    Execute this method when you want to query for records.
 @return        <b>Model</b> The new Model result of the query.
 */
//- (NSArray *) all:(NSDictionary*)data;

/*!
 @brief         Save record to the database
 @discussion    Execute this method when you want to save the record into the database table.
 @return        <b>BOOL</b> YES on success and NO on failiure.
 */
- (BOOL) save;

/*!
 @brief         Update record in the database
 @discussion    Execute this method when you want to update the record in the database table.
 @return        <b>NSInteger/BOOL</b> count on successful updates and NO on failiure.
 */
- (NSInteger) update:(NSMutableDictionary*) attributes;

/*!
 @brief         Update record in the database
 @discussion    Execute this method when you want to update the record in the database table.
 @return        <b>NSInteger/BOOL</b> count on successful updates and NO on failiure.
 */
+ (NSInteger) update:(NSMutableDictionary*) attributes;
/*!
 @brief         Save record to the database, that fails when data is not saveable
 @discussion    Execute this method when you want to save the record in the database.
 @return        <b>BOOL</b> YES on success, or fails with Exception.
 */
//- (BOOL) saveOrFail;

/*!
 @brief         Remove record from the database
 @discussion    Execute this method when you want to remove the record from the database.
 @return        <b>BOOL</b> YES on success and NO on failiure.
 */
- (BOOL) remove;

/*!
 @brief         Truncate the records from the database
 @discussion    Execute this function when you want to remove all records from the database table.
 @return        <b>BOOL</b> YES on success and NO on failiure.
 */
+ (BOOL) truncate;

/*!
 @discussion    Execute this function when you want to generate a model object from a NSDictionary.
 @return        <b>Model</b> Model Object but not saved
 */
//+ (Model *) generateModel:(NSDictionary *) result forClass:(Class) c;
@end
