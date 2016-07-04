//
//  FlickrPhotosFromPlaceVC.m
//  flickrTopPlaces
//
//  Created by Candance Smith on 7/1/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "FlickrPhotosFromPlaceVC.h"
#import "FlickrFetcher.h"
#import "FlickrPlace.h"
#import "PhotoTitlePlaceCell.h"

// need to put <...> because this is subclass of UIViewController, which doesn't subscribe to the datasource and delegate protocol, unlike UITableViewController in flickrPlacesTVC
@interface FlickrPhotosFromPlaceVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FlickrPhotosFromPlaceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // telling tableView you're the delegate for the UITableViewDataSource protocol
    self.tableView.dataSource = self;
    // telling tableView you're the delegate for the UITableViewDelegate protocol
    self.tableView.delegate = self;
    [self.tableView reloadData];
    [self fetchPhotos];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)fetchPhotos {
    
    NSURL *url = [FlickrFetcher URLforPhotosInPlace:self.cityID maxResults:50];
    
#warning BLOCK MAIN THREAD
    
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
    NSDictionary *photosResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                  options:0
                                                                    error:NULL];
    
    // NSLog(@"Places Results:%@", photosResults);
    
    self.photos = [NSArray new];
    
    self.photos = [photosResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Photo Title Place Cell";
    PhotoTitlePlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *photo = self.photos[indexPath.row];
    if ([photo valueForKeyPath:FLICKR_PHOTO_TITLE]) {
        cell.photoTitle.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    }
    else if ([photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION]) {
        cell.photoTitle.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    }
    else {
        cell.photoTitle.text = @"Unknown";
    }
    cell.photoSubtitle.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
