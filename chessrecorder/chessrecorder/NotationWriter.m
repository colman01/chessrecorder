//
//  NotationWriter.m
//  chessrecorder
//
//  Created by colman on 02/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "NotationWriter.h"
#import "ChessModel.h"

@implementation NotationWriter


NSString *gameNotation = @"";


- (void) moveDetected:(NSString *) moveData {
    if (moveData.length < 3) {
        NSLog(@"Pawn moved");
        gameNotation = [gameNotation stringByAppendingString:@" "];
        gameNotation = [gameNotation stringByAppendingString:moveData];
        
    } else {
        NSLog(@"Figure moved");
        gameNotation = [gameNotation stringByAppendingString:@" "];
        gameNotation = [gameNotation stringByAppendingString:moveData];
    }
}




@end
