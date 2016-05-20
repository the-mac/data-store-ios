//
//  Model.h
//  Store
//
//  Created by Christopher Miller on 18/05/16.
//  Copyright © 2016 Operators. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Model : NSObject

/*!
 @brief         The method for counting the total of your Model in database
 @discussion    Call this method when you want the current count of your Model.
 @return        <b>int</b> The Model count.
 */
+ (int) count;

/*!
 @brief         The method for counting the total of your Model in database
 @discussion    Call this method when you want the current count of your Model.
 @return        <b>int</b> The Model count.
 */
//- (int) count;

/*!
 @brief         Creation method for inserting into the database
 @discussion    Call this method when you want to insert an object.
 @return        <b>Model</b> The new Model result of the query.
 */
//- (Model *) create:(NSDictionary*)data;

/*!
 @brief         Search method for first object in the database
 @discussion    Call this method when you want to find the first object.
 @return        <b>Model</b> The results of the query, or returns nil when not found.
 */
//- (Model *) first;

/*!
 @brief         Search method for first object meeting criteria, or create one
 @discussion    Call this method when you want to find the first object in the database and creates one when no result exists.
 @return        <b>NSArray</b> The results of the query, or creates a new one.
 */
//- (NSArray *) firstOrCreate:(NSDictionary*)data;

/*!
 @brief         Search method for first object meeting criteria, or instantiates one
 @discussion    Call this method when you want to find the first object in the database and instantiates one when no result exists.
 @return        <b>NSArray</b> The results of the query, or instantiates a new one.
 */
//- (NSArray *) firstOrNew:(NSDictionary*)data;

/*!
 @brief         Search method for first object, that fails when data is not found
 @discussion    Call this method when you want to find the first object in the database and fail when no results.
 @return        <b>NSArray</b> The results of the query, or fails with Exception.
 */
//- (NSArray *) firstOrFail;

/*!
 @brief         Search method for queries to the database
 @discussion    Call this method when you want to start a query.
 @return        <b>Model</b> The query model, which allows appending query components.
 */
//- (Model *) query;

/*!
 @brief         Search method for queries to the database
 @discussion    Call this method when you want to find data by the database primaryKey.
 @return        <b>NSArray</b> The results of the query, or returns nil when not found.
 */
//- (NSArray *) find:(id)identifier;

/*!
 @brief         Search method for queries to the database, that fails when data not found
 @discussion    Call this method when you want to find data by the database primaryKey.
 @return        <b>NSArray</b> The results of the query, or fails with Exception.
 */
//- (NSArray *) findOrFail:(id)identifier;

/*!
 @brief         Builder method for queries to the database
 @discussion    Call this method when you want to add a where clause to a query to the database.
 @return        <b>Model</b> The query model, which allows appending query components.
 */
//- (Model *) where:(NSString*)field is:(id);


/*!
 @brief         Builder method for queries to the database, with comparison operator included
 @discussion    Call this method when you want to add a where clause to a query to the database.
 @return        <b>Model</b> The query model, which allows appending query components.
 */
//- (Model *) where:(NSString*)field comparisonOperator:(char) queryOperator is:(id);

/*!
 @brief         Builder method for queries to the database
 @discussion    Call this method when you want to add a where clause to a query to the database.
 @return        <b>Model</b> The query model, which allows appending query components.
 */
//- (Model *) orWhere:(NSString*)field is:(id);

/*!
 @brief         Builder method for queries to the database, with comparison operator included
 @discussion    Call this method when you want to add a where clause to a query to the database.
 @return        <b>Model</b> The query model, which allows appending query components.
 */
//- (Model *) orWhere:(NSString*)field comparisonOperator:(char) queryOperator is:(id);

/*!
 @brief         Builder method for ordering to the database
 @discussion    Call this method when you want to order the results from the database.
 @return        <b>Model</b> The query model, which allows appending query components.
 */
//- (Model *) orderBy:(NSString*)field direction:(NSString*)direction;

/*!
 @brief         Builder method for limiting results from the database
 @discussion    Call this method when you want to limit the results from the database.
 @return        <b>Model</b> The query model, which allows appending query components.
 */
//- (Model *) take:(NSInteger)amount;

/*!
 @brief         Retrieve objects from the database table
 @discussion    Call this method when you want to get the results from your query to the database table.
 @return        <b>NSArray</b> The results array.
 */
//- (NSArray *) get;

/*!
 @brief         Retrieve all objects from the database table
 @discussion    Call this method when you want to get all results from your query to the database table.
 @return        <b>NSArray</b> The results array.
 */
+ (NSArray *) all;

/*!
 @brief         Retrieve all objects from the database table
 @discussion    Call this method when you want to get all results from your query to the database table.
 @return        <b>NSArray</b> The results array.
 */
//- (NSArray *) all;

/*!
 @brief         Retrieve all objects from the database table, with specific fields
 @discussion    Call this method when you want to query for objects.
 @return        <b>Model</b> The new Model result of the query.
 */
//- (NSArray *) all:(NSDictionary*)data;

/*!
 @brief         Save object to the database
 @discussion    Call this method when you want to save the object in the database.
 @return        <b>BOOL</b> YES on success and NO on failiure.
 */
- (BOOL) save;
/*!
 @brief         Save object to the database, that fails when data is not saveable
 @discussion    Call this method when you want to save the object in the database.
 @return        <b>BOOL</b> YES on success, or fails with Exception.
 */
//- (BOOL) saveOrFail;

/*!
 @brief         Remove object from the database
 @discussion    Call this method when you want to remove the object in the database.
 @return        <b>BOOL</b> YES on success and NO on failiure.
 */
//- (BOOL) remove;

/*!
 @brief         Truncate the objects from the database
 @discussion    Call this method when you want to destroy the object in the database.
 @return        <b>BOOL</b> YES on success and NO on failiure.
 */
+ (BOOL) truncate;

@end
