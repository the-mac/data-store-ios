//
//  DataStoreTests.m
//  DataStoreTests
//
//  Created by Christopher Miller on 05/19/2016.
//  Copyright (c) 2016 Christopher Miller. All rights reserved.
//

@import XCTest;
@import FMDB;
@import DataStore;

@interface Flight : Model
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *destination;
@end

@implementation Flight
@end


@interface Reel : Model
@property (nonatomic, strong) NSString * Certificate;
@property (nonatomic, strong) NSString * Directors;
@property (nonatomic, strong) NSString * Name;
@property (nonatomic, strong) NSString * NotSure;
@property (nonatomic, strong) NSString * reel_id;
@property (nonatomic, strong) NSString * ReelPlot;
@property (nonatomic, strong) NSString * ReelRating;
@property (nonatomic, strong) NSString * RunTime;
@property (nonatomic, strong) NSString * SubGenre;
@property (nonatomic, strong) NSString * Trailer;
@property (nonatomic, strong) NSString * WatchedBad;
@property (nonatomic, strong) NSString * WatchedGood;
@property (nonatomic, strong) NSString * WatchLater;
@property (nonatomic, strong) NSString * Year;
@end

@implementation Reel
@end



@interface Tests : XCTestCase
@property FMDatabaseQueue *queue;
@end

@implementation Tests

- (void)setUp {
    [super setUp];
    self.queue = [FMDatabaseQueue databaseQueueWithPath: [DataStoreHelper databasePath]];
}
- (void)tearDown {
    [super tearDown];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

- (void)testNSStringRepeat {
    NSString *abcs = [@"" stringByPaddingToLength:9 withString: @"abc" startingAtIndex:0];
    XCTAssertEqualObjects(@"abcabcabc", abcs);
    
    NSString *param = @", ?";
    NSString *params = [@"?" stringByPaddingToLength:3 * param.length + 1 withString:param startingAtIndex:0];
    XCTAssertEqualObjects(@"?, ?, ?, ?", params);
    
}

- (void)testWhiteBoxFlightSave {
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"drop table if exists Flight"];
        [db executeUpdate:@"create table Flight (_id integer primary key autoincrement, name text, destination text)"];
        
        [db executeUpdate:@"insert into Flight(name, destination) values ('Flight 144', 'Lovemade, CA')"];
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Flight"];
        while ([rsl next]) {
            NSLog(@"\n\n%@ = %@\n", @"select * from Flight", [rsl stringForColumnIndex:0]);
            count++;
        }
        
        XCTAssertEqual(count, 1);
        
        rsl = [db executeQuery:@"select * from Flight where name = ''"];
        XCTAssertFalse([rsl hasAnotherRow]);
        
    }];
}
- (void)testBlackBoxFlightSave {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"drop table if exists Flight"];
        [db executeUpdate:@"create table Flight (_id integer primary key autoincrement, name text, destination text)"];
        
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Flight"];
        while ([rsl next]) {
            NSLog(@"\n\n%@ = %@\n", @"select * from Flight", [rsl stringForColumnIndex:0]);
            count++;
        }
        
        XCTAssertEqual(count, 0);
    }];
    
    
    Flight *flight = [[Flight alloc] init];
    flight.name = @"Flight 288";
    flight.destination = @"Lovemade, CA";
    
    [flight save];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Flight"];
        while ([rsl next]) {
            NSLog(@"\n\n%@ = %@\n", @"select * from Flight", [rsl stringForColumnIndex:0]);
            count++;
        }
        
        XCTAssertEqual(count, 1);
    }];
    
    flight.destination = @"Veryfine, IL";
    
    [flight save];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Flight"];
        while ([rsl next]) {
            NSLog(@"\n\n%@ = %@\n", @"select * from Flight", [rsl stringForColumnIndex:0]);
            count++;
        }
        
        XCTAssertEqual(count, 1);
    }];
}

- (void)testBlackBoxReelSave {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"drop table if exists Reel"];
        
        NSArray *fields = [DataStoreHelper getFields:[Reel class]];
        [db executeUpdate:[NSString stringWithFormat:@"create table Reel (%@)", [DataStoreHelper generateColumns:fields]]];
        
        
        int count = 0;
        NSString *query = @"select * from Reel";
        FMResultSet *rsl = [db executeQuery:query];
        while ([rsl next]) {
            NSLog(@"\n\n%@ = %@\n", query, [rsl stringForColumnIndex:0]);
            count++;
        }
        
        XCTAssertEqual(count, 0);
    }];
    
    
    Reel *reel = [[Reel alloc] init];
    reel.Name = @"Pulp Fiction";
    reel.reel_id = @"0110912";
    
    [reel save];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Reel"];
        while ([rsl next]) {
            NSLog(@"\n\n%@ = %@\n", @"select * from Reel", [rsl stringForColumnIndex:0]);
            count++;
        }
        
        XCTAssertEqual(count, 1);
    }];
    
    reel.WatchedGood = @"16.05.22.03.02";
    
    [reel save];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Reel"];
        while ([rsl next]) {
            NSLog(@"\n\n%@ = %@\n", @"select * from Reel", [rsl stringForColumnIndex:0]);
            count++;
        }
        
        XCTAssertEqual(count, 1);
    }];
}

