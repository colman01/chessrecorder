//
//  PlayerInfoViewController.h
//  chessrecorder
//
//  Created by colman on 02/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameDao.h"

@interface PlayerInfoViewController : UIViewController


@property IBOutlet UITextView *event;
@property IBOutlet UITextView *location;
@property IBOutlet UITextView *date;
@property IBOutlet UITextView *round;
@property IBOutlet UITextView *whitePlayer;
@property IBOutlet UITextView *blackPlayer;
@property IBOutlet UITextView *result;
@property NSNumber *gameNumber;

- (void) setupGameInfo:(NSNumber *) gameNumber;


@end
