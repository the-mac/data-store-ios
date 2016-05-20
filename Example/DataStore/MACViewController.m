//
//  MACViewController.m
//  DataStore
//
//  Created by Christopher Miller on 05/19/2016.
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
- (IBAction)cancelFlights {
    [Flight truncate];
    [self viewDidAppear:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    int count = [Flight count];
    self.flightCountLabel.text = [NSString stringWithFormat:@"%d Flight(s) Booked", count];
    
}

@end
