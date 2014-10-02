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



- (NSString *) getSymbolForFigure :(ChessPiece) chessPiece{
    NSString *symbol = @"";
    switch (chessPiece.type) {
        case PAWN:
            symbol = @"p";
            break;
        case KNIGHT:
            symbol = @"N";
            break;
        case BISHOP:
            symbol = @"B";
            break;
        case ROOK:
            symbol = @"R";
            break;
        case QUEEN:
            symbol = @"Q";
            break;
        case KING:
            symbol = @"K";
            break;
        default:
            break;
    }
    return symbol;
}


- (NSString *) figure:(ChessPiece) playedChessPiece tookFigure:(ChessPiece) capturedPiece onField:(NSString *) field{
    NSString *symbolPlayed = [self getSymbolForFigure:playedChessPiece];
    symbolPlayed = [symbolPlayed stringByAppendingString:@"x"];
    NSString *symbolCaptured = [self getSymbolForFigure:capturedPiece];
    symbolPlayed = [symbolPlayed stringByAppendingString:symbolCaptured];
    symbolPlayed = [symbolPlayed stringByAppendingString:field];
    return  symbolPlayed;
}


- (NSString *) figure:(ChessPiece) playedChessPiece onField:(NSString *) field{
    NSString *notation;
    if (playedChessPiece.type != PAWN) {
        NSString *symbol = [self getSymbolForFigure:playedChessPiece];
        notation = [symbol stringByAppendingString:field];
    }
    return notation;
}

@end
