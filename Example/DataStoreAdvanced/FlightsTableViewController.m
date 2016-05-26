//
//  FlightsTableViewController.m
//  DataStore
//
//  Created by Christopher Miller on 20/05/16.
//  Copyright © 2016 Christopher Miller. All rights reserved.
//

#import "Flight.h"
#import "BookFlightViewController.h"
#import "FlightsTableViewController.h"

@interface FlightTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *flightIcon;
@property (weak, nonatomic) IBOutlet UILabel *flightNumber;
@property (weak, nonatomic) IBOutlet UILabel *flightDestination;
@end

@implementation FlightTableViewCell
@end

@interface FlightsTableViewController ()
@property (nonatomic, strong) IBOutlet UITextField *searchBar;
@property (nonatomic, strong) NSArray *flights;
@property (nonatomic, strong) NSArray *searchResults;
@end

@implementation FlightsTableViewController
- (IBAction)onSearch:(id)sender {
    NSLog(@"Input Value: %@", self.searchBar.text);
    [self updateFilteredContentFromInput:self.searchBar.text];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sky_101.bmp"]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.flights = [Flight all];
    Flight *flight = self.flights.count == 0 ? nil : self.flights[0];
    
    NSLog(@"All Flights = %@", self.flights);
    NSLog(@"First Flight (name = %@, destination = %@)", flight.name, flight.arriving);
    
    [self updateFilteredContentFromInput:self.searchBar.text];
}

- (void)updateFilteredContentFromInput:(NSString *)flightSearch {
    
    if (flightSearch == nil) {
        self.searchResults = [self.flights mutableCopy];
    } else {
        NSString *searchingFor = [NSString stringWithFormat:@"%%%@%%", flightSearch];
        self.searchResults = [[[[Flight where:@"name" is:searchingFor]
                                orWhere:@"departing" is:searchingFor]  orWhere:@"arriving" is:searchingFor] get];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    FlightTableViewCell *cell = (FlightTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FlightTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    Flight *test = self.searchResults[indexPath.row];
    cell.flightNumber.text = test.name;
    cell.flightDestination.text = [NSString stringWithFormat:@"To: %@ ", test.arriving];
    
    cell.flightIcon.layer.cornerRadius = 4;
    cell.flightIcon.clipsToBounds = YES;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BookFlightViewController *bookFlight = [self.storyboard instantiateViewControllerWithIdentifier:@"BookFlight"];
    
    Flight *flight = [self.flights objectAtIndex:indexPath.row];
    bookFlight.flight = flight;
    
    [self.navigationController pushViewController:bookFlight animated:YES];
    
}
@end
