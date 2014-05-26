//
//  ImageViewController.m
//  CarbonWorkout
//
//  Created by Kevin Carbone on 5/16/14.
//  Copyright (c) 2014 Kevin Carbone. All rights reserved.
//

#import "ImageViewController.h"

@implementation ImageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage * portraitImage = [[UIImage alloc] initWithCGImage: _image.CGImage
                                                         scale: 1.0
                                                   orientation: UIImageOrientationRight];
    _imageView.image = portraitImage;
}



@end
