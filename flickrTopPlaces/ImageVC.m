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
// this is not used because it blocks main thread:
//    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
// self.imageView.image = self.image;
    [self startDownloadingImage];
}

// method to multithread
- (void)startDownloadingImage {
    // clear out whatever is in image currently
    self.image = nil;
    // making sure imageURL exists
    if (self.imageURL) {
        // creates request to get imageURL
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        // There are 3 kinds of configuration (ephemeral: download sth and be done; default:download multiple files/keeping sessions active; background: start downloading even if user quits app, calls back when done downloading)
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        // create session
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        // start downloading with completion handler - in a different queue
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                        completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
                                                            // if there's no error
                                                            if (!error) {
                                                                // double check URL is the one we want, even tho it's been set previously, it could've been changed by something else in the app, esp if downloading takes time and this request is no longer wanted
                                                                if ([request.URL isEqual:self.imageURL]) {
                                                                    // using localfile this is being done locally so it won't block main thread
                                                                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                                                                    // this has to happen on main thread so use dispatch_async
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        self.image = image;
                                                                        self.imageView.image = self.image;
                                                                    });
                                                                }
                                                            }
                                                        }];
        // needed because task is not called until this
        [task resume];
    }
}

@end
