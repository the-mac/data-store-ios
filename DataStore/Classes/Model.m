//
//  Storage.m
//  Store
//
//  Created by Christopher Miller on 18/05/16.
//  Copyright © 2016 Operators. All rights reserved.
//

#import "FMDB.h"
#import "DataStore.h"
#import <objc/runtime.h>

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

-(id)init {
    self = [super init];
    if(self) {
        self._id = [NSNumber numberWithInt:-111];
    }
    return self;
}
- (BOOL) save {
    NSLog(@"called %s", __FUNCTION__);
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DataStoreHelper databasePath]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *table = NSStringFromClass([self class]);
        
        NSString *query = nil;
        
        if(![self._id isEqual:[NSNumber numberWithInt:-111]]) {

            NSString *params = [Model getParams: self];
            query = [NSString stringWithFormat:@"update %@ set %@ where _id='%@'", table, params, self._id];
            NSLog(@"query =%@", query);

            [queryString appendString:query];
            [db executeUpdate:queryString];
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
            [db executeUpdate:queryString withArgumentsInArray:values];
        }
    }];
    
    [Model clearQuery];
    return YES;
}

+ (Model *) find:(int)identifier {
    
    __block int _id = identifier;
    __block Model *model = nil;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DataStoreHelper databasePath]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *table = NSStringFromClass([self class]);
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
        
        NSString *table = NSStringFromClass([self class]);
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
        
        NSString *table = NSStringFromClass([self class]);
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
        NSString *table = NSStringFromClass([self class]);
        [queryString appendString:[NSString stringWithFormat:@"delete from %@ where _id='%@'", table, self._id]];
        [db executeUpdate:queryString];
    }];
    
    [Model clearQuery];
    return YES;
}
+ (BOOL) truncate {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[DataStoreHelper databasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *table = NSStringFromClass([self class]);
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
                else if([type isEqualToString:@"@\"UIImage\""]) {
                    NSData *data = [result dataForColumn:column];
                    [object setValue:[UIImage imageWithData:data] forKey:column];
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
