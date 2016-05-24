//
//  FlightsTableViewController.m
//  DataStore
//
//  Created by Christopher Miller on 20/05/16.
//  Copyright © 2016 Christopher Miller. All rights reserved.
//

#import "Flight.h"
#import "FlightsTableViewController.h"

@interface FlightsTableViewController ()
@property (nonatomic, strong) NSArray *flights;
@end

@implementation FlightsTableViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.flights = [Flight all];
    Flight *test = self.flights.count == 0 ? nil : self.flights[0];
    
    NSLog(@"All Flights = %@", self.flights);
    NSLog(@"First Flight (name = %@, destination = %@)", test.name, test.destination);
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.flights.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    Flight *test = self.flights[indexPath.row];
    cell.textLabel.text = test.name;
    
    return cell;
}

@end
