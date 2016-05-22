//
//  Model.h
//  Store
//
//  Created by Christopher Miller on 18/05/16.
//  Copyright © 2016 Operators. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/** The Model class is a new Object Relational Model (ORM) implementation for iOS, specifically made for ease of use. This implementation is loosely based upon Laravel Eloquent Models. Each property of the Model class implementation will generate the appropriate column in the underlying database table.<br/><br/>As in the example below, to pass data to the Flight database table, the Model class needs to be implemented and a save message needs to passed to the Model instance.
 
 ```
     Flight *flight = [[Flight alloc] init];
     // Or in Swift: let flight = Flight()
     
     flight.name = @"Flight 143";
     // Or in Swift: flight.name = "Flight 143"
     
     [flight save];
     // Or in Swift: flight.save()
 ```
 */
@interface Model : NSObject
/*!
 @brief         The autoincrementing database id for Model records in the table
 @discussion    This property can be used to find records, as well as update the Model.
 @return        <b>NSNumber</b> The Model autoincrementing identifier.
 */
@property (readonly, nonatomic) NSNumber *_id;

/*!
 @brief         The function for counting the total of your Model in database
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
 @discussion    Execute this method when you want to insert an model.
 @return        <b>Model</b> The new Model result of the query.
 */
//- (Model *) create:(NSDictionary*)data;

/*!
 @brief         Search method for first model in the database
 @discussion    Execute this method when you want to find the first model.
 @return        <b>Model</b> The results of the query, or returns nil when not found.
 */
//- (Model *) first;

/*!
 @brief         Search method for first model meeting criteria, or create one
 @discussion    Execute this method when you want to find the first model in the database and creates one when no result exists.
 @return        <b>NSArray</b> The results of the query, or creates a new one.
 */
//- (NSArray *) firstOrCreate:(NSDictionary*)data;

/*!
 @brief         Search method for first model meeting criteria, or instantiates one
 @discussion    Execute this method when you want to find the first model in the database and instantiates one when no result exists.
 @return        <b>NSArray</b> The results of the query, or instantiates a new one.
 */
//- (NSArray *) firstOrNew:(NSDictionary*)data;

/*!
 @brief         Search method for first model, that fails when data is not found
 @discussion    Execute this method when you want to find the first model in the database and fail when no results.
 @return        <b>NSArray</b> The results of the query, or fails with Exception.
 */
//- (NSArray *) firstOrFail;

/*!
 @brief         Search method for queries to the database
 @discussion    Execute this method when you want to start a query.
 @return        <b>Model</b> The query model, which allows appending query components.
 */
//- (Model *) query;

/*!
 @brief         Search method for models in the database
 @discussion    Execute this function when you want to find a model by its autoincrement _id.
 @return        <b>NSArray</b> The results of the query, or returns nil when not found.
 */
+ (Model *) find:(int)identifier;

/*!
 @brief         Search method for queries to the database, that fails when data not found
 @discussion    Execute this method when you want to find data by the database primaryKey.
 @return        <b>NSArray</b> The results of the query, or fails with Exception.
 */
//- (NSArray *) findOrFail:(id)identifier;

/*!
 @brief         Builder method for queries to the database
 @discussion    Execute this method when you want to add a where clause to a query to the database.
 @return        <b>Model</b> The query model, which allows appending query components.
 */
//- (Model *) where:(NSString*)field is:(id);


/*!
 @brief         Builder method for queries to the database, with comparison operator included
 @discussion    Execute this method when you want to add a where clause to a query to the database.
 @return        <b>Model</b> The query model, which allows appending query components.
 */
//- (Model *) where:(NSString*)field comparisonOperator:(char) queryOperator is:(id);

/*!
 @brief         Builder method for queries to the database
 @discussion    Execute this method when you want to add a where clause to a query to the database.
 @return        <b>Model</b> The query model, which allows appending query components.
 */
//- (Model *) orWhere:(NSString*)field is:(id);

/*!
 @brief         Builder method for queries to the database, with comparison operator included
 @discussion    Execute this method when you want to add a where clause to a query to the database.
 @return        <b>Model</b> The query model, which allows appending query components.
 */
//- (Model *) orWhere:(NSString*)field comparisonOperator:(char) queryOperator is:(id);

/*!
 @brief         Builder method for ordering to the database
 @discussion    Execute this method when you want to order the results from the database.
 @return        <b>Model</b> The query model, which allows appending query components.
 */
//- (Model *) orderBy:(NSString*)field direction:(NSString*)direction;

/*!
 @brief         Builder method for limiting results from the database
 @discussion    Execute this method when you want to limit the results from the database.
 @return        <b>Model</b> The query model, which allows appending query components.
 */
//- (Model *) take:(NSInteger)amount;

/*!
 @brief         Retrieve models from the database table
 @discussion    Execute this method when you want to get the results from your query to the database table.
 @return        <b>NSArray</b> The results array.
 */
//- (NSArray *) get;

/*!
 @brief         Retrieve all models from the database table
 @discussion    Execute this function when you want to get all results from your database table.
 @return        <b>NSArray</b> The results array.
 */
+ (NSArray *) all;

/*!
 @brief         Retrieve all models from the database table
 @discussion    Execute this method when you want to get all results from your query to the database table.
 @return        <b>NSArray</b> The results array.
 */
//- (NSArray *) all;

/*!
 @brief         Retrieve all models from the database table, with specific fields
 @discussion    Execute this method when you want to query for models.
 @return        <b>Model</b> The new Model result of the query.
 */
//- (NSArray *) all:(NSDictionary*)data;

/*!
 @brief         Save model to the database
 @discussion    Execute this method when you want to save the model data into the database.
 @return        <b>BOOL</b> YES on success and NO on failiure.
 */
- (BOOL) save;
/*!
 @brief         Save model to the database, that fails when data is not saveable
 @discussion    Execute this method when you want to save the model in the database.
 @return        <b>BOOL</b> YES on success, or fails with Exception.
 */
//- (BOOL) saveOrFail;

/*!
 @brief         Remove model from the database
 @discussion    Execute this method when you want to remove the model from the database.
 @return        <b>BOOL</b> YES on success and NO on failiure.
 */
- (BOOL) remove;

/*!
 @brief         Truncate the models from the database
 @discussion    Execute this function when you want to destroy the model in the database.
 @return        <b>BOOL</b> YES on success and NO on failiure.
 */
+ (BOOL) truncate;

@end
