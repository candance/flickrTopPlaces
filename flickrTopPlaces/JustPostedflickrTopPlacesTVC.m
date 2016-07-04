//
//  JustPostedflickrTopPlacesTVC.m
//  flickrTopPlaces
//
//  Created by Candance Smith on 6/30/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "JustPostedflickrTopPlacesTVC.h"
#import "FlickrFetcher.h"
#import "FlickrPlace.h"

@interface JustPostedflickrTopPlacesTVC ()

@end

@implementation JustPostedflickrTopPlacesTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchPlaces];
}

- (void)fetchPlaces {
    
    NSURL *url = [FlickrFetcher URLforTopPlaces];
    
#warning BLOCK MAIN THREAD
    
    //flickr returns list of places in json format but we need to turn it into NSDictionary array.
    NSData *jsonResults = [NSData dataWithContentsOfURL:url]; // this will block main queue tho
    NSDictionary *placesResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                        options:0
                                                                          error:NULL];
    
    // NSLog(@"Places Results:%@", placesResults);
    
    NSDictionary *places = [placesResults valueForKeyPath:FLICKR_RESULTS_PLACES];

    NSArray *placesFullNames = [places valueForKey:FLICKR_PLACE_NAME];
    
    NSArray *placesID = [places valueForKey:FLICKR_PLACE_ID];
    
    self.places = [self createArrayForEachCountry:[self createFlickrPlacesArrayWithStringArray:placesFullNames withPlaceId:placesID]];
}

- (NSArray *)createFlickrPlacesArrayWithStringArray:(NSArray *)stringArray withPlaceId:(NSArray *)idArray {
    
    NSMutableArray<FlickrPlace *> *parsedPlaces = [[NSMutableArray alloc] init];
    int i = 0;
    
    for (NSString *place in stringArray) {
        NSArray *separatedPlaces = [place componentsSeparatedByString:@","];
        FlickrPlace *place = [[FlickrPlace alloc] init];
        place.city = separatedPlaces.firstObject;
        if (separatedPlaces.count < 3) {
            place.region = nil;
        }
        else {
            place.region = separatedPlaces[1];
        }
        place.country = separatedPlaces.lastObject;
        place.placeID = idArray[i];
        [parsedPlaces addObject:place];
        i++;
    }
    
    return [parsedPlaces copy];
}

- (NSArray *)createArrayForEachCountry:(NSArray *)flickrPlaces {
    
    NSMutableSet *countries = [[NSMutableSet alloc] init];
    
    // same as this for loop: for (FlickrPlace *place in stringArray)
    [flickrPlaces enumerateObjectsUsingBlock:^(FlickrPlace *place, NSUInteger idx, BOOL * _Nonnull stop) {
        [countries addObject:place.country];
    }];
    
    // new = alloc init
    NSMutableArray *countryArray = [NSMutableArray new];
    
    [countries enumerateObjectsUsingBlock:^(NSString *country, BOOL * _Nonnull stop) {
        NSMutableArray *cityArray = [NSMutableArray new];
        
        [flickrPlaces enumerateObjectsUsingBlock:^(FlickrPlace *place, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([country isEqualToString:place.country]) {
                [cityArray addObject:place];
            }
        }];
        
        [countryArray addObject:cityArray];
    }];
    
    return countryArray;
}

@end
