//
//  HomographyVc.m
//  chessrecorder
//
//  Created by Mac on 29.09.14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "HomographyVc.h"

@interface HomographyVc ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation HomographyVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage* imgSrc = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chessboard_03" ofType:@"jpg"]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
