//
//  DataStoreAdvancedTests.m
//  DataStoreAdvancedTests
//
//  Created by Christopher Miller on 05/24/2016.
//  Copyright (c) 2016 Christopher Miller. All rights reserved.
//

@import XCTest;
@import FMDB;
@import DataStoreAdvanced;

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
        [db executeUpdate:@"create table Flight (_id integer primary key autoincrement, name text, arriving text)"];
        
        [db executeUpdate:@"insert into Flight(name, arriving) values ('Flight 144', 'Lovemade, CA')"];
        
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
        [db executeUpdate:@"create table Flight (_id integer primary key autoincrement, name text, arriving text)"];
        
        
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
    flight.arriving = @"Lovemade, CA";
    
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
    
    flight.arriving = @"Veryfine, IL";
    
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
    reel.Directors = @"Quentin Tarantino";
    
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
    
    reel.Name = @"Pulp Fiction, The Sequel to Resevoir Dogs";
    
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
    reel.Directors = @"Quentin Tarantino";
    
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
    
    __block NSString *update = @"Pulp Fiction, The Sequel to Resevoir Dogs";
    [Reel update:[@{ @"Name" : update } mutableCopy]];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Reel"];
        NSString *result = nil;
        
        while ([rsl next]) {
            result = [rsl stringForColumnIndex:[rsl columnIndexForName:@"Name"]];
            NSLog(@"\n\n%@ = %@\n", @"select * from Reel", result);
            NSLog(@"%@", [[rsl resultDict] description]);
            count++;
        }
        
        XCTAssertEqual(count, 1);
        XCTAssertEqualObjects(result, update);
    }];
}
- (void)testWhiteBoxReelWhereClauses {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"drop table if exists Reel"];
        
        NSArray *fields = [DataStoreHelper getFields:[Reel class]];
        [db executeUpdate:[NSString stringWithFormat:@"create table Reel (%@)", [DataStoreHelper generateColumns:fields]]];
        
        
        Reel *reel1 = [[Reel alloc] init];
        reel1.Name = @"Pulp Fiction";
        reel1.ReelPlot = @"The lives of two mob hit men, a boxer, a gangster's wife, and a pair of diner bandits intertwine in four tales of violence and redemption.";
        reel1.Directors = @"Quentin Tarantino";
        
        [reel1 save];
        
        Reel *reel2 = [[Reel alloc] init];
        reel2.Name = @"Django Unchained";
        reel1.ReelPlot = @"With the help of a German bounty hunter, a freed slave sets out to rescue his wife from a brutal Mississippi plantation owner.";
        reel2.Directors = @"Quentin Tarantino";
        
        [reel2 save];
        
        Reel *reel3 = [[Reel alloc] init];
        reel3.Name = @"Inglourious Basterds";
        reel3.ReelPlot = @"In Nazi-occupied France during World War II, a plan to assassinate Nazi leaders by a group of Jewish U.S. soldiers coincides with a theatre owner's vengeful plans for the same.";
        reel3.Directors = @"Quentin Tarantino";
        
        [reel3 save];
        
        int count = 0;
        NSString *query = @"select * from Reel";
        FMResultSet *rsl = [db executeQuery:query];
        while ([rsl next]) {
            NSLog(@"\n\n%@ = %@\n", query, [rsl stringForColumnIndex:0]);
            count++;
        }
        
        XCTAssertEqual(count, 3);
        
        count = 0;
        query = @"select * from Reel where Name = 'Inglourious Basterds' or ReelPlot = 'Inglourious Basterds' or Directors = 'Inglourious Basterds'";
        rsl = [db executeQuery:query];
        while ([rsl next]) {
            NSLog(@"\n\n%@ = %@\n", query, [rsl stringForColumnIndex:0]);
            NSLog(@"%@\n\n%@", @"select * from Reel", [[rsl resultDict] description]);
            count++;
        }
        XCTAssertEqual(count, 1);
        
        count = 0;
        query = @"select * from Reel where Name like '%Inglourious%'";
        rsl = [db executeQuery:query];
        while ([rsl next]) {
            NSLog(@"\n\n%@ = %@\n", query, [rsl stringForColumnIndex:0]);
            NSLog(@"%@\n\n%@", @"select * from Reel", [[rsl resultDict] description]);
            count++;
        }
        XCTAssertEqual(count, 1);
    }];
}
- (void)testBlackBoxReelWhereClauses {
    
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
    reel1.ReelPlot = @"The lives of two mob hit men, a boxer, a gangster's wife, and a pair of diner bandits intertwine in four tales of violence and redemption.";
    reel1.Directors = @"Quentin Tarantino";
    
    [reel1 save];
    
    Reel *reel2 = [[Reel alloc] init];
    reel2.Name = @"Django Unchained";
    reel1.ReelPlot = @"With the help of a German bounty hunter, a freed slave sets out to rescue his wife from a brutal Mississippi plantation owner.";
    reel2.Directors = @"Quentin Tarantino";
    
    [reel2 save];
    
    Reel *reel3 = [[Reel alloc] init];
    reel3.Name = @"Inglourious Basterds";
    reel3.ReelPlot = @"In Nazi-occupied France during World War II, a plan to assassinate Nazi leaders by a group of Jewish U.S. soldiers coincides with a theatre owner's vengeful plans for the same.";
    reel3.Directors = @"Quentin Tarantino";
    
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
    
    
    NSString * reelName = @"Inglourious Basterds";
    NSArray *searchResults = [[[[Reel where:@"Name" is:reelName]
                                orWhere:@"ReelPlot" is:reelName] orWhere:@"Directors" is:reelName] get];
    
    XCTAssertEqual(searchResults.count, 1);
    
    
    NSString * reelShortName = @"%Inglourious%";
    NSArray *searchShortResults = [[[[Reel where:@"Name" is:reelShortName]
                                     orWhere:@"ReelPlot" is:reelShortName] orWhere:@"Directors" is:reelShortName] get];
    
    XCTAssertEqual(searchShortResults.count, 1);
    
}

