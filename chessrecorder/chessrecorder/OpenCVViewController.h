//
//  OpenCVViewController.h
//  chessrecorder
//
//  Created by colman on 28/09/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>
#import "SimpleVideoFilterViewController.h"
#import "ShowcaseFilterViewController.h"

@interface OpenCVViewController : UIViewController

@property IBOutlet UIImageView *imageView;

@property IBOutlet UIImageView *imageViewCxy;
@property IBOutlet UIImageView *imageViewC45;
@property IBOutlet UIImageView *imageViewI;


@end
