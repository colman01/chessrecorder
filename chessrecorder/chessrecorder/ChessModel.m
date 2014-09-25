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

@end
