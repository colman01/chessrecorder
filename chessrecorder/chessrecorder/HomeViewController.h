//
//  HomeViewController.h
//  chessrecorder
//
//  Created by colman on 01/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerInfoViewController.h"

@interface HomeViewController : UIViewController


- (IBAction)goBack:(id)sender;
@property bool showHistory;

@property NSNumber *gameNumber;

@end
