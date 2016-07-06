//
//  RecentPhotosListVC.m
//  flickrTopPlaces
//
//  Created by Candance Smith on 7/5/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "RecentPhotosListVC.h"
#import "RecentPhotos.h"

@interface RecentPhotosListVC ()

@end

@implementation RecentPhotosListVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.photos = [RecentPhotos viewedRecentPhotosList];
    [self reloadData];
}

@end
