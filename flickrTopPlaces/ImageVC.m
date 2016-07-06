//
//  ImageVC.m
//  flickrTopPlaces
//
//  Created by Candance Smith on 7/3/16.
//  Copyright © 2016 candance. All rights reserved.
//

#import "ImageVC.h"

@interface ImageVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation ImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
    self.imageView.image = self.image;
   }

@end
