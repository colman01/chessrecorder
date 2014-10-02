//
//  DeltaImagesViewController.h
//  chessrecorder
//
//  Created by colman on 02/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomographyTransform.h"
#import <GPUImage/GPUImage.h>

@interface DeltaImagesViewController : UIViewController

@property NSMutableArray *images;

@property IBOutlet UIImageView *imageView;

@property HomographyTransform * transform;

@end
