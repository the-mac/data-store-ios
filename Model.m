//
//  Model.m
//  DataStoreAdvanced
//
//  Created by Christopher Miller on 18/05/16.
//  Copyright © 2016 Operators. All rights reserved.
//

#import "FMDB.h"
#import "DataStoreHelper.h"
#import "Model.h"
#import <objc/runtime.h>


#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
typedef UIImage Image; // Image is an alias for UIImage
#else
#import <Cocoa/Cocoa.h>
typedef NSImage Image; // Image is an alias for NSImage
#endif

static Model * queryInstance = nil;
static NSMutableString * queryString = nil;
static NSMutableDictionary * queryFields = nil;

@interface Model ()
@property(readwrite, nonatomic, strong) NSNumber *_id;
@end

@implementation Model
+ (void) initialize {
    [Model clearQuery];
}
+ (void) clearQuery {
    queryInstance = [[self class] new];
    queryString = [@"" mutableCopy];
}
+ (NSMutableArray *) getFields:(Class) class {
    if(queryFields == nil) queryFields = [@{} mutableCopy];
    
    NSString *tableName = NSStringFromClass(class);
    NSMutableArray* fields = [queryFields objectForKey:tableName];
    
    if(fields != nil) return fields;
    
    fields = [DataStoreHelper getFields:class];
    [queryFields setValue:fields forKey:tableName];
    
    return fields;
}
+ (NSMutableArray *) getKeys:(NSObject*) obj {
    Class class = [obj class];
    NSMutableArray* fields = [Model getFields:class];
    NSMutableArray* keys = [@[] mutableCopy];
    
    for (NSDictionary* field in fields) {
        NSString *value = [obj valueForKey:field[@"column"]];
        if(value != nil) [keys addObject:field[@"column"]];
    }
    
    return keys;
}
+ (NSMutableArray *) getValues:(NSObject*) obj {
    Class class = [obj class];
    NSMutableArray* fields = [Model getFields:class];
    NSMutableArray* values = [@[] mutableCopy];
    
    for (NSDictionary* field in fields) {
        NSString *value = [obj valueForKey:field[@"column"]];
        if(value != nil) [values addObject:value];
    }
    
    return values;
}
+ (NSMutableString *) getParams:(NSObject*) obj {
    Class class = [obj class];
    NSMutableArray* fields = [Model getFields:class];
    NSMutableString* values = [@"" mutableCopy];
    
    for (NSDictionary* field in fields) {
        NSString *value = [obj valueForKey:field[@"column"]];
        if(value != nil) [values appendFormat:@"%@='%@',", field[@"column"], value];
    }
    
    [values deleteCharactersInRange:NSMakeRange([values length] - 1, 1)];
    
    return values;
}

+ (NSMutableString *) getDictionaryParams:(NSMutableDictionary*) obj {
    NSMutableString* pairs = [@"" mutableCopy];
    
    for (NSString* field in obj) {
        [pairs appendFormat:@"%@=:%@,", field, field];
    }
    
    [pairs deleteCharactersInRange:NSMakeRange([pairs length] - 1, 1)];
    
    return pairs;
}

+ (NSString*) getTableName:(Class) c {
    return [DataStoreHelper getTableName:c];
}
-(id)init {
    self = [super init];
    if(self) {
        self._id = [NSNumber numberWithInt:-111];
    }
    return self;
}


