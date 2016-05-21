//
//  DataStore.m
//  Pods
//
//  Created by Christopher Miller on 20/05/16.
//
//

#import "FMDB.h"
#import "DataStore.h"
#import <objc/runtime.h>

static NSString * cachedDatabasePath = nil;

@implementation DataStore

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
        NSString *type = [DataStore getType:property_copyAttributeValue(property, "T")];
        
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
+ (void) setup:(NSString*) database with:(NSArray*) tables {
    
    NSBundle * mainBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [mainBundle infoDictionary];
    NSString* version = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSFileManager * defaultManager = [NSFileManager defaultManager];
    NSString *databaseDir = [DataStore directoryForDatabaseFilename];
    
    [defaultManager createDirectoryAtPath:databaseDir
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:nil];
    cachedDatabasePath = [databaseDir stringByAppendingPathComponent:database];
    NSArray *database_parts = [database componentsSeparatedByString:@"."];
    NSString *preloadPath = [mainBundle pathForResource:database_parts[0] ofType:database_parts[1]];
    
    if ([defaultManager fileExistsAtPath:preloadPath isDirectory:NO]) {
        NSURL* preloadURL = [NSURL fileURLWithPath: preloadPath];

        if (![defaultManager fileExistsAtPath:cachedDatabasePath isDirectory:NO]) {
            [defaultManager copyItemAtURL:preloadURL toURL:[NSURL fileURLWithPath:cachedDatabasePath] error:nil];
        }
    }
    
    for (id element in tables){
        NSLog(@"%@",element);
        Class class = [element class];
        
        NSArray *columns = [DataStore getFields:class];
        NSString *className = NSStringFromClass (class);
        NSString *savedValue = [defaults stringForKey:className];
        NSMutableString *queryString = [[NSMutableString alloc] init];
        
        if(savedValue != nil) { // DATABASE TABLE IS CACHED
            if([version isEqualToString:savedValue]) continue;  // DATABASE TABLE ALREADY AT CORRECT VERSION
            else {
                // DATABASE TABLE NEEDS MIGRATION/SEED
                [queryString appendString:[NSString stringWithFormat:@"DROP TABLE IF EXISTS '%@'; ", className]];
            }
        }
        
        // DATABASE TABLE NEEDS MIGRATION ()
        [queryString appendString:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ( ", className]];
        
        int position = 0;
        int last_position = (int) [columns count] - 1;
        
        [queryString appendString:@"_id INTEGER PRIMARY KEY AUTOINCREMENT, "];
        
        for (NSDictionary *field in columns) {
            NSString *column = [field valueForKey:@"column"];
            NSString *type = [field valueForKey:@"type"];
            
            if(position == last_position) [queryString appendString:[NSString stringWithFormat:@"%@ %@ ", column, type]];
            else [queryString appendString:[NSString stringWithFormat:@"%@ %@, ", column, type]];
            position++;
        }
        
        [queryString appendString:@");"];
        
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DataStore databasePath]];
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            NSLog(@"queryString=%@",queryString);
            
            [db executeStatements:queryString];
            
            NSString *queryResult = @"";
            NSLog(@"queryResult=%@",queryResult);
        }];
        
        [defaults setObject:version forKey:className];
        [defaults synchronize];
    }
    
    
}

+ (NSString*) databasePath {
    return cachedDatabasePath;
}
@end
