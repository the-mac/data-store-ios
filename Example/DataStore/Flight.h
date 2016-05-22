//
//  Flight.h
//  DataStore
//
//  Created by Christopher Miller on 20/05/16.
//  Copyright © 2016 Christopher Miller. All rights reserved.
//

#import <DataStore/DataStore.h>

@interface Flight : Model
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *destination;
@end
