//
//  DeltaImagesViewController.m
//  chessrecorder
//
//  Created by colman on 02/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "DeltaImagesViewController.h"
#import "CvMatUIImageConverter.h"
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/calib3d/calib3d.hpp>
#include <opencv2/highgui/highgui.hpp>

#include <opencv2/legacy/legacy.hpp>

@interface DeltaImagesViewController ()

@end

@implementation DeltaImagesViewController
@synthesize images, imageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    images = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated   {
    [self readImages];
    [self computeDeltaImage];
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

- (void) computeDeltaImage {
    cv::Mat delta1 = [CvMatUIImageConverter cvMatGrayFromUIImage:[self.images objectAtIndex:0]];
    cv::Mat delta2 = [CvMatUIImageConverter cvMatGrayFromUIImage:[self.images objectAtIndex:1]];
    cv::Mat delta;
    cv::subtract(delta1, delta2, delta);
    imageView.image = [CvMatUIImageConverter UIImageFromCVMat:delta];
}

- (void) transformImage {
    
//    510 340 top left
//    560 2120 bottom left
//    2333 270 top right
//    2360 2152 bottom right
    
    
    NSMutableArray *pointsSet1 = [[NSMutableArray alloc] init];
    CGPoint p1 = CGPointMake(510, 340);
    [pointsSet1 addObject:[NSValue valueWithCGPoint:p1]];
    
    CGPoint p2 = CGPointMake(0, 0);
    [pointsSet1 addObject:[NSValue valueWithCGPoint:p2]];
    
    CGPoint p3 = CGPointMake(0, 0);
    [pointsSet1 addObject:[NSValue valueWithCGPoint:p3]];
    
    CGPoint p4 = CGPointMake(0, 0);
    [pointsSet1 addObject:[NSValue valueWithCGPoint:p4]];
    
    
    NSMutableArray *pointsSet2 = [[NSMutableArray alloc] init];
    p1 = CGPointMake(0, 0);
    [pointsSet2 addObject:[NSValue valueWithCGPoint:p1]];
    
    p2 = CGPointMake(0, 0);
    [pointsSet2 addObject:[NSValue valueWithCGPoint:p2]];
    
    p3 = CGPointMake(0, 0);
    [pointsSet2 addObject:[NSValue valueWithCGPoint:p3]];
    
    p4 = CGPointMake(0, 0);
    [pointsSet2 addObject:[NSValue valueWithCGPoint:p4]];
    
    
    
    
}

@end
