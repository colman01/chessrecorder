//
//  ChessModel.h
//  chessrecorder
//
//  Created by colman on 25/09/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChessModel : NSObject

typedef enum {
    PAWN,
    KNIGHT,
    BISHOP,
    ROOK,
    QUEEN,
    KING
} ChessType;


typedef enum {
        BLACK,
        WHITE
} ChessColor;

typedef struct {
    ChessType type;
    ChessColor color;
} ChessPiece;


- (bool) checkColorOfPositionX:(int) x andPositionY:(int) y;

@end
