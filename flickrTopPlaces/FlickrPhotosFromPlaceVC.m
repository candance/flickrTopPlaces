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
#import "ImageVC.h"
#import "RecentPhotos.h"

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

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)fetchPhotos {
    
    NSURL *url = [FlickrFetcher URLforPhotosInPlace:self.cityID maxResults:50];
    
#warning BLOCK MAIN THREAD
    
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
    NSDictionary *photosResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                  options:0
                                                                    error:NULL];
    
    // NSLog(@"Photos Results:%@", photosResults);
    
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
    NSDictionary *photo = self.photos[indexPath.row];
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    NSString *photoTitle = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    NSString *photoDescription = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if ([[photoTitle stringByTrimmingCharactersInSet:set] length]) {
        cell.photoTitle.text = photoTitle;
    }
    else if ([[photoDescription stringByTrimmingCharactersInSet:set] length]) {
        cell.photoTitle.text = photoDescription;
    }
    else {
        cell.photoTitle.text = @"Unknown";
    }
    cell.photoSubtitle.text = photoDescription;
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

// table view has been selected at a certain row (or a specific cell has been tapped)
// indexPath is a 'location'/'address' (but not the memory address) for cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"Display Chosen Photo" sender:indexPath];
}

#pragma mark - Navigation

- (void)prepareImageViewController:(ImageVC *)ivc toDisplayPhoto:(NSDictionary *)photo {
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    NSLog(@"Image Title:%@",ivc.title);
    [RecentPhotos addPhotoToRecents:photo];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        if ([segue.identifier isEqualToString:@"Display Chosen Photo"]) {
            if ([segue.destinationViewController isKindOfClass:[ImageVC class]]) {
                // casting sender to be NSIndexPath from id
                NSIndexPath *indexPath = (NSIndexPath *)sender;
                NSDictionary *photo = self.photos[indexPath.row];
                [self prepareImageViewController:[segue destinationViewController]
                                  toDisplayPhoto:photo];
            }
        }
    }
}

@end
