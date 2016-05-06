//
//  ShowFrameViewController.h
//  chessrecorder
//
//  Created by colman on 26/11/15.
//  Copyright © 2015 Colman Marcus-Quinn. All rights reserved.
//

#import "ViewController.h"

@interface ShowFrameViewController : ViewController

@property IBOutlet UIImageView *imgView;
@property IBOutlet UIImageView *subView;
@property IBOutlet UISlider *slider;
@property IBOutlet UISwitch *saveImages;
@property IBOutlet UIView *averageColor;



@property NSMutableArray *chessImages;

@property UICollectionView *collectionView;

@property NSNumber *numberOfCorners;

@property int selectedImage;

@property bool newSelection;



@end
