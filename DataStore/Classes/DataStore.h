//
//  DataStore.h
//  Pods
//
//  Created by Christopher Miller on 20/05/16.
//
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject
+ (NSMutableArray *) getFields:(Class) class;
+ (void) setup:(NSString*) database with:(NSArray*) tables;
+ (NSString*) databasePath;
@end
