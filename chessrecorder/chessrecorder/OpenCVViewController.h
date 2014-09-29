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


//input
//(     -3.5      4.4  -1081.2 )
//(     -1.1    -16.7   5241.9 )
//(      0.0     -0.0      1.0 )
//
//changing [0, 0] from     -3.5 to 0
//changing [0, 2] from  -1081.2 to 0
//changing [1, 0] from     -1.1 to 0
//changing [1, 1] from    -16.7 to 0
//changing [2, 1] from     -0.0 to 0
//output
//(      0.0      4.4      0.0 )
//(      0.0      0.0   5241.9 )
//(      0.0      0.0      1.0 )