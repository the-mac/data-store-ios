//
//  DataStoreAdvancedTests.m
//  DataStoreAdvancedTests
//
//  Created by Christopher Miller on 05/24/2016.
//  Copyright (c) 2016 Christopher Miller. All rights reserved.
//
//
//  DataStoreTests.m
//  DataStoreTests
//
//  Created by Christopher Miller on 05/19/2016.
//  Copyright (c) 2016 Christopher Miller. All rights reserved.
//

@import XCTest;
@import FMDB;
@import DataStoreAdvanced;

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
    reel.reel_id = @"tt0110912";
    
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
- (void)testBlackBoxReelUpdate {
    
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
    reel.reel_id = @"tt0110912";
    
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
    
    __block NSString *status = @"16.05.22.03.02";
    [Reel update:[@{ @"WatchedGood" : status } mutableCopy]];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Reel"];
        NSString *result = nil;
        
        while ([rsl next]) {
            result = [rsl stringForColumnIndex:[rsl columnIndexForName:@"WatchedGood"]];
            NSLog(@"\n\n%@ = %@\n", @"select * from Reel", result);
            NSLog(@"%@", [[rsl resultDict] description]);
            count++;
        }
        
        XCTAssertEqual(count, 1);
        XCTAssertEqualObjects(result, status);
    }];
}
- (void)testBlackBoxReelWhereUpdate {
    
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
    
    
    Reel *reel1 = [[Reel alloc] init];
    reel1.Name = @"Pulp Fiction";
    reel1.reel_id = @"tt0110912";
    reel1.ReelPlot = @"The lives of two mob hit men, a boxer, a gangster's wife, and a pair of diner bandits intertwine in four tales of violence and redemption.";
    reel1.WatchedGood = @"16.05.22.03.02";
    
    [reel1 save];
    
    Reel *reel2 = [[Reel alloc] init];
    reel2.Name = @"Django Unchained";
    reel2.reel_id = @"tt1853728";
    reel1.ReelPlot = @"With the help of a German bounty hunter, a freed slave sets out to rescue his wife from a brutal Mississippi plantation owner.";
    reel2.WatchedGood = @"16.05.22.03.02";
    
    [reel2 save];
    
    Reel *reel3 = [[Reel alloc] init];
    reel3.Name = @"Inglourious Basterds";
    reel3.reel_id = @"tt1853728";
    reel3.ReelPlot = @"In Nazi-occupied France during World War II, a plan to assassinate Nazi leaders by a group of Jewish U.S. soldiers coincides with a theatre owner's vengeful plans for the same.";
    reel3.WatchedGood = @"16.05.22.03.02";
    
    [reel3 save];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Reel"];
        while ([rsl next]) {
            NSLog(@"%@\n\n%@", @"select * from Reel", [[rsl resultDict] description]);
            count++;
        }
        
        XCTAssertEqual(count, 3);
    }];
    
    NSNull *null = [NSNull null];
    [[Reel where:@"Name" is:@"Pulp Fiction"]
     update:[@{ @"WatchedGood" : null, @"WatchedBad" : null, @"WatchLater" : null, @"NotSure" : null } mutableCopy]];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Reel"];
        while ([rsl next]) {
            NSLog(@"%@\n\n%@", @"select * from Reel", [[rsl resultDict] description]);
            count++;
        }
        
        XCTAssertEqual(count, 3);
        
        count = 0;
        
        rsl = [db executeQuery:@"select * from Reel where WatchedGood IS NULL"];
        
        while ([rsl next]) {
            NSLog(@"\n\n%@ \n%@\n", @"select * from Reel", [[rsl resultDict] description]);
            count++;
        }
        
        XCTAssertEqual(count, 1);
    }];
    
    [[Reel where:@"Name" is:@"Pulp Fiction"] remove];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Reel"];
        while ([rsl next]) {
            NSLog(@"%@\n\n%@", @"select * from Reel", [[rsl resultDict] description]);
            count++;
        }
        
        XCTAssertEqual(count, 2);
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
        
        
        NSString *name = nil;
        NSString *destination = nil;
        
        int count = 0;
        NSString *query = @"SELECT * FROM Flight";
        FMResultSet *rsl = [db executeQuery:query];
        while ([rsl next]) {
            name = [rsl stringForColumnIndex:1];
            destination = [rsl stringForColumnIndex:2];
            NSLog(@"\n\n%@ = (name = %@, destination = %@)\n", query, name, destination);
            count++;
            
        }
        
        XCTAssertEqual(count, 1);
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
    XCTAssertEqualObjects(flight.name, @"Flight 288");
    XCTAssertEqualObjects(flight.destination, @"Lovemade, CA");
    
    flight2 = all[1];
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

