//
//  HomographyVc.m
//  chessrecorder
//
//  Created by Mac on 29.09.14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "HomographyVc.h"
#import "CvMatUIImageConverter.h"
#include <opencv2/imgproc/imgproc.hpp>

@interface HomographyVc ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation HomographyVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self transform];
}

- (void) transform {
    int dstImgSize = 400;
    
    UIImage* srcImgUi;
    cv::Point2f* src = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    cv::Point2f* dst = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    
    switch (rand() % 4) {
        case 0:
            srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chessboard_03" ofType:@"jpg"]];
            src[0] = cv::Point2f(81, 308);
            src[1] = cv::Point2f(534, 279);
            src[2] = cv::Point2f(934, 406);
            src[3] = cv::Point2f(377, 542);
            break;
        case 1:
            srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chessboard_02" ofType:@"jpg"]];
            src[0] = cv::Point2f(89.1, 313.2);
            src[1] = cv::Point2f(528.0, 250.8);
            src[2] = cv::Point2f(932.6, 379.2);
            src[3] = cv::Point2f(440.0, 570.0);
            break;
        case 2:
            srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chess_rotate" ofType:@"jpg"]];
            src[0] = cv::Point2f(521, 141);
            src[1] = cv::Point2f(519, 636);
            src[2] = cv::Point2f( 81, 696);
            src[3] = cv::Point2f( 80,  84);
            break;
        case 3:
            srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Chess_table" ofType:@"jpg"]];
            src[0] = cv::Point2f(340, 243);
            src[1] = cv::Point2f(549, 216);
            src[2] = cv::Point2f(652, 314);
            src[3] = cv::Point2f(404, 355);
            break;
    }

    dst[0] = cv::Point2f(         0,          0);
    dst[1] = cv::Point2f(dstImgSize,          0);
    dst[2] = cv::Point2f(dstImgSize, dstImgSize);
    dst[3] = cv::Point2f(         0, dstImgSize);
    
    printf("getPerspectiveTransform\n");
    printf("    input\n");
    for (int i = 0; i < 4; i++) {
        printf("        (%5.1f, %5.1f) -> (%5.1f, %5.1f)\n", src[i].x, src[i].y, dst[i].x, dst[i].y);
    }

    cv::Mat m = cv::getPerspectiveTransform(src, dst);
    
    printf("    output\n");
    for(int i = 0; i < m.rows; i++) {
        const double* mi = m.ptr<double>(i);
        printf("        ( ");
        for(int j = 0; j < m.cols; j++) {
            printf("%8.1f ", mi[j]);
        }
        printf(")\n");
    }
    free(dst);
    free(src);
    
    cv::Mat srcImg = [CvMatUIImageConverter cvMatFromUIImage:srcImgUi];
    
    cv::Mat dstImg;
    cv::warpPerspective(srcImg, dstImg, m, cv::Size(dstImgSize, dstImgSize));
    
    UIImage* dstImgUi = [CvMatUIImageConverter UIImageFromCVMat:dstImg];
    
    UIGraphicsBeginImageContext(srcImgUi.size);
    [srcImgUi drawAtPoint:CGPointZero];
    [dstImgUi drawAtPoint:CGPointMake(srcImgUi.size.width - dstImgUi.size.width, 0)];
    //CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *combinedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imgView.image = combinedImg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