+ (Model *) create:(NSMutableDictionary*)data {
    Model * model = [Model generateModel:data forClass:[self class]];
    [model save];
    return model;
}
- (BOOL) save {
    NSLog(@"called %s", __FUNCTION__);
    __block BOOL result = YES;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DataStoreHelper databasePath]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *table = [Model getTableName:[self class]];
        
        NSString *query = nil;
        
        if(![self._id isEqual:[NSNumber numberWithInt:-111]]) {
            
            NSString *params = [Model getParams: self];
            query = [NSString stringWithFormat:@"update %@ set %@ where _id='%@'", table, params, self._id];
            NSLog(@"query =%@", query);
            
            [queryString appendString:query];
            result = [db executeUpdate:queryString];
        } else {
            
            
            NSMutableArray *keys = [Model getKeys: self];
            NSLog(@"keys =%@", [keys description]);
            
            NSString *columns =  [[keys valueForKey:@"description"] componentsJoinedByString:@", "];
            NSLog(@"columns =%@", columns);
            
            NSString *param = @", ?";
            NSString *params = [@"?" stringByPaddingToLength:(keys.count - 1) * param.length + 1 withString:param startingAtIndex:0];
            
            query = [NSString stringWithFormat:@"insert into %@(%@) values (%@)", table, columns, params];
            NSLog(@"query =%@", query);
            
            self._id = [NSNumber numberWithInt:[[self class] count] + 1];
            
            [queryString appendString:query];
            
            NSArray * values = [Model getValues: self];
            NSLog(@"values =%@", values);
            result = [db executeUpdate:queryString withArgumentsInArray:values];
            
        }
    }];
    
    [Model clearQuery];
    NSLog(@"result =%d", result);

    return result;
}
- (NSInteger) update:(NSMutableDictionary*) attributes {
    
    if(self != queryInstance) @throw([NSException exceptionWithName:@"Illegal Action" reason:@"This method can not be called directly by an instance" userInfo:nil]);
    
    NSLog(@"called %s", __FUNCTION__);
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DataStoreHelper databasePath]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *query = nil;
        NSString *table = [Model getTableName:[self class]];
        NSString *params = [Model getDictionaryParams: attributes];
        
        if(queryString.length == 0) query = [NSString stringWithFormat:@"update %@ set %@", table, params];
        else query = [NSString stringWithFormat:@"update %@ set %@ where %@", table, params, queryString];
        NSLog(@"query =%@", query);
        
        [db executeUpdate:query withParameterDictionary:attributes];
        
    }];
    
    [Model clearQuery];
    return 0;
}
+ (NSInteger) update:(NSMutableDictionary*) attributes {
    if(queryString.length == 0) queryInstance = [[self class] new];
    return [queryInstance update:attributes];
}
- (NSArray*) get {
    
    if(self != queryInstance) @throw([NSException exceptionWithName:@"Illegal Action" reason:@"This method can not be called directly by an instance" userInfo:nil]);
    
    NSLog(@"called %s", __FUNCTION__);
    NSMutableArray *allResults = [[NSMutableArray alloc] init];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DataStoreHelper databasePath]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *query = nil;
        NSString *table = [Model getTableName:[self class]];
        
        if(queryString.length == 0) query = [NSString stringWithFormat:@"select * from %@", table];
        else query = [NSString stringWithFormat:@"select * from %@ where %@", table, queryString];
        NSLog(@"query =%@", query);
        
        
        FMResultSet *results = [db executeQuery:query];
        
        while([results next]) {
            [allResults addObject:[Model generateNSObject:results forClass:[self class]]];
        }
        [results close];
    }];
    
    [Model clearQuery];
    return allResults;
}

- (Model*) where:(NSString*) column is:(NSObject*) value {
    if(self != queryInstance) @throw([NSException exceptionWithName:@"Illegal Action" reason:@"This method can not be called directly by an instance" userInfo:nil]);
    
    NSString *equivalence = nil;
    NSString *query = nil;
    
    if([[value description] rangeOfString:@"%"].location == NSNotFound)
        equivalence = @"=";
    else equivalence = @"like";
    
    
    if(queryString.length == 0) query = [NSString stringWithFormat:@"%@ %@ '%@'", column, equivalence, value];
    else query = [NSString stringWithFormat:@" and %@ %@ '%@'", column, equivalence, value];
    [queryString appendString:query];
    
    return queryInstance;
}
+ (Model*) where:(NSString*) column is:(NSObject*) value {
    if(queryString.length == 0) queryInstance = [[self class] new];
    return [queryInstance where:column is:value];
}


