//
//  Flight.h
//  DataStore
//
//  Created by Christopher Miller on 20/05/16.
//  Copyright © 2016 Christopher Miller. All rights reserved.
//

#import <iOSDataStore/iOSDataStore.h>

@interface Flight : Model
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *delayed;
@property (strong, nonatomic) NSString *departing;
@property (strong, nonatomic) NSString *departingAbbr;
@property (strong, nonatomic) NSString *arriving;
@property (strong, nonatomic) NSString *arrivingAbbr;
@end
