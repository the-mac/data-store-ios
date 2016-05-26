//
//  BookFlightViewController.h
//  DataStore
//
//  Created by Christopher Miller on 20/05/16.
//  Copyright © 2016 Christopher Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookFlightViewController : UIViewController
@property (strong, nonatomic) Flight *flight;
@property (assign, nonatomic) NSInteger position;
@end