- (Model*) where:(NSString*) column inside:(NSArray*) values {
    if(self != queryInstance) @throw([NSException exceptionWithName:@"Illegal Action" reason:@"This method can not be called directly by an instance" userInfo:nil]);
    
    NSString *equivalence = @"in";
    NSString *query = nil;
    
    NSString *value = [values componentsJoinedByString:@"', '"];
    
    if(queryString.length == 0) query = [NSString stringWithFormat:@"%@ %@ ('%@')", column, equivalence, value];
    else query = [NSString stringWithFormat:@" and %@ %@ '%@'", column, equivalence, value];
    [queryString appendString:query];
    
    return queryInstance;
    
}
+ (Model*) where:(NSString*) column inside:(NSArray*) values {
    if(queryString.length == 0) queryInstance = [[self class] new];
    return [queryInstance where:column inside:values];
}

- (Model *) orWhere:(NSString*)column is:(NSObject*)value {
    
    if(self != queryInstance) @throw([NSException exceptionWithName:@"Illegal Action" reason:@"This method can not be called directly by an instance" userInfo:nil]);
    
    NSString *equivalence = nil;
    NSString *query = nil;
    
    if([[value description] rangeOfString:@"%"].location == NSNotFound)
        equivalence = @"=";
    else equivalence = @"like";
    
    if(queryString.length == 0) query = [NSString stringWithFormat:@"%@ %@ '%@'", column, equivalence, value];
    else query = [NSString stringWithFormat:@" or %@ %@ '%@'", column, equivalence, value];
    [queryString appendString:query];
    
    return queryInstance;
}
+ (Model*) orWhere:(NSString*) column is:(NSObject*) value {
    if(queryString.length == 0) queryInstance = [[self class] new];
    return [queryInstance orWhere:column is:value];
}

+ (Model *) find:(int)identifier {
    
    __block int _id = identifier;
    __block Model *model = nil;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DataStoreHelper databasePath]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *table = [Model getTableName:[self class]];
        [queryString appendString:[NSString stringWithFormat:@"select * from %@ where _id='%d'", table, _id]];
        FMResultSet *results = [db executeQuery:queryString];
        
        while([results next]) {
            model = (Model*) [self generateNSObject:results forClass:[self class]];
            model._id = [NSNumber numberWithInt:[results intForColumnIndex:0]];
            break;
        }
        [results close];
    }];
    
    [Model clearQuery];
    return model;
    
}
+ (NSArray *) all {
    
    NSMutableArray *allResults = [[NSMutableArray alloc] init];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DataStoreHelper databasePath]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *table = [Model getTableName:[self class]];
        [queryString appendString:[NSString stringWithFormat:@"select * from %@", table]];
        FMResultSet *results = [db executeQuery:queryString];
        
        while([results next]) {
            [allResults addObject:[self generateNSObject:results forClass:[self class]]];
        }
        [results close];
    }];
    
    [Model clearQuery];
    return allResults;
}
+ (int) count {
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DataStoreHelper databasePath]];
    __block int count = -1;
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *table = [Model getTableName:[self class]];
        NSString *query = [NSString stringWithFormat:@"select count(*) from (%@)", table];
        
        [queryString appendString:query];
        FMResultSet *rsl = [db executeQuery:queryString];
        while ([rsl next]) {
            count = [rsl intForColumnIndex:0];
        }
        [rsl close];
    }];
    [Model clearQuery];
    return count;
}
- (BOOL) remove {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DataStoreHelper databasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *table = [Model getTableName:[self class]];
        
        NSString *query = nil;
        if(queryString.length == 0) query = [NSString stringWithFormat:@"delete from %@ where _id='%@'", table, self._id];
        else query = [NSString stringWithFormat:@"delete from %@ where %@", table, queryString];
        NSLog(@"query =%@", query);
        
        [db executeUpdate:query];
    }];
    
    [Model clearQuery];
    return YES;
}
+ (BOOL) truncate {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DataStoreHelper databasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *table = [Model getTableName:[self class]];
        [queryString appendString:[NSString stringWithFormat:@"delete from %@", table]];
        [db executeUpdate:queryString];
    }];
    
    [Model clearQuery];
    return YES;
}

