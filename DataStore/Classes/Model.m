//
//  Storage.m
//  Store
//
//  Created by Christopher Miller on 18/05/16.
//  Copyright © 2016 Operators. All rights reserved.
//

#import "FMDB.h"
#import "Model.h"
#import "DataStore.h"
#import <objc/runtime.h>

static NSMutableString * queryString = nil;

@implementation Model
+ (void) initialize {
    queryString = [@"" mutableCopy];
}
+ (NSArray *) all {
    
    NSMutableArray *allResults = [[NSMutableArray alloc] init];
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:[DataStore databasePath]];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *query = [NSString stringWithFormat:@"select * from %@", NSStringFromClass([self class])];
        FMResultSet *results = [db executeQuery:query];
        
        while([results next])
        {
            NSObject * object = [self generateNSObject:results forClass:[self class]];
            [allResults addObject:object];
        }
    }];
    
    
    return @[];
}
+ (int) count {
    return 0;
}
+ (BOOL) truncate {
    return YES;
}
- (BOOL) save {
    return YES;
}

+ (NSMutableArray *) getFields:(Class) class
{
    NSMutableArray * fields = [@[] mutableCopy];
    
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
    for (NSUInteger i = 0; i < numberOfProperties; i++) {
        
        objc_property_t property = propertyArray[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        [fields addObject:name];
    }
    return fields;
}


+ (NSObject *) generateNSObject:(FMResultSet *) result forClass:(Class) class {
    
    NSObject * object = [class new];
    NSArray *columns = [Model getFields:class];
    
//    NSDictionary * dictionary = [object getObjDictionary];
    
    NSArray  *ignoredList   = [class performSelector:@selector(ignoredProperties)];
    
    for(int i=0; i < [columns count]; i++)
    {
        NSDictionary *keyval    = (NSDictionary *) columns[i];
        NSString *colName       = [keyval valueForKey:@"column"];
        NSString *typeValue       = [keyval valueForKey:@"type"];
        
        if([ignoredList containsObject:colName]) continue;
        
        const char *type = [typeValue UTF8String];
        
        switch (type[0])
        {
            case 'i':
                [object setValue:[NSNumber numberWithInt:[result intForColumn:colName]] forKey:colName];
                //            NSLog(@"int");
                break;
            case 's':
                [object setValue:[NSNumber numberWithShort:[result intForColumn:colName]] forKey:colName];
                //            NSLog(@"short");
                break;
            case 'l':
                [object setValue:[NSNumber numberWithLong:[result longForColumn:colName]] forKey:colName];
                //            NSLog(@"long");
                break;
            case 'q':
                [object setValue:[NSNumber numberWithLongLong:[result longLongIntForColumn:colName]] forKey:colName];
                //            NSLog(@"long long");
                break;
            case 'C':
                [object setValue:[result stringForColumn:colName] forKey:colName];
                //            NSLog(@"char");
                break;
            case 'c':
                [object setValue:[result stringForColumn:colName] forKey:colName];
                //            NSLog(@"char");
                break;
            case 'I':
                [object setValue:[NSNumber numberWithInt:[result intForColumn:colName]] forKey:colName];
                //            NSLog(@"int");
                break;
            case 'S':
                [object setValue:[result stringForColumn:colName] forKey:colName];
                //            NSLog(@"short");
                break;
            case 'L':
                [object setValue:[NSNumber numberWithLong:[result longForColumn:colName]] forKey:colName];
                //            NSLog(@"long");
                break;
            case 'Q':
                [object setValue:[NSNumber numberWithLong:[result longForColumn:colName]] forKey:colName];
                //            NSLog(@"long");
                break;
            case 'f':
                [object setValue:[NSNumber numberWithFloat:[result doubleForColumn:colName]] forKey:colName];
                //            NSLog(@"float");
                break;
            case 'd':
                [object setValue:[NSNumber numberWithDouble:[result doubleForColumn:colName]] forKey:colName];
                //            NSLog(@"double");
                break;
            case 'B':
                [object setValue:[NSNumber numberWithInt:[result intForColumn:colName]] forKey:colName];
                //            NSLog(@"bool");
                break;
            default:
                
                if([typeValue isEqualToString:@"@\"NSNumber\""]) {
                    [object setValue:[result objectForColumnName:colName] forKey:colName];
                }
                else if([typeValue isEqualToString:@"@\"NSString\""]) {
                    [object setValue:[result stringForColumn:colName] forKey:colName];
                }
                else if([typeValue isEqualToString:@"@\"NSArray\""]) {
                    NSData *data = [result dataForColumn:colName];
                    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [object setValue:array forKey:colName];
                }
                else if([typeValue isEqualToString:@"@\"NSData\""]) {
                    [object setValue:[result dataForColumn:colName] forKey:colName];
                }
                else if([typeValue isEqualToString:@"@\"NSSet\""]) {
                    NSData *data = [result dataForColumn:colName];
                    NSSet *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [object setValue:array forKey:colName];
                }
                else if([typeValue isEqualToString:@"@\"NSURL\""]) {
                    [object setValue:[NSURL URLWithString:[result stringForColumn:colName]] forKey:colName];
                }
                else if([typeValue isEqualToString:@"@\"NSInteger\""]) {
                    [object setValue:[NSNumber numberWithInt:[result intForColumn:colName]] forKey:colName];
                }
                else if([typeValue isEqualToString:@"@\"UIImage\""]) {
                    NSData *data = [result dataForColumn:colName];
                    [object setValue:[UIImage imageWithData:data] forKey:colName];
                }
                else if([typeValue isEqualToString:@"@\"NSDate\""]) {
                    NSDate *date = [result dateForColumn:colName];
                    [object setValue:date forKey:colName];
                }
                else {
                    [object setValue:[result dataForColumn:colName] forKey:colName];
                }
                
                break;
        }
        
    }
    
//    [object setObjDictionary:dictionary];
    
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
