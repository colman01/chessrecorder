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
    if (records.count < 4) {
        CreateSampleGameData *createData = [[CreateSampleGameData alloc] init];
        [createData createSampleData];
    }
    

    UITabBar *tabBar = self.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    [tabBarItem1 setImage:[UIImage imageNamed:@"realIcond30.png"]];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    [tabBarItem3 setImage:[UIImage imageNamed:@"Info.png"]];
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
