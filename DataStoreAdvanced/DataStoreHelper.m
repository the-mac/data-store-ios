//
//  DataStore.m
//  Pods
//
//  Created by Christopher Miller on 20/05/16.
//
//

#import "FMDB.h"
#import "Model.h"
#import "DataStoreHelper.h"
#import <objc/runtime.h>

static NSString * cachedDatabasePath = nil;

@implementation DataStoreHelper

+ (NSString*) getTableName:(Class) c {
    
    NSString *tableName = NSStringFromClass(c);
    NSArray *parts = [tableName componentsSeparatedByString:@"."];
    if(parts.count > 1) tableName = parts[1];
    
    return tableName;
}

/*!
 
 http://stackoverflow.com/questions/754824/get-an-object-properties-list-in-objective-c
 http://nshipster.com/type-encodings/
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 */
+ (NSString *) getType:(char*) type {
    switch (type[0]) {
        case '@': {
            NSString *typeString = [NSString stringWithUTF8String:type];
            if([@"@\"NSString\"" isEqualToString:typeString]) return @"TEXT";
            else if([@"@\"NSDate\"" isEqualToString:typeString]) return @"DATETIME";
            else if([@"@\"NSNumber\"" isEqualToString:typeString]) return @"NUMERIC";
            else if([@"@\"NSInteger\"" isEqualToString:typeString]) return @"INTEGER";
            return @"BLOB";
        }
        case 'i': // int
        case 's': // short
        case 'l': // long
        case 'q': // long long
        case 'I': // unsigned int
        case 'S': // unsigned short
        case 'L': // unsigned long
        case 'Q': // unsigned long long
        case 'f': // float
        case 'd': // double
        case 'B': // BOOL
        {
            return @"NUMERIC";
        }
        case 'c': // char
        case 'C': // unsigned char
        {
            return @"CHAR";
        }
        default: {
            return [NSString stringWithFormat:@"UNKNOWN TYPE: %s", type];
        }
    }
}
+ (NSMutableArray *) getFields:(Class) class {
    NSMutableArray * fields = [@[] mutableCopy];
    
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList(class, &numberOfProperties);
    
    for (NSUInteger i = 0; i < numberOfProperties; i++) {
        
        objc_property_t property = propertyArray[i];
        NSMutableDictionary *column = [[NSMutableDictionary alloc] init];
        
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        NSString *dataType = [NSString stringWithUTF8String:property_copyAttributeValue(property, "T")];
        NSString *type = [self getType:property_copyAttributeValue(property, "T")];
        
        [column setValue:name forKey:@"column"];
        [column setValue:dataType forKey:@"dataType"];
        [column setValue:type forKey:@"type"];
        
        [fields addObject:column];
    }
    return fields;
}
+ (NSString *)directoryForDatabaseFilename {
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return dirs[0];
}
+ (void) drop:(Class) classType {
    
    NSMutableString *queryString = [[NSMutableString alloc] init];
    NSString *className = [self getTableName:classType];
    [queryString appendString:[NSString stringWithFormat:@"DROP TABLE IF EXISTS '%@'; ", className]];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:cachedDatabasePath];
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL queryResult = [db executeStatements:queryString];
        
        NSLog(@"Model: %@\nqueryString=%@\nqueryResult=%d", className, queryString, queryResult);
    }];
}
+ (void) setup:(NSString*) database with:(NSArray*) tables {
    NSMutableString *lines = [@"" mutableCopy];
    
    NSBundle * mainBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [mainBundle infoDictionary];
    NSString* version = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    [lines appendString:[NSString stringWithFormat:@"mainBundle = %@\n", mainBundle]];
    [lines appendString:[NSString stringWithFormat:@"infoDictionary = %@\n", infoDictionary]];
    [lines appendString:[NSString stringWithFormat:@"version = %@\n", version]];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSFileManager * defaultManager = [NSFileManager defaultManager];
    NSString *databaseDir = [self directoryForDatabaseFilename];
    
    [lines appendString:[NSString stringWithFormat:@"defaults = %@\n", defaults]];
    [lines appendString:[NSString stringWithFormat:@"defaultManager = %@\n", defaultManager]];
    [lines appendString:[NSString stringWithFormat:@"databaseDir = %@\n", databaseDir]];
    
    [defaultManager createDirectoryAtPath:databaseDir
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:nil];
    cachedDatabasePath = [databaseDir stringByAppendingPathComponent:database];
    NSArray *database_parts = [database componentsSeparatedByString:@"."];
    NSString *preloadPath = [mainBundle pathForResource:database_parts[0] ofType:database_parts[1]];
    
    BOOL databaseReadyForCopy = [defaultManager fileExistsAtPath:preloadPath isDirectory:nil];
    BOOL databaseIsAlreadyCached = NO;
    if (databaseReadyForCopy) {
        NSURL* preloadURL = [NSURL fileURLWithPath: preloadPath];
        databaseIsAlreadyCached = [defaultManager fileExistsAtPath:cachedDatabasePath isDirectory:nil];
        if (!databaseIsAlreadyCached) {
            [defaultManager copyItemAtURL:preloadURL toURL:[NSURL fileURLWithPath:cachedDatabasePath] error:nil];
        }
    }
    [lines appendString:[NSString stringWithFormat:@"cachedDatabasePath = %@\n", cachedDatabasePath]];
    [lines appendString:[NSString stringWithFormat:@"database_parts = %@\n", database_parts]];
    [lines appendString:[NSString stringWithFormat:@"preloadPath = %@\n", preloadPath]];
    [lines appendString:[NSString stringWithFormat:@"databaseReadyForCopy = %d\n", databaseReadyForCopy]];
    [lines appendString:[NSString stringWithFormat:@"databaseIsAlreadyCached = %d\n", databaseIsAlreadyCached]];
    
    NSLog(@"%@", lines);
    
    for (id element in tables) {
        lines = [@"" mutableCopy];
        Class classType = [element class];
        NSString *className = [self getTableName:classType];
        
        if(![classType isSubclassOfClass:[Model class]]) {
            NSLog(@"Note: %@ table schema can not be constructed because it is of type %@ instead of Model", className, [classType superclass]);
            continue;
        }
        
        NSArray *columns = [self getFields:classType];
        NSString *savedValue = [defaults stringForKey:className];
        NSMutableString *queryString = [[NSMutableString alloc] init];
        
        [lines appendString:[NSString stringWithFormat:@"savedValue = %@\n", savedValue]];
        [lines appendString:[NSString stringWithFormat:@"version = %@\n", version]];
        [lines appendString:[NSString stringWithFormat:@"className = %@\n", className]];
        [lines appendString:[NSString stringWithFormat:@"columns = %@\n", columns]];
        
        if(savedValue != nil && !DEBUG) { // DATABASE TABLE IS CACHED
            if([version isEqualToString:savedValue]) {
                NSLog(@"Note: To update %@ table schema or populate your database you may need to update your app version from: %@", className, version);
                continue;  // DATABASE TABLE ALREADY AT CORRECT VERSION
            }
            else {
                //[queryString appendString:[NSString stringWithFormat:@"DROP TABLE IF EXISTS '%@'; ", className]];
                // DATABASE TABLE NEEDS MIGRATION (AND SEED)
            }
        }
        
        [queryString appendString:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ( ", className]];
        [queryString appendString:[self generateColumns:columns]];
        [queryString appendString:@");"];
        
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:cachedDatabasePath];
        
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            BOOL queryResult = [db executeStatements:queryString];
            
            [lines appendString:[NSString stringWithFormat:@"queryString = %@\n", queryString]];
            [lines appendString:[NSString stringWithFormat:@"queryResult = %d\n", queryResult]];
        }];
        
        if(version) {
            [defaults setObject:version forKey:className];
            [defaults synchronize];
        }
        NSLog(@"%@", lines);
    }
}

+ (NSString*) generateColumns:(NSArray*)fields {
    
    int position = 0;
    int last_position = (int) [fields count] - 1;
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendString:@"_id INTEGER PRIMARY KEY AUTOINCREMENT, "];
    
    for (NSDictionary *field in fields) {
        NSString *column = [field valueForKey:@"column"];
        NSString *type = [field valueForKey:@"type"];
        
        if(position == last_position) [query appendString:[NSString stringWithFormat:@"%@ %@ ", column, type]];
        else [query appendString:[NSString stringWithFormat:@"%@ %@, ", column, type]];
        position++;
    }
    return query;
}

+ (NSString*) databasePath {
    return cachedDatabasePath;
}
@end
