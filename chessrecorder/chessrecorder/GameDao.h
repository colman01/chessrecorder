//
//  GameDao.h
//  chessrecorder
//
//  Created by colman on 04/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DmGameInformation.h"
#import "AppDelegate.h"

@interface GameDao : NSObject

+ (GameDao *) instance;
- (NSMutableArray*) getAllGames;
- (DmGameInformation *) loadById:(NSNumber *) id;
- (void) remove: (DmGameInformation *) gameInfo;

@end
