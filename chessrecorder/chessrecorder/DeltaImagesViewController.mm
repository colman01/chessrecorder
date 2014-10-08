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
@synthesize images, imageView, transform;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    images = [[NSMutableArray alloc] init];
    transform = [[HomographyTransform alloc] init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated   {
    [self readImages];
    [self transformImage];
}


-(void) readImages {
    UIImage *image = [UIImage imageNamed:@"1_w_d4.JPG"];
    [images addObject:image];
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

- (void) computeDeltaImage:(UIImage *)I_1 withImageTwo:(UIImage *)I_2 {
//    cv::Mat delta1 = [CvMatUIImageConverter cvMatGrayFromUIImage:I_1];
//    cv::Mat delta2 = [CvMatUIImageConverter cvMatGrayFromUIImage:I_2];
//    cv::Mat delta;
//    cv::subtract(delta1, delta2, delta);
    
    GPUImageSubtractBlendFilter *subtractFilter = [[GPUImageSubtractBlendFilter alloc] init];
//    imageView.image = [CvMatUIImageConverter UIImageFromCVMat:delta];
//    UIImage *inputImage = [UIImage imageNamed:@""];
    GPUImagePicture *sourcePicture;
    sourcePicture = [[GPUImagePicture alloc] initWithImage:I_1 smoothlyScaleOutput:YES];
    [sourcePicture processImage];
    [sourcePicture addTarget:subtractFilter];
    UIImage *res = [subtractFilter imageByFilteringImage:I_2];
    
    [imageView setImage:res];
    
//    GPUImageCannyEdgeDetectionFilter *canny = [[GPUImageCannyEdgeDetectionFilter alloc] init];
    
     
//    [imageView setImage:[canny imageByFilteringImage:res]]; //I_n45
    
    
//    GPUImageBrightnessFilter *bright = [[GPUImageBrightnessFilter alloc] init];
//    [bright setBrightness:0.15];
    
//    [imageView setImage:[bright imageByFilteringImage:[CvMatUIImageConverter UIImageFromCVMat:delta]]]; //I_n45
}

- (void) transformImage {
    
    NSMutableArray *pointsSet1 = [[NSMutableArray alloc] init];
    CGPoint p1 = CGPointMake(310, 560);
    [pointsSet1 addObject:[NSValue valueWithCGPoint:p1]];
    CGPoint p2 = CGPointMake(2105, 510);
    [pointsSet1 addObject:[NSValue valueWithCGPoint:p2]];
    CGPoint p3 = CGPointMake(2160, 2320);
    [pointsSet1 addObject:[NSValue valueWithCGPoint:p3]];
    CGPoint p4 = CGPointMake(310, 2343);
    [pointsSet1 addObject:[NSValue valueWithCGPoint:p4]];
    
    NSMutableArray *pointsSet2 = [[NSMutableArray alloc] init];
    p1 = CGPointMake(280, 430);
    [pointsSet2 addObject:[NSValue valueWithCGPoint:p1]];
    p2 = CGPointMake(2090, 385);
    [pointsSet2 addObject:[NSValue valueWithCGPoint:p2]];
    p3 = CGPointMake(2100, 2250);
    [pointsSet2 addObject:[NSValue valueWithCGPoint:p3]];
    p4 = CGPointMake(245, 2222);
    [pointsSet2 addObject:[NSValue valueWithCGPoint:p4]];
    
    //
    NSMutableArray *pointsSet3 = [[NSMutableArray alloc] init];
    p1 = CGPointMake(310, 425);
    [pointsSet3 addObject:[NSValue valueWithCGPoint:p1]];
    p2 = CGPointMake(2100, 444);
    [pointsSet3 addObject:[NSValue valueWithCGPoint:p2]];
    p3 = CGPointMake(2150, 2222);
    [pointsSet3 addObject:[NSValue valueWithCGPoint:p3]];
    p4 = CGPointMake(270, 2250);
    [pointsSet3 addObject:[NSValue valueWithCGPoint:p4]];
    
    NSMutableArray *pointsSet4 = [[NSMutableArray alloc] init];
    p1 = CGPointMake(300, 480);
    [pointsSet4 addObject:[NSValue valueWithCGPoint:p1]];
    p2 = CGPointMake(2220, 430);
    [pointsSet4 addObject:[NSValue valueWithCGPoint:p2]];
    p3 = CGPointMake(2300, 2400);
    [pointsSet4 addObject:[NSValue valueWithCGPoint:p3]];
    p4 = CGPointMake(290, 2420);
    [pointsSet4 addObject:[NSValue valueWithCGPoint:p4]];
    
    //
    
    NSMutableArray *pointsSet5 = [[NSMutableArray alloc] init];
    p1 = CGPointMake(260, 514);
    [pointsSet5 addObject:[NSValue valueWithCGPoint:p1]];
    p2 = CGPointMake(2050, 490);
    [pointsSet5 addObject:[NSValue valueWithCGPoint:p2]];
    p3 = CGPointMake(2100, 2300);
    [pointsSet5 addObject:[NSValue valueWithCGPoint:p3]];
    p4 = CGPointMake(245, 2340);
    [pointsSet5 addObject:[NSValue valueWithCGPoint:p4]];
    
    NSMutableArray *pointsSet6 = [[NSMutableArray alloc] init];
    p1 = CGPointMake(198, 545);
    [pointsSet6 addObject:[NSValue valueWithCGPoint:p1]];
    p2 = CGPointMake(2040, 505);
    [pointsSet6 addObject:[NSValue valueWithCGPoint:p2]];
    p3 = CGPointMake(2100, 2400);
    [pointsSet6 addObject:[NSValue valueWithCGPoint:p3]];
    p4 = CGPointMake(175, 2411);
    [pointsSet6 addObject:[NSValue valueWithCGPoint:p4]];
    
    //
    
    NSMutableArray *pointsSet7 = [[NSMutableArray alloc] init];
    p1 = CGPointMake(276, 360);
    [pointsSet7 addObject:[NSValue valueWithCGPoint:p1]];
    p2 = CGPointMake(2200, 360);
    [pointsSet7 addObject:[NSValue valueWithCGPoint:p2]];
    p3 = CGPointMake(2220, 2300);
    [pointsSet7 addObject:[NSValue valueWithCGPoint:p3]];
    p4 = CGPointMake(250, 2300);
    [pointsSet7 addObject:[NSValue valueWithCGPoint:p4]];
    
    NSMutableArray *pointsSet8 = [[NSMutableArray alloc] init];
    p1 = CGPointMake(300, 472);
    [pointsSet8 addObject:[NSValue valueWithCGPoint:p1]];
    p2 = CGPointMake(2260, 450);
    [pointsSet8 addObject:[NSValue valueWithCGPoint:p2]];
    p3 = CGPointMake(2275, 2426);
    [pointsSet8 addObject:[NSValue valueWithCGPoint:p3]];
    p4 = CGPointMake(300, 2430);
    [pointsSet8 addObject:[NSValue valueWithCGPoint:p4]];
    
    

    UIImage *img1, *img2;
    img2 = [self.transform transform:pointsSet1 withImage:[images objectAtIndex:0 ]];
    img1 = [self.transform transform:pointsSet2 withImage:[images objectAtIndex:1 ]];
//
//    img2 = [self.transform transform:pointsSet2 withImage:[images objectAtIndex:1 ]];
//    img1 = [self.transform transform:pointsSet3 withImage:[images objectAtIndex:2 ]];
//
//    img2 = [self.transform transform:pointsSet3 withImage:[images objectAtIndex:2 ]];
//    img1 = [self.transform transform:pointsSet4 withImage:[images objectAtIndex:3 ]];
//
//    img2 = [self.transform transform:pointsSet4 withImage:[images objectAtIndex:3 ]];
//    img1 = [self.transform transform:pointsSet5 withImage:[images objectAtIndex:4 ]];
//
//    img2 = [self.transform transform:pointsSet5 withImage:[images objectAtIndex:4 ]];
//    img1 = [self.transform transform:pointsSet6 withImage:[images objectAtIndex:5 ]];
//
//    img2 = [self.transform transform:pointsSet6 withImage:[images objectAtIndex:5 ]];
//    img1 = [self.transform transform:pointsSet7 withImage:[images objectAtIndex:6 ]];
    
//    img2 = [self.transform transform:pointsSet7 withImage:[images objectAtIndex:6 ]];
//    img1 = [self.transform transform:pointsSet8 withImage:[images objectAtIndex:7 ]];
    
    [self computeDeltaImage:img1 withImageTwo:img2];
}

@end
