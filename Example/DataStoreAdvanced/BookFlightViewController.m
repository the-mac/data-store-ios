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
@property (weak, nonatomic) IBOutlet UILabel *flightDepartingLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightArrivingLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightDepartingAbbr;
@property (weak, nonatomic) IBOutlet UILabel *flightArrivingAbbr;
@property (weak, nonatomic) IBOutlet UIButton *updateFlightLabel;
@end

@implementation BookFlightViewController
-(int) random { return rand() % 9; }
-(int) numericValue:(NSString *) str  {
    int total = 0;
    for(int i = 0; i < [str length]; i++) {
        int value = (int)[str characterAtIndex:i];
        if((value >96 && value <123) || (value >64 && value <91))
            total += value;
    }
    return total;// % 255;
}

- (IBAction)updateFlight {
    
    if(self.flight == nil) {
        
        Flight *flight = [[Flight alloc] init];
        flight.name = self.navigationController.navigationBar.topItem.title;
        flight.departing = self.flightDepartingLabel.text;
        flight.departingAbbr = self.flightDepartingAbbr.text;
        flight.arriving = self.flightArrivingLabel.text;
        flight.arrivingAbbr = self.flightArrivingAbbr.text;
        
        [flight save];
        
    } else {
        [self.flight remove];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sky_101.bmp"]];
    
    if(self.flight == nil) {
        
        // USE RANDOM AGAINST flights.plist
        int random = [self random];
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flights" ofType:@"plist"]];
        NSLog(@"dictionary = %@", dictionary);
        
        NSArray *flights = [dictionary objectForKey:@"flights"];
        NSLog(@"flights = %@", flights);
        
        NSDictionary *flight = [flights objectAtIndex:random];
        NSArray *d = [[flight objectForKey:@"departing"] componentsSeparatedByString: @","];
        NSArray *a = [[flight objectForKey:@"arriving"] componentsSeparatedByString: @","];
        
        
        NSString *departing = [NSString stringWithFormat:@"%@, %@", [d objectAtIndex:0], [d objectAtIndex:1]];
        NSString *arriving = [NSString stringWithFormat:@"%@, %@", [a objectAtIndex:0], [a objectAtIndex:1]];
        
        NSString *departingAbbr = [d objectAtIndex:2];
        NSString *arrivingAbbr = [a objectAtIndex:2];
        
        int flightNumber = (int)(self.position + 1) * [self numericValue:arriving];
        
        
        self.title = [NSString stringWithFormat:@"Flight %d", flightNumber];
        
        self.flightDepartingLabel.text = departing;
        self.flightDepartingAbbr.text = departingAbbr;
        self.flightArrivingLabel.text = arriving;
        self.flightArrivingAbbr.text  = arrivingAbbr;
        [self.updateFlightLabel setTitle:@"Book Flight" forState:UIControlStateNormal];
    } else {
        self.title = self.flight.name;
        
        self.flightDepartingLabel.text = self.flight.departing;
        self.flightDepartingAbbr.text = self.flight.departingAbbr;
        self.flightArrivingLabel.text = self.flight.arriving;
        self.flightArrivingAbbr.text  = self.flight.arrivingAbbr;
        [self.updateFlightLabel setTitle:@"Cancel Flight" forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

@end
