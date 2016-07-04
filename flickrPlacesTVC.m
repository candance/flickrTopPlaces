//
//  flickrPlacesTVC.m
//  flickrTopPlaces
//
//  Created by Candance Smith on 6/30/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "flickrPlacesTVC.h"
#import "FlickrFetcher.h"
#import "FlickrPlace.h"
#import "FlickrPhotosFromPlaceVC.h"

@interface flickrPlacesTVC ()

@property (strong, nonatomic) NSString *currentlySelectedId;

@end

@implementation flickrPlacesTVC

- (void)setPlaces:(NSArray *)places {
    _places = places;
    // reload places everytime because model drives the UI
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDataSource>

// return number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // aka countryArray
    return self.places.count;
}

// return number of rows in the section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *cities = self.places[section];
    return cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Flickr Place Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // sort cities in alphabetical order
    NSSortDescriptor *sortCities = [NSSortDescriptor sortDescriptorWithKey:@"city" ascending:YES];
    
    // Configure the cell...
    NSArray *cities = self.places[indexPath.section];
    NSArray *sortedCities = [cities sortedArrayUsingDescriptors:@[sortCities]];
    FlickrPlace *city = sortedCities[indexPath.row];
    cell.textLabel.text = city.city;
    // set the subtitle for cell
    cell.detailTextLabel.text = city.region;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *cities = self.places[section];
    FlickrPlace *city = cities.lastObject;
    return city.country;
}

#pragma mark - <UITableViewDelegate>

// table view has been selected at a certain row (or a specific cell has been tapped)
// indexPath is a 'location'/'address' (but not the memory address) for cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"Display Photos for Place" sender:indexPath];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        if ([segue.identifier isEqualToString:@"Display Photos for Place"]) {
            if ([segue.destinationViewController isKindOfClass:[FlickrPhotosFromPlaceVC class]]) {
                FlickrPhotosFromPlaceVC *vc = [segue destinationViewController];
                // casting sender to be NSIndexPath from id
                NSIndexPath *indexPath = (NSIndexPath *)sender;
                NSArray *countryChosen = self.places[indexPath.section];
                FlickrPlace *cityChosen = countryChosen[indexPath.row];
                vc.cityID = cityChosen.placeID;
            }
        }
    }
}

@end
