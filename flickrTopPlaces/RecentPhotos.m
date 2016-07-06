//
//  RecentPhotos.m
//  flickrTopPlaces
//
//  Created by Candance Smith on 7/5/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "RecentPhotos.h"
#import "FlickrPhotosFromPlaceVC.h"
#import "FlickrFetcher.h"

@implementation RecentPhotos

+(NSArray *)viewedRecentPhotosList {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"RECENT_PHOTOS"];
}

+(void)addPhotoToRecents:(NSDictionary *)photo {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *recentlyViewedPhotos = [[defaults objectForKey:@"RECENT_PHOTOS"] mutableCopy];
    
    if (!recentlyViewedPhotos) recentlyViewedPhotos = [NSMutableArray new];
    
    // Check if image is already stored in NSUserDefaults
    NSString *currentPhotoID = [photo valueForKey:FLICKR_PHOTO_ID];
    // cannot use fast enumeration here because we need to remove objects
    for (int i = 0; i < recentlyViewedPhotos.count; i++) {
        if ([[recentlyViewedPhotos[i] valueForKey:FLICKR_PHOTO_ID] isEqualToString:currentPhotoID]) {
            [recentlyViewedPhotos removeObjectAtIndex:i];
        }
    }
    
    [recentlyViewedPhotos insertObject:photo atIndex:0];
    
    if (recentlyViewedPhotos.count > 20) {
        [recentlyViewedPhotos removeLastObject];
    }
    
    // Add the updated collection back to user defaults
    [defaults setObject:recentlyViewedPhotos forKey:@"RECENT_PHOTOS"];
    
    // Save
    [defaults synchronize];
}

@end
