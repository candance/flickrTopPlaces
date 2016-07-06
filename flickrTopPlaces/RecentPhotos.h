//
//  RecentPhotos.h
//  flickrTopPlaces
//
//  Created by Candance Smith on 7/5/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentPhotos : NSObject

+(NSArray *)viewedRecentPhotosList;
+(void)addPhotoToRecents:(NSDictionary *)photo;

@end
