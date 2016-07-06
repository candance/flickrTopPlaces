//
//  FlickrPhotosFromPlaceVC.h
//  flickrTopPlaces
//
//  Created by Candance Smith on 7/1/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "JustPostedflickrTopPlacesTVC.h"

@interface FlickrPhotosFromPlaceVC : UIViewController

@property (strong, nonatomic) id cityID;

@property (strong, nonatomic) NSDictionary *photo;

@property (nonatomic, strong) NSArray *photos; //of flickr photos NSDictionary

- (void)reloadData;

@end