- (void)testBlackBoxFlightWhereClauses {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"drop table if exists Flight"];
        
        NSArray *fields = [DataStoreHelper getFields:[Flight class]];
        [db executeUpdate:[NSString stringWithFormat:@"create table Flight (%@)", [DataStoreHelper generateColumns:fields]]];
        
        
        
        int count = 0;
        NSString *query = @"select * from Flight";
        FMResultSet *rsl = [db executeQuery:query];
        while ([rsl next]) {
            NSLog(@"\n\n%@ = %@\n", query, [rsl stringForColumnIndex:0]);
            count++;
        }
        
        XCTAssertEqual(count, 0);
    }];
    
    
    Flight *flight1 = [[Flight alloc] init];
    flight1.name = @"Flight 1137";
    flight1.departing = @"Los Angeles, CA";
    flight1.departingAbbr = @"LAX";
    flight1.arriving = @"Atlanta, GA";
    flight1.arrivingAbbr = @"AHJ";
    
    [flight1 save];
    
    Flight *flight2 = [[Flight alloc] init];
    flight2.name = @"Flight 835";
    flight2.departing = @"Atlanta, GA";
    flight2.departingAbbr = @"AHJ";
    flight2.arriving = @"Newark, NJ";
    flight2.arrivingAbbr = @"EWR";
    
    [flight2 save];
    
    Flight *flight3 = [[Flight alloc] init];
    flight3.name = @"Flight 845";
    flight3.departing = @"Newark, NJ";
    flight3.departingAbbr = @"EWR";
    flight3.arriving = @"Atlanta, GA";
    flight3.arrivingAbbr = @"AHJ";
    
    [flight3 save];
    
    flight1 = [[Flight alloc] init];
    flight1.name = @"Flight 1137";
    flight1.departing = @"Los Angeles, CA";
    flight1.departingAbbr = @"LAX";
    flight1.arriving = @"Atlanta, GA";
    flight1.arrivingAbbr = @"AHJ";
    
    [flight1 save];
    
    flight2 = [[Flight alloc] init];
    flight2.name = @"Flight 835";
    flight2.departing = @"Atlanta, GA";
    flight2.departingAbbr = @"AHJ";
    flight2.arriving = @"Newark, NJ";
    flight2.arrivingAbbr = @"EWR";
    
    [flight2 save];
    
    flight3 = [[Flight alloc] init];
    flight3.name = @"Flight 845";
    flight3.departing = @"Newark, NJ";
    flight3.departingAbbr = @"EWR";
    flight3.arriving = @"Atlanta, GA";
    flight3.arrivingAbbr = @"AHJ";
    
    [flight3 save];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Flight"];
        while ([rsl next]) {
            NSLog(@"%@\n\n%@", @"select * from Flight", [[rsl resultDict] description]);
            count++;
        }
        
        XCTAssertEqual(count, 6);
    }];
    
    [[Flight where:@"name" is:@"%%1137%%"]
     update:[@{ @"delayed" : @1 } mutableCopy]];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Flight"];
        while ([rsl next]) {
            NSLog(@"%@\n\n%@", @"select * from Flight", [[rsl resultDict] description]);
            count++;
        }
        
        XCTAssertEqual(count, 6);
        
        count = 0;
        
        rsl = [db executeQuery:@"select * from Flight where delayed IS '1'"];
        
        while ([rsl next]) {
            NSLog(@"\n\n%@ \n%@\n", @"select * from Flight", [[rsl resultDict] description]);
            count++;
        }
        
        XCTAssertEqual(count, 2);
    }];
    
    [[Flight where:@"name" is:@"Flight 835"] remove];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        int count = 0;
        FMResultSet *rsl = [db executeQuery:@"select * from Flight"];
        while ([rsl next]) {
            NSLog(@"%@\n\n%@", @"select * from Flight", [[rsl resultDict] description]);
            count++;
        }
        
        XCTAssertEqual(count, 4);
    }];
    
    
    NSString * flightName = @"Flight 1137";
    NSArray *searchResults = [[[[Flight where:@"name" is:flightName]
                                orWhere:@"departing" is:flightName] orWhere:@"arriving" is:flightName] get];
    
    XCTAssertEqual(searchResults.count, 2);
    
    
    flightName = @"84";
    NSString * flightSearch = [NSString stringWithFormat:@"%%%@%%", flightName];
    NSArray *searchShortResults = [[[[Flight where:@"name" is:flightSearch]
                                     orWhere:@"departing" is:flightSearch] orWhere:@"arriving" is:flightSearch] get];
    
    NSLog(@"\n\nsearchShortResults: %@", [searchShortResults[0] description]);
    XCTAssertEqual(searchShortResults.count, 2);
    
    
    NSArray *insideResults = [[Flight where:@"name" inside: @[@"Flight 1137", @"Flight 843", @"Flight 845"]] get];
    
    NSLog(@"\n\nsearchShortResults: %@", [insideResults[0] description]);
    XCTAssertEqual(insideResults.count, 4);
}

