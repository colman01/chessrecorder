//
//  PlayerInfoViewController.m
//  chessrecorder
//
//  Created by colman on 02/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "PlayerInfoViewController.h"

@interface PlayerInfoViewController ()

@end

@implementation PlayerInfoViewController

@synthesize event, location, date, round, whitePlayer, blackPlayer, result;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.gameNumber)
        [self setupGameInfo:self.gameNumber];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setupGameInfo:(NSNumber *) gameNumber  {
    DmGameInformation *game = [[GameDao instance] loadById:gameNumber];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy/mm/dd"];
    
    [self.event setText:game.event];
    [self.location setText:game.site];
    [self.date setText:[f stringFromDate:game.date]];
    [self.round setText:[game.round stringValue]];
    [self.whitePlayer setText:game.white];
    [self.blackPlayer setText:game.black];
    [self.result setText:game.result];

}


@end
