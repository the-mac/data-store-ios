//
//  DataStore.m
//  Pods
//
//  Created by Christopher Miller on 20/05/16.
//
//

#import "DataStore.h"

static NSString * cachedDatabasePath = nil;

@implementation DataStore
+ (void) setup:(NSString*) database {
    cachedDatabasePath = database;
}

+ (NSString*) databasePath {
    return cachedDatabasePath;
}
@end
