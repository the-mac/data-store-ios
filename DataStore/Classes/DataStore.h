//
//  DataStore.h
//  Pods
//
//  Created by Christopher Miller on 20/05/16.
//
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject
+ (void) setup:(NSString*) database;
+ (NSString*) databasePath;
@end
