//
//  FlickrPlace.h
//  flickrTopPlaces
//
//  Created by Candance Smith on 6/30/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPlace : NSObject

@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *region;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *placeID;

@end
