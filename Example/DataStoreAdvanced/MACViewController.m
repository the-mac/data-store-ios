//
//  MACViewController.m
//  DataStoreAdvanced
//
//  Created by Christopher Miller on 05/24/2016.
//  Copyright (c) 2016 Christopher Miller. All rights reserved.
//

#import "Flight.h"
#import "FlightsTableViewController.h"
#import "BookFlightViewController.h"
#import "MACViewController.h"


@interface MACViewController ()

@end

@implementation MACViewController
- (IBAction)showFlights {
    FlightsTableViewController *testTableController = [self.storyboard instantiateViewControllerWithIdentifier:@"FlightsTable"];
    [self.navigationController pushViewController:testTableController animated:YES];
}
- (IBAction)bookAFlight {
    BookFlightViewController *bookFlightController = [self.storyboard instantiateViewControllerWithIdentifier:@"BookFlight"];
    [self.navigationController pushViewController:bookFlightController animated:YES];
}
- (IBAction)cancelAllFlights {
    [Flight truncate];
    [self viewDidAppear:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sky_101.bmp"]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    int count = [Flight count];
    NSString *format = [NSString stringWithFormat:@"%d Flight%@ Booked", count, (count == 1 ? @"" : @"s")];
    self.flightCountLabel.text = format;
}

@end
