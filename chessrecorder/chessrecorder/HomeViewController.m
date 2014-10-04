//
//  HomeViewController.m
//  chessrecorder
//
//  Created by colman on 01/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "HomeViewController.h"
#import "AugmentedRealityViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize showHistory;
@synthesize notationView;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.gameNumber) {
        self.gameNumber = [NSNumber numberWithInt:0];
    } else {
        DmGameInformation *gameData = [[GameDao instance] loadById:self.gameNumber];
        [self.notationView setText:gameData.notation];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"Camera"]) {
        id dest = [segue destinationViewController];
        
        if(showHistory) {
            AugmentedRealityViewController  *aug = (AugmentedRealityViewController *) dest;
            aug.historyViewer = YES;
        }

    }
    
    if ([[segue identifier] isEqualToString:@"GameInfo"]) {
        id dest = [segue destinationViewController];
        PlayerInfoViewController *infoView = (PlayerInfoViewController *) dest;
        
        infoView.gameNumber = self.gameNumber;
    }
    

}


@end
