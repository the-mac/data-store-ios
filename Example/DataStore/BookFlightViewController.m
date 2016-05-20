//
//  BookFlightViewController.m
//  DataStore
//
//  Created by Christopher Miller on 20/05/16.
//  Copyright © 2016 Christopher Miller. All rights reserved.
//

#import "Flight.h"
#import "BookFlightViewController.h"

@interface BookFlightViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flightNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightDestinationLabel;
@end

@implementation BookFlightViewController
- (IBAction)bookFlight {
    
    
    Flight *flight = [[Flight alloc] init];
    flight.name = self.flightNumberLabel.text;
    flight.destination = self.flightDestinationLabel.text;
    
    [flight save];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    int count = [Flight count];
    int flightNumber = (count + 1) * 144;
    self.flightNumberLabel.text = [NSString stringWithFormat:@"Flight %d", flightNumber];
}

@end
