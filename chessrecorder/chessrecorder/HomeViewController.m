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

- (void)viewDidLoad {
    [super viewDidLoad];
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
}


@end
