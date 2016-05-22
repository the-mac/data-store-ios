//
//  Flight.h
//  DataStore
//
//  Created by Christopher Miller on 20/05/16.
//  Copyright © 2016 Christopher Miller. All rights reserved.
//

#import <DataStore/Model.h>

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