- (void)testWhiteBoxCount {
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"drop table if exists Flight"];
        [db executeUpdate:@"create table Flight (name text, destination text)"];
        
        [db executeUpdate:@"insert into Flight values ('Flight 144', 'Lovemade, CA')"];
        
        int count = -1;
        NSString *query = @"SELECT COUNT(*) FROM Flight";
        FMResultSet *rsl = [db executeQuery:query];
        while ([rsl next]) {
            count = [rsl intForColumnIndex:0];
            NSLog(@"\n\n%@ = %d\n", query, count);
        }
        
        XCTAssertEqual(count, 1);
    }];
}
- (void)testBlackBoxCount {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"drop table if exists Flight"];
        [db executeUpdate:@"create table Flight (name text, destination text)"];
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Flight"];
        while ([rsl next]) {
            NSLog(@"\n\n%@ = %@\n", @"select * from Flight", [rsl stringForColumnIndex:0]);
            count++;
        }
        
        XCTAssertEqual(count, 0);
    }];
    
    Flight *flight = [[Flight alloc] init];
    flight.name = @"Flight 288";
    flight.destination = @"Lovemade, CA";
    
    [flight save];
    
    int count = [Flight count];
    XCTAssertEqual(count, 1);
    
    
    Flight *flight2 = [[Flight alloc] init];
    flight2.name = @"Flight 144";
    flight2.destination = @"Lovemade, CA";
    
    [flight2 save];
    
    int recount = [Flight count];
    XCTAssertEqual(recount, 2);
    
}

- (void)testWhiteBoxAll {
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"drop table if exists Flight"];
        [db executeUpdate:@"create table Flight (_id integer primary key autoincrement, name text, destination text)"];
        
        Flight *flight = [[Flight alloc] init];
        flight.name = @"Flight 288";
        flight.destination = @"Lovemade, CA";
        
        [flight save];
        
        
        NSNumber *_id = nil;
        NSString *name = nil;
        NSString *destination = nil;
        
        int count = 0;
        NSString *query = @"SELECT * FROM Flight";
        FMResultSet *rsl = [db executeQuery:query];
        while ([rsl next]) {
            _id = (NSNumber*)[rsl objectForColumnIndex:0];
            name = [rsl stringForColumnIndex:1];
            destination = [rsl stringForColumnIndex:2];
            NSLog(@"\n\n%@ = (name = %@, destination = %@)\n", query, name, destination);
            count++;
            
        }
        
        XCTAssertEqual(count, 1);
        XCTAssertEqualObjects(_id, @1);
        XCTAssertEqualObjects(name, @"Flight 288");
        XCTAssertEqualObjects(destination, @"Lovemade, CA");
    }];
}
- (void)testBlackBoxAll {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"drop table if exists Flight"];
        [db executeUpdate:@"create table Flight (_id integer primary key autoincrement, name text, destination text)"];
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Flight"];
        while ([rsl next]) {
            NSLog(@"\n\n%@ = %@\n", @"select * from Flight", [rsl stringForColumnIndex:0]);
            count++;
        }
        
        XCTAssertEqual(count, 0);
    }];
    
    Flight *flight = [[Flight alloc] init];
    flight.name = @"Flight 288";
    flight.destination = @"Lovemade, CA";
    
    [flight save];
    
    int count = [Flight count];
    XCTAssertEqual(count, 1);
    
    
    Flight *flight2 = [[Flight alloc] init];
    flight2.name = @"Flight 144";
    flight2.destination = @"Lovemade, CA";
    
    [flight2 save];
    
    
    NSArray * all = [Flight all];
    
    int recount = (int) all.count;
    XCTAssertEqual(recount, 2);
    
    flight = all[0];
    XCTAssertEqualObjects(flight._id, @1);
    XCTAssertEqualObjects(flight.name, @"Flight 288");
    XCTAssertEqualObjects(flight.destination, @"Lovemade, CA");
    
    flight2 = all[1];
    XCTAssertEqualObjects(flight2._id, @2);
    XCTAssertEqualObjects(flight2.name, @"Flight 144");
    XCTAssertEqualObjects(flight2.destination, @"Lovemade, CA");
}

- (void)testBlackBoxFind {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"drop table if exists Flight"];
        [db executeUpdate:@"create table Flight (_id integer primary key autoincrement, name text, destination text)"];
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Flight"];
        while ([rsl next]) {
            NSLog(@"\n\n%@ = %@\n", @"select * from Flight", [rsl stringForColumnIndex:0]);
            count++;
        }
        
        XCTAssertEqual(count, 0);
    }];
    
    
    Flight *flight1 = [[Flight alloc] init];
    flight1.name = @"Flight 288";
    flight1.destination = @"Lovemade, CA";
    
    [flight1 save];
    
    
    Flight *flight2 = [[Flight alloc] init];
    flight2.name = @"Flight 144";
    flight2.destination = @"Lovemade, CA";
    
    [flight2 save];
    
    
    Flight *flight = (Flight *)[Flight find:1];
    NSArray * all = [Flight all];
    flight1 = all[0];
    
    int recount = (int) all.count;
    XCTAssertEqual(recount, 2);
    
    XCTAssertEqualObjects(flight.name, @"Flight 288");
    XCTAssertEqualObjects(flight.destination, @"Lovemade, CA");
    
    XCTAssertEqualObjects(flight.name, flight1.name);
    XCTAssertEqualObjects(flight.destination, flight1.destination);
}

@end

