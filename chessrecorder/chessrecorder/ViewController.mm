//
//  ViewController.m
//  chessrecorder
//
//  Created by colman on 19/09/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//


#import "ViewController.h"
#import "CvMatUIImageConverter.h"

#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/calib3d/calib3d.hpp>
#include <opencv2/highgui/highgui.hpp>

#include <vector>


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self detectChessboard];
    
    //[self warpSpeedImage];
}

- (void) detectChessboard {
    //UIImage *imgSrc = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chessboard_03" ofType:@"jpg"]];
    //UIImage *imgSrc = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"perfect_checkerboard" ofType:@"png"]];
    UIImage *imgSrc = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chess-top-view" ofType:@"jpg"]];
    
    [self detectChessboard:imgSrc];
}

- (void) detectChessboard:(UIImage*)img {
    cv::Size patternsize(7, 7);
    cv::Mat frame = [CvMatUIImageConverter cvMatFromUIImage:img];
    std::vector<cv::Point2f> corners;
    
    printf("doing cv::findChessboardCorners\n");
    bool found = cv::findChessboardCorners(frame, patternsize, corners, CV_CALIB_CB_ADAPTIVE_THRESH + CV_CALIB_CB_FILTER_QUADS + CV_CALIB_CB_NORMALIZE_IMAGE + CV_CALIB_CB_FAST_CHECK);
    printf("found: %s\n", found ? "YES" : "NO");
    
    cv::drawChessboardCorners(frame, patternsize, cv::Mat(corners), found);
    
    printf("done\n");
}

- (void) warpSpeedImage {
    
    DHWarpView *warpView = [[DHWarpView alloc] initWithFrame:CGRectMake(0, 0, 1400, 1400)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chess_rotate.jpg"]];
    
    warpView.frame = self.display.bounds;
    warpView.contentMode = UIViewContentModeScaleAspectFit; // or other desired mode
    //    warpView.contentMode = UIViewContentModeScaleToFill;
    //    warpView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    warpView.autoresizingMask = UIViewAutoresizingNone;
    self.display.autoresizingMask = UIViewAutoresizingNone;
    
    [warpView addSubview:imageView];
    [self.display addSubview:warpView];
    //    warpView.topLeft = CGPointMake(97, 49);
    //    warpView.topRight = CGPointMake(677, 46);
    //    warpView.bottomLeft = CGPointMake(15, 580);
    //    warpView.bottomRight = CGPointMake(775, 580);
    
    //    warpView.topLeft = CGPointMake(97, 49);
    //    warpView.topRight = CGPointMake(677, 46);
    //    warpView.bottomLeft = CGPointMake(15, 580);
    //    warpView.bottomRight = CGPointMake(775, 580);
    
    //    warpView.topLeft = CGPointMake(150, 336);
    //    warpView.topRight = CGPointMake(460, 30);
    //    warpView.bottomLeft = CGPointMake(350, 1000);
    //    warpView.bottomRight = CGPointMake(490, 540);
    
//    warpView.topLeft = CGPointMake(-20, -30);
//    warpView.topRight = CGPointMake(680, -30);
//    warpView.bottomLeft = CGPointMake(20, 550);
//    warpView.bottomRight = CGPointMake(470, 550);
    
//    warpView.topLeft = CGPointMake(470, 550);
//    warpView.topRight = CGPointMake(20, 550);
//    warpView.bottomLeft = CGPointMake(680, -30);
//    warpView.bottomRight = CGPointMake(-20, -30);
    
    warpView.topLeft = CGPointMake(27, 26);
    warpView.topRight = CGPointMake(550, -30);
    warpView.bottomLeft = CGPointMake(20, 400);
    warpView.bottomRight = CGPointMake(555, 700);
    
    CGRect center = self.display.frame;
    center.origin.x -= 50;
    center.origin.y -= 400;
    [warpView setFrame:center];
    

    self.display.layer.cornerRadius = 10.0;
    self.display.layer.shadowRadius = 10.0;
    self.display.layer.shadowColor = [UIColor blackColor].CGColor;
    self.display.layer.shadowOpacity = 1.0;
    self.display.layer.shadowRadius = 5.0;
    self.display.layer.shadowOffset = CGSizeMake(0, 3);
    self.display.clipsToBounds = NO;
    

    [warpView warp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

bool dragging;
CGFloat oldX, oldY;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if ([[touch.view class] isSubclassOfClass:[UIView class]]) {
        dragging = YES;
        oldX = touchLocation.x;
        oldY = touchLocation.y;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    dragging = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if ([[touch.view class] isSubclassOfClass:[UIView class]]) {
        UIImageView *label = (UIImageView *)touch.view;
        if (dragging) {
            CGRect frame = label.frame;
            frame.origin.x = label.frame.origin.x + touchLocation.x - oldX;
            frame.origin.y = label.frame.origin.y + touchLocation.y - oldY;
            label.frame = frame;
        }
    }
}

@end