+ (NSObject *) generateNSObject:(FMResultSet *) result forClass:(Class) class {
    
    NSObject * object = [class new];
    NSArray *columns = [Model getFields:class];
    
    NSNumber* _id = (NSNumber*)[result objectForColumnIndex:0];
    [object setValue:_id forKey:@"_id"];
    
    for (NSDictionary *field in columns) {
        NSString *column       = [field valueForKey:@"column"];
        NSString *type       = [field valueForKey:@"dataType"];
        
        const char *typeValue = [type UTF8String];
        
        switch (typeValue[0]) {
            case 'i': [object setValue:[NSNumber numberWithInt:[result intForColumn:column]] forKey:column]; break;
            case 's': [object setValue:[NSNumber numberWithShort:[result intForColumn:column]] forKey:column]; break;
            case 'l': [object setValue:[NSNumber numberWithLong:[result longForColumn:column]] forKey:column]; break;
            case 'q': [object setValue:[NSNumber numberWithLongLong:[result longLongIntForColumn:column]] forKey:column]; break;
            case 'I': [object setValue:[NSNumber numberWithInt:[result intForColumn:column]] forKey:column]; break;
            case 'S': [object setValue:[result stringForColumn:column] forKey:column]; break;
            case 'L': [object setValue:[NSNumber numberWithLong:[result longForColumn:column]] forKey:column]; break;
            case 'Q': [object setValue:[NSNumber numberWithLong:[result longForColumn:column]] forKey:column]; break;
            case 'f': [object setValue:[NSNumber numberWithFloat:[result doubleForColumn:column]] forKey:column]; break;
            case 'd': [object setValue:[NSNumber numberWithDouble:[result doubleForColumn:column]] forKey:column]; break;
            case 'B': [object setValue:[NSNumber numberWithInt:[result intForColumn:column]] forKey:column]; break;
            case 'C': [object setValue:[result stringForColumn:column] forKey:column]; break;
            case 'c': [object setValue:[result stringForColumn:column] forKey:column]; break;
            default:
                
                if([type isEqualToString:@"@\"NSNumber\""]) {
                    [object setValue:[result objectForColumnName:column] forKey:column];
                }
                else if([type isEqualToString:@"@\"NSString\""]) {
                    [object setValue:[result stringForColumn:column] forKey:column];
                }
                else if([type isEqualToString:@"@\"NSArray\""]) {
                    NSData *data = [result dataForColumn:column];
                    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [object setValue:array forKey:column];
                }
                else if([type isEqualToString:@"@\"NSData\""]) {
                    [object setValue:[result dataForColumn:column] forKey:column];
                }
                else if([type isEqualToString:@"@\"NSSet\""]) {
                    NSData *data = [result dataForColumn:column];
                    NSSet *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [object setValue:array forKey:column];
                }
                else if([type isEqualToString:@"@\"NSURL\""]) {
                    [object setValue:[NSURL URLWithString:[result stringForColumn:column]] forKey:column];
                }
                else if([type isEqualToString:@"@\"NSInteger\""]) {
                    [object setValue:[NSNumber numberWithInt:[result intForColumn:column]] forKey:column];
                }
                else if([type isEqualToString:@"@\"UIImage\""]
                        || [type isEqualToString:@"@\"NSImage\""]) {
                    NSData *data = [result dataForColumn:column];
                    
#if TARGET_OS_IPHONE
                    [object setValue:[Image imageWithData:data] forKey:column];
#else
                    [object setValue:[[Image alloc] initWithData:data] forKey:column];
#endif
                    
                }
                else if([type isEqualToString:@"@\"NSDate\""]) {
                    NSDate *date = [result dateForColumn:column];
                    [object setValue:date forKey:column];
                }
                else [object setValue:[result dataForColumn:column] forKey:column];
                
                break;
        }
    }
    
    return object;
}
+ (Model *) generateModel:(NSDictionary *) result forClass:(Class) class {
    
    Model * object = [class new];
    NSArray *columns = [Model getFields:class];
    
    for (NSDictionary *field in columns) {
        NSString *column       = [field valueForKey:@"column"];
        NSString *type       = [field valueForKey:@"dataType"];
        
        const char *typeValue = [type UTF8String];
        
        switch (typeValue[0]) {
            case 'i': [object setValue:[NSNumber numberWithInt:[[result objectForKey:column] intValue]] forKey:column]; break;
            case 's': [object setValue:[NSNumber numberWithShort:[[result objectForKey:column] shortValue]] forKey:column]; break;
            case 'l': [object setValue:[NSNumber numberWithLong:[[result objectForKey:column] longValue]] forKey:column]; break;
            case 'q': [object setValue:[NSNumber numberWithLongLong:[[result objectForKey:column] longLongValue]] forKey:column]; break;
            case 'I': [object setValue:[NSNumber numberWithInt:[[result objectForKey:column] integerValue]] forKey:column]; break;
            case 'S': [object setValue:[result objectForKey:column] forKey:column]; break;
            case 'L': [object setValue:[NSNumber numberWithLong:[[result objectForKey:column] longValue]] forKey:column]; break;
            case 'Q': [object setValue:[NSNumber numberWithLong:[[result objectForKey:column] longValue]] forKey:column]; break;
            case 'f': [object setValue:[NSNumber numberWithFloat:[[result objectForKey:column] floatValue]] forKey:column]; break;
            case 'd': [object setValue:[NSNumber numberWithDouble:[[result objectForKey:column] doubleValue]] forKey:column]; break;
            case 'B': [object setValue:[NSNumber numberWithInt:[[result objectForKey:column] boolValue]] forKey:column]; break;
            case 'C': [object setValue:[result objectForKey:column] forKey:column]; break;
            case 'c': [object setValue:[result objectForKey:column] forKey:column]; break;
            default:
                
                if([type isEqualToString:@"@\"NSNumber\""]) {
                    [object setValue:[result objectForKey:column] forKey:column];
                }
                else if([type isEqualToString:@"@\"NSString\""]) {
                    [object setValue:[result objectForKey:column] forKey:column];
                }
                else if([type isEqualToString:@"@\"NSArray\""]) {
                    NSData *data = [result objectForKey:column];
                    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [object setValue:array forKey:column];
                }
                else if([type isEqualToString:@"@\"NSData\""]) {
                    [object setValue:[result objectForKey:column] forKey:column];
                }
                else if([type isEqualToString:@"@\"NSSet\""]) {
                    NSData *data = [result objectForKey:column];
                    NSSet *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [object setValue:array forKey:column];
                }
                else if([type isEqualToString:@"@\"NSURL\""]) {
                    [object setValue:[NSURL URLWithString:[result objectForKey:column]] forKey:column];
                }
                else if([type isEqualToString:@"@\"NSInteger\""]) {
                    [object setValue:[NSNumber numberWithInt:[[result objectForKey:column] intValue]] forKey:column];
                }
                else if([type isEqualToString:@"@\"UIImage\""]
                        || [type isEqualToString:@"@\"NSImage\""]) {
                    NSData *data = [result objectForKey:column];
                    
#if TARGET_OS_IPHONE
                    [object setValue:[Image imageWithData:data] forKey:column];
#else
                    [object setValue:[[Image alloc] initWithData:data] forKey:column];
#endif
                    
                }
                else if([type isEqualToString:@"@\"NSDate\""]) {
                    NSDate *date = [result objectForKey:column];
                    [object setValue:date forKey:column];
                }
                else [object setValue:[result objectForKey:column] forKey:column];
                
                break;
        }
    }
    
    return object;
}

- (NSString *)description {
    NSMutableString * string = [[NSMutableString alloc]init];
    
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
    for (NSUInteger i = 0; i < numberOfProperties; i++) {
        
        objc_property_t property = propertyArray[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        
        [string appendString:[NSString stringWithFormat:@"Property %@ Value: %@\n", name, [self valueForKey:name]]];
    }
    return string;
}

@end
