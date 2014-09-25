//
//  ViewController.m
//  chessrecorder
//
//  Created by colman on 19/09/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//


#import "ViewController.h"

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
    UIImage *imgSrc = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chessboard_03" ofType:@"jpg"]];
    
    [self detectChessboard:imgSrc];
}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

- (void) detectChessboard:(UIImage*)img {
    NSLog(@"local array");
    cv::Size patternsize(8,8);
    NSLog(@"loading image");
    cv::Mat frame = [self cvMatFromUIImage:img];
    NSLog(@"vector for storing corners");
    std::vector<cv::Point2f> corners;
    NSLog(@"pettern");
    
    bool patternfound = findChessboardCorners(frame, patternsize, corners);

    NSLog(@"pettern found: %s", patternfound ? "YES" : "NO");
    drawChessboardCorners(frame, patternsize, cv::Mat(corners), patternfound);
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
