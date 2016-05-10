//
//  ShowFramePadViewController.h
//  chessrecorder
//
//  Created by colman on 06/05/16.
//  Copyright © 2016 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowFramePadViewController : UIViewController

@property IBOutlet UIImageView *imgView;
@property IBOutlet UIImageView *subView;
@property IBOutlet UICollectionView *collectionView;
@property IBOutlet UISlider *slider;

@property IBOutlet UIView *board;
@property IBOutlet UIImageView *square;

@property NSMutableArray *chessImages;

@property bool newSelection;

@end
