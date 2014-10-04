//
//  MainscreenViewController.m
//  chessrecorder
//
//  Created by colman on 01/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "MainscreenViewController.h"

@interface MainscreenViewController ()

@end

@implementation MainscreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *records = [[GameDao instance ] getAllGames];
    if (records.count < 1) {
        CreateSampleGameData *createData = [[CreateSampleGameData alloc] init];
        [createData createSampleData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}


-(void) viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
