//
//  GameHistoryViewController.h
//  chessrecorder
//
//  Created by colman on 01/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameDao.h"


@interface GameHistoryViewController : UIViewController <UITableViewDelegate>


@property IBOutlet UITableView *gameList;
@property (strong, nonatomic) NSArray* fetchedRecordsArray;

@end
