//
//  DeltaImagesViewController.m
//  chessrecorder
//
//  Created by colman on 02/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "DeltaImagesViewController.h"

@interface DeltaImagesViewController ()

@end

@implementation DeltaImagesViewController
@synthesize images;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    images = [[NSMutableArray alloc] init];
    [self readImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void) readImages {
    UIImage *image = [UIImage imageNamed:@"1_w_d4.JPG"];
    image = [UIImage imageNamed:@"1_b_d5.JPG"];
    [images addObject:image];
    image = [UIImage imageNamed:@"2_w_B_f4.JPG"];
    [images addObject:image];
    image = [UIImage imageNamed:@"2_b_e6.JPG"];
    [images addObject:image];
    image = [UIImage imageNamed:@"3_w_e3.JPG"];
    [images addObject:image];
    image = [UIImage imageNamed:@"3_b_B_b4.JPG"];
    [images addObject:image];
    image = [UIImage imageNamed:@"4_w_K_d2.JPG"];
    [images addObject:image];
    image = [UIImage imageNamed:@"4_b_Q_h4.JPG"];
    [images addObject:image];
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
