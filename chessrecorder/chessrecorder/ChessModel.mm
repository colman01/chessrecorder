//
//  ChessModel.m
//  chessrecorder
//
//  Created by colman on 25/09/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "ChessModel.h"

@implementation ChessModel


static ChessModel *sharedInstance;

+ (void)initialize
{
    if (self == [ChessModel class]) {
         sharedInstance = [[self alloc] init];
    }
}

- (void) setupBoard {
    NSMutableArray *board = [[NSMutableArray alloc] initWithCapacity:8];
    for (int i=0; i<8; i++) {
        NSMutableArray *boardLine = [[NSMutableArray alloc] initWithCapacity:8];
        for (int j=0; j<8; j++) {
            [board addObject:boardLine];
        }
    }

}

- (bool) checkColorOfPositionX:(int) x andPositionY:(int) y {
    return (x+y)%2;
}

@end
