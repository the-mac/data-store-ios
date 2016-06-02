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
    [super tearDown];
}

- (void)testExample {
    Flight *flight = [[Flight alloc] init];
    flight.name = @"Flight 288";
    flight.arriving = @"Lovemade, CA";
    
    XCTAssert([flight save], @"Did not save successfully!");
}

@end
