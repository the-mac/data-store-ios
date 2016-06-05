//
//  OSXTests.m
//  OSXTests
//
//  Created by Christopher Miller on 31/05/16.
//
//

#import <XCTest/XCTest.h>
#import "OSXDataStore.h"
#import "FMDB.h"

@interface Flight : Model
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *delayed;
@property (strong, nonatomic) NSString *departing;
@property (strong, nonatomic) NSString *departingAbbr;
@property (strong, nonatomic) NSString *arriving;
@property (strong, nonatomic) NSString *arrivingAbbr;
@end

@implementation Flight
@end


@interface Reel : Model
@property (nonatomic, strong) NSString * Directors;
@property (nonatomic, strong) NSString * Name;
@property (nonatomic, strong) NSString * ReelPlot;
@end

@implementation Reel
@end

@interface OSXTests : XCTestCase
@property FMDatabaseQueue *queue;
@end

@implementation OSXTests

- (void)setUp {
    [super setUp];
    
    NSArray* tables = @[ [Flight class], [Reel class] ];
    [DataStoreHelper setup:@"ReelExampleDB.sqlite" with:tables];
    
    self.queue = [FMDatabaseQueue databaseQueueWithPath: [DataStoreHelper databasePath]];
}
- (void)tearDown {
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"drop table if exists Flight"];
        [db executeUpdate:@"create table Flight (_id integer primary key autoincrement, name text, arriving text)"];
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Flight"];
        while ([rsl next]) {
            NSLog(@"\n\n%@ = %@\n", @"select * from Flight", [rsl stringForColumnIndex:0]);
            count++;
        }
        
        XCTAssertEqual(count, 0);
    }];
    [super tearDown];
}

- (void)testExample {
    Flight *flight = [[Flight alloc] init];
    flight.name = @"Flight 288";
    flight.arriving = @"Lovemade, CA";
    
    XCTAssert([flight save], @"Did not save successfully!");
}

- (void)testCreate {
    
    NSMutableDictionary *flightData = [@{
          @"name" : @"Flight 888",
          @"arriving" : @"Atlanta, GA"
      } mutableCopy];
    Class classType = [Flight class];
    Flight *flight = (Flight *)[classType create:flightData];
    
    int _id = [flight._id intValue];
    Flight *flight1 = (Flight *)[Flight find:_id];
    
    XCTAssertEqual(flight.name, @"Flight 888", @"Did not create successfully!");
    XCTAssertEqual(flight.name, flightData[@"name"], @"Did not create successfully!");
    XCTAssertEqual(flight.arriving, @"Atlanta, GA");
    
    XCTAssertEqualObjects(flight.name, flight1.name);
    XCTAssertEqualObjects(flight.arriving, flight1.arriving);
}

@end