- (void)testWhiteBoxCount {
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"drop table if exists Flight"];
        [db executeUpdate:@"create table Flight (name text, arriving text)"];
        
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
        [db executeUpdate:@"create table Flight (name text, arriving text)"];
        
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
    flight.arriving = @"Lovemade, CA";
    
    [flight save];
    
    int count = [Flight count];
    XCTAssertEqual(count, 1);
    
    
    Flight *flight2 = [[Flight alloc] init];
    flight2.name = @"Flight 144";
    flight2.arriving = @"Lovemade, CA";
    
    [flight2 save];
    
    int recount = [Flight count];
    XCTAssertEqual(recount, 2);
    
}

- (void)testWhiteBoxAll {
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"drop table if exists Flight"];
        [db executeUpdate:@"create table Flight (_id integer primary key autoincrement, name text, arriving text)"];
        
        Flight *flight = [[Flight alloc] init];
        flight.name = @"Flight 288";
        flight.arriving = @"Lovemade, CA";
        
        [flight save];
        
        
        NSNumber *_id = nil;
        NSString *name = nil;
        NSString *arriving = nil;
        
        int count = 0;
        NSString *query = @"SELECT * FROM Flight";
        FMResultSet *rsl = [db executeQuery:query];
        while ([rsl next]) {
            _id = (NSNumber*)[rsl objectForColumnIndex:0];
            name = [rsl stringForColumnIndex:1];
            arriving = [rsl stringForColumnIndex:2];
            NSLog(@"\n\n%@ = (name = %@, arriving = %@)\n", query, name, arriving);
            count++;
            
        }
        
        XCTAssertEqual(count, 1);
        XCTAssertEqualObjects(_id, @1);
        XCTAssertEqualObjects(name, @"Flight 288");
        XCTAssertEqualObjects(arriving, @"Lovemade, CA");
    }];
}
- (void)testBlackBoxAll {
    
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
    
    Flight *flight = [[Flight alloc] init];
    flight.name = @"Flight 288";
    flight.arriving = @"Lovemade, CA";
    
    [flight save];
    
    int count = [Flight count];
    XCTAssertEqual(count, 1);
    
    
    Flight *flight2 = [[Flight alloc] init];
    flight2.name = @"Flight 144";
    flight2.arriving = @"Lovemade, CA";
    
    [flight2 save];
    
    
    NSArray * all = [Flight all];
    
    int recount = (int) all.count;
    XCTAssertEqual(recount, 2);
    
    flight = all[0];
    XCTAssertEqualObjects(flight._id, @1);
    XCTAssertEqualObjects(flight.name, @"Flight 288");
    XCTAssertEqualObjects(flight.arriving, @"Lovemade, CA");
    
    flight2 = all[1];
    XCTAssertEqualObjects(flight2._id, @2);
    XCTAssertEqualObjects(flight2.name, @"Flight 144");
    XCTAssertEqualObjects(flight2.arriving, @"Lovemade, CA");
}

- (void)testBlackBoxFind {
    
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
    
    
    Flight *flight1 = [[Flight alloc] init];
    flight1.name = @"Flight 288";
    flight1.arriving = @"Lovemade, CA";
    
    [flight1 save];
    
    
    Flight *flight2 = [[Flight alloc] init];
    flight2.name = @"Flight 144";
    flight2.arriving = @"Lovemade, CA";
    
    [flight2 save];
    
    
    Flight *flight = (Flight *)[Flight find:1];
    NSArray * all = [Flight all];
    flight1 = all[0];
    
    int recount = (int) all.count;
    XCTAssertEqual(recount, 2);
    
    XCTAssertEqualObjects(flight.name, @"Flight 288");
    XCTAssertEqualObjects(flight.arriving, @"Lovemade, CA");
    
    XCTAssertEqualObjects(flight.name, flight1.name);
    XCTAssertEqualObjects(flight.arriving, flight1.arriving);
}

@end

