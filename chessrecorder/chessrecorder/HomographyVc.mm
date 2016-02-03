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
#include "CheckerboardDetector.h"

@interface HomographyVc ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *subView;

@end

@implementation HomographyVc

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self transform];
    [self transformField];
}


- (void) transform {
    int dstImgSize = 400;
    
    UIImage* srcImgUi;
    cv::Point2f* src = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    cv::Point2f* dst = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    
    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chess_table" ofType:@"jpg"]];
    
//    + (UIImage *)imageWithCGImage:(CGImageRef)imageRef scale:(CGFloat)scale orientation:(UIImageOrientation)orientatio
    srcImgUi = [UIImage imageWithCGImage:srcImgUi.CGImage scale:0.1 orientation:UIImageOrientationUp];


    // image resize
//    UIImageView *uiImageView = [UIImageView init];
//    uiImageView.image = srcImgUi;
//    uiImageView.frame = CGRectMake(0,0,6,6);
//    srcImgUi = uiImageView.image;
//    UIImageView *imageView = [UIImageView
//    imageView.frame = CGRectMake(0,0,16,16); // change the size of the image view
    // end image resize
    
    
    
//    switch (rand() % 5) {
//        case 0:
//            srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chessboard_03" ofType:@"jpg"]];
//            src[0] = cv::Point2f(81, 308);
//            src[1] = cv::Point2f(534, 279);
//            src[2] = cv::Point2f(934, 406);
//            src[3] = cv::Point2f(377, 542);
//            break;
//        case 1:
//            srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chessboard_02" ofType:@"jpg"]];
//            src[0] = cv::Point2f(89.1, 313.2);
//            src[1] = cv::Point2f(528.0, 250.8);
//            src[2] = cv::Point2f(932.6, 379.2);
//            src[3] = cv::Point2f(440.0, 570.0);
//            break;
//        case 2:
//            srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chess_rotate" ofType:@"jpg"]];
//            src[0] = cv::Point2f( 82,  84);
//            src[1] = cv::Point2f(521, 141);
//            src[2] = cv::Point2f(519, 636);
//            src[3] = cv::Point2f( 83, 696);
//            break;
//        case 3:
//            srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Chess_table" ofType:@"jpg"]];
//            src[0] = cv::Point2f(340, 243);
//            src[1] = cv::Point2f(549, 216);
//            src[2] = cv::Point2f(652, 314);
//            src[3] = cv::Point2f(404, 355);
//            break;
//        case 4:
//            srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Chess_board_top" ofType:@"jpg"]];
//            src[0] = cv::Point2f( 83,  96);
//            src[1] = cv::Point2f(708,  87);
//            src[2] = cv::Point2f(706, 715);
//            src[3] = cv::Point2f( 86, 711);
//            break;
//    }

//    dst[0] = cv::Point2f(         0,          0);
//    dst[1] = cv::Point2f(dstImgSize,          0);
//    dst[2] = cv::Point2f(dstImgSize, dstImgSize);
//    dst[3] = cv::Point2f(         0, dstImgSize);
    
    
    
    dst[0] = cv::Point2f(dstImgSize / 8    , dstImgSize / 8    );
    dst[1] = cv::Point2f(dstImgSize / 8 * 7, dstImgSize / 8    );
    dst[2] = cv::Point2f(dstImgSize / 8 * 7, dstImgSize / 8 * 7);
    dst[3] = cv::Point2f(dstImgSize / 8    , dstImgSize / 8 * 7);
    
    cv::Mat srcImg = [CvMatUIImageConverter cvMatFromUIImage:srcImgUi];
    
    int numberOfPoints=0;
    std::vector<cv::Point2f> detectedCorners = CheckDet::getOuterCheckerboardCorners(srcImg, numberOfPoints);
    for (int i = 0; i < MIN(4, detectedCorners.size()); i++) {
        cv::circle(srcImg, cv::Point2i(detectedCorners[i].x, detectedCorners[i].y), 7, cv::Scalar(127, 127, 255), -1);
        src[i] = detectedCorners[i];
    }
    
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
    
    cv::Mat plainBoardImg;
    cv::warpPerspective(srcImg, plainBoardImg, m, cv::Size(dstImgSize, dstImgSize));
    
    cv::Rect fieldRect = cv::Rect(0, 0, plainBoardImg.cols / 8, plainBoardImg.rows / 8);
    cv::Mat fieldType0Mean = cv::Mat::zeros(fieldRect.height, fieldRect.width, CV_16UC4);
    cv::Mat fieldType1Mean = cv::Mat::zeros(fieldRect.height, fieldRect.width, CV_16UC4);
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            fieldRect.x = fieldRect.width * i;
            fieldRect.y = fieldRect.height * j;
            
            cv::Mat field(plainBoardImg, fieldRect);
            field.convertTo(field, CV_16UC4);
            field /= 32;
            
            if ((i + j) % 2 == 0) {
                fieldType0Mean += field;
            } else {
                fieldType1Mean += field;
            }
        }
    }
    
    fieldRect.x = 0; fieldRect.y = 0;
    fieldType0Mean.copyTo(srcImg(fieldRect));
    fieldRect.x = fieldRect.width; fieldRect.y = 0;
    fieldType1Mean.copyTo(srcImg(fieldRect));
    
    cv::Scalar meanPixel = cv::mean(fieldType0Mean);
    meanPixel.val[3] = 0;
    double brightnessType0 = sqrtl(meanPixel.dot(meanPixel));
    
    meanPixel = cv::mean(fieldType1Mean);
    meanPixel.val[3] = 0;
    double brightnessType1 = sqrtl(meanPixel.dot(meanPixel));
    
    if (brightnessType0 < brightnessType1) {
        //printf("board is adjusted left-right, thus it needs to be rotated 90deg\n");
        cv::transpose(plainBoardImg, plainBoardImg);
        cv::flip(plainBoardImg, plainBoardImg, 0);
    }
    
    cv::Mat sub = srcImg(cv::Rect(srcImg.cols - plainBoardImg.cols, 0, plainBoardImg.cols, plainBoardImg.rows));
    plainBoardImg.copyTo(sub);
    
//    [self.subView setImage:[CvMatUIImageConverter UIImageFromCVMat:fieldType0Mean]];
    [self.subView setImage:[CvMatUIImageConverter UIImageFromCVMat:plainBoardImg]];
    

    UIImage* combinedImg = [CvMatUIImageConverter UIImageFromCVMat:srcImg];
    self.imgView.image = combinedImg;
}


- (void) transformField {
    int dstImgSize = 400;
//    int dstImgSize = 100;
    
    UIImage* srcImgUi;
    cv::Point2f* src = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    cv::Point2f* dst = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));

//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chess_rotate_200" ofType:@"jpeg"]];
    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chess_rotate" ofType:@"jpg"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chess_rotate_resize" ofType:@"jpeg"]];
    src[0] = cv::Point2f( 82,  84);
    src[1] = cv::Point2f(521, 141);
    src[2] = cv::Point2f(519, 636);
    src[3] = cv::Point2f( 83, 696);
    
    dst[0] = cv::Point2f(dstImgSize / 8    , dstImgSize / 8    );
    dst[1] = cv::Point2f(dstImgSize / 8 * 7, dstImgSize / 8    );
    dst[2] = cv::Point2f(dstImgSize / 8 * 7, dstImgSize / 8 * 7);
    dst[3] = cv::Point2f(dstImgSize / 8    , dstImgSize / 8 * 7);
    
    cv::Mat srcImg = [CvMatUIImageConverter cvMatFromUIImage:srcImgUi];

    int numberOfPoints=0;
    std::vector<cv::Point2f> detectedCorners = CheckDet::getOuterCheckerboardCorners(srcImg, numberOfPoints);
    for (int i = 0; i < MIN(4, detectedCorners.size()); i++) {
        cv::circle(srcImg, cv::Point2i(detectedCorners[i].x, detectedCorners[i].y), 7, cv::Scalar(127, 127, 255), -1);
        src[i] = detectedCorners[i];
    }
    
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
    
    cv::Mat plainBoardImg;
    cv::warpPerspective(srcImg, plainBoardImg, m, cv::Size(dstImgSize, dstImgSize));
    
    cv::Rect fieldRect = cv::Rect(0, 0, plainBoardImg.cols / 8, plainBoardImg.rows / 8);
    cv::Mat fieldType0Mean = cv::Mat::zeros(fieldRect.height, fieldRect.width, CV_16UC4);
    cv::Mat fieldType1Mean = cv::Mat::zeros(fieldRect.height, fieldRect.width, CV_16UC4);
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            fieldRect.x = fieldRect.width * i;
            fieldRect.y = fieldRect.height * j;
            
            cv::Mat field(plainBoardImg, fieldRect);
            field.convertTo(field, CV_16UC4);
            field /= 32;
            
            if ((i + j) % 2 == 0) {
                fieldType0Mean += field;
            } else {
                fieldType1Mean += field;
            }
        }
    }

    
    NSMutableArray *fields = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            fieldRect.x = fieldRect.width * i;
            fieldRect.y = fieldRect.height * j;
            
            cv::Mat field(plainBoardImg, fieldRect);
            field.convertTo(field, CV_16UC4);
            field /= 32;
            
            [fields addObject:[CvMatUIImageConverter UIImageFromCVMat:field]];
            
            if ((i + j) % 2 == 0) {
                fieldType0Mean += field;
            } else {
                fieldType1Mean += field;
            }
        }
    }
    
    fieldRect.x = 0; fieldRect.y = 0;
    fieldType0Mean.copyTo(srcImg(fieldRect));
    fieldRect.x = fieldRect.width; fieldRect.y = 0;
    fieldType1Mean.copyTo(srcImg(fieldRect));
    
    cv::Scalar meanPixel = cv::mean(fieldType0Mean);
    meanPixel.val[3] = 0;
    double brightnessType0 = sqrtl(meanPixel.dot(meanPixel));
    
    meanPixel = cv::mean(fieldType1Mean);
    meanPixel.val[3] = 0;
    double brightnessType1 = sqrtl(meanPixel.dot(meanPixel));
    
    if (brightnessType0 < brightnessType1) {
        //printf("board is adjusted left-right, thus it needs to be rotated 90deg\n");
        cv::transpose(plainBoardImg, plainBoardImg);
        cv::flip(plainBoardImg, plainBoardImg, 0);
    }
    
    cv::Mat sub = srcImg(cv::Rect(srcImg.cols - plainBoardImg.cols, 0, plainBoardImg.cols, plainBoardImg.rows));
    plainBoardImg.copyTo(sub);
    
    //    [self.subView setImage:[CvMatUIImageConverter UIImageFromCVMat:fieldType0Mean]];
    [self.subView setImage:[CvMatUIImageConverter UIImageFromCVMat:plainBoardImg]];
    
    
    UIImage* combinedImg = [CvMatUIImageConverter UIImageFromCVMat:srcImg];
        self.imgView.image = combinedImg;
}

//- (void) transformField {
//    int dstImgSize = 400;
//    
//    UIImage* srcImgUi;
//    cv::Point2f* src = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
//    cv::Point2f* dst = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
//    
////    image = [UIImage imageNamed:@"2_w_B_f4.JPG"];
////    [images addObject:image];
////    image = [UIImage imageNamed:@"2_b_e6.JPG"];
//    
////    NSMutableArray *pointsSet3 = [[NSMutableArray alloc] init];
////    p1 = CGPointMake(310, 425);
////    [pointsSet3 addObject:[NSValue valueWithCGPoint:p1]];
////    p2 = CGPointMake(2100, 444);
////    [pointsSet3 addObject:[NSValue valueWithCGPoint:p2]];
////    p3 = CGPointMake(2150, 2222);
////    [pointsSet3 addObject:[NSValue valueWithCGPoint:p3]];
////    p4 = CGPointMake(270, 2250);
////    [pointsSet3 addObject:[NSValue valueWithCGPoint:p4]];
////    
////    NSMutableArray *pointsSet4 = [[NSMutableArray alloc] init];
////    p1 = CGPointMake(300, 480);
////    [pointsSet4 addObject:[NSValue valueWithCGPoint:p1]];
////    p2 = CGPointMake(2220, 430);
////    [pointsSet4 addObject:[NSValue valueWithCGPoint:p2]];
////    p3 = CGPointMake(2300, 2400);
////    [pointsSet4 addObject:[NSValue valueWithCGPoint:p3]];
////    p4 = CGPointMake(290, 2420);
////    [pointsSet4 addObject:[NSValue valueWithCGPoint:p4]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chess_rotate" ofType:@"jpg"]];
//    src[0] = cv::Point2f( 82,  84);
//    src[1] = cv::Point2f(521, 141);
//    src[2] = cv::Point2f(519, 636);
//    src[3] = cv::Point2f( 83, 696);
//    
////    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chess_rotate" ofType:@"jpg"]];
////    src[0] = cv::Point2f( 82,  84);
////    src[1] = cv::Point2f(521, 141);
////    src[2] = cv::Point2f(519, 636);
////    src[3] = cv::Point2f( 83, 696);
//    
//    //    dst[0] = cv::Point2f(         0,          0);
//    //    dst[1] = cv::Point2f(dstImgSize,          0);
//    //    dst[2] = cv::Point2f(dstImgSize, dstImgSize);
//    //    dst[3] = cv::Point2f(         0, dstImgSize);
//    
//    
//    
//    dst[0] = cv::Point2f(dstImgSize / 8    , dstImgSize / 8    );
//    dst[1] = cv::Point2f(dstImgSize / 8 * 7, dstImgSize / 8    );
//    dst[2] = cv::Point2f(dstImgSize / 8 * 7, dstImgSize / 8 * 7);
//    dst[3] = cv::Point2f(dstImgSize / 8    , dstImgSize / 8 * 7);
//    
//    cv::Mat srcImg = [CvMatUIImageConverter cvMatFromUIImage:srcImgUi];
//    
//    std::vector<cv::Point2f> detectedCorners = CheckDet::getOuterCheckerboardCorners(srcImg);
//    for (int i = 0; i < MIN(4, detectedCorners.size()); i++) {
//        cv::circle(srcImg, cv::Point2i(detectedCorners[i].x, detectedCorners[i].y), 7, cv::Scalar(127, 127, 255), -1);
//        src[i] = detectedCorners[i];
//    }
//    
//    printf("getPerspectiveTransform\n");
//    printf("    input\n");
//    for (int i = 0; i < 4; i++) {
//        printf("        (%5.1f, %5.1f) -> (%5.1f, %5.1f)\n", src[i].x, src[i].y, dst[i].x, dst[i].y);
//    }
//    
//    cv::Mat m = cv::getPerspectiveTransform(src, dst);
//    
//    printf("    output\n");
//    for(int i = 0; i < m.rows; i++) {
//        const double* mi = m.ptr<double>(i);
//        printf("        ( ");
//        for(int j = 0; j < m.cols; j++) {
//            printf("%8.1f ", mi[j]);
//        }
//        printf(")\n");
//    }
//    free(dst);
//    free(src);
//    
//    cv::Mat plainBoardImg;
//    cv::warpPerspective(srcImg, plainBoardImg, m, cv::Size(dstImgSize, dstImgSize));
//    
//    cv::Rect fieldRect = cv::Rect(0, 0, plainBoardImg.cols / 8, plainBoardImg.rows / 8);
//    cv::Mat fieldType0Mean = cv::Mat::zeros(fieldRect.height, fieldRect.width, CV_16UC4);
//    cv::Mat fieldType1Mean = cv::Mat::zeros(fieldRect.height, fieldRect.width, CV_16UC4);
//    for (int i = 0; i < 8; i++) {
//        for (int j = 0; j < 8; j++) {
//            fieldRect.x = fieldRect.width * i;
//            fieldRect.y = fieldRect.height * j;
//            
//            cv::Mat field(plainBoardImg, fieldRect);
//            field.convertTo(field, CV_16UC4);
//            field /= 32;
//            
//            if ((i + j) % 2 == 0) {
//                fieldType0Mean += field;
//            } else {
//                fieldType1Mean += field;
//            }
//        }
//    }
//    
//    
//    NSMutableArray *fields = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < 8; i++) {
//        for (int j = 0; j < 8; j++) {
//            fieldRect.x = fieldRect.width * i;
//            fieldRect.y = fieldRect.height * j;
//            
//            cv::Mat field(plainBoardImg, fieldRect);
//            field.convertTo(field, CV_16UC4);
//            field /= 32;
//            
//            [fields addObject:[CvMatUIImageConverter UIImageFromCVMat:field]];
//            
//            if ((i + j) % 2 == 0) {
//                fieldType0Mean += field;
//            } else {
//                fieldType1Mean += field;
//            }
//        }
//    }
//    
//    fieldRect.x = 0; fieldRect.y = 0;
//    fieldType0Mean.copyTo(srcImg(fieldRect));
//    fieldRect.x = fieldRect.width; fieldRect.y = 0;
//    fieldType1Mean.copyTo(srcImg(fieldRect));
//    
//    cv::Scalar meanPixel = cv::mean(fieldType0Mean);
//    meanPixel.val[3] = 0;
//    double brightnessType0 = sqrtl(meanPixel.dot(meanPixel));
//    
//    meanPixel = cv::mean(fieldType1Mean);
//    meanPixel.val[3] = 0;
//    double brightnessType1 = sqrtl(meanPixel.dot(meanPixel));
//    
//    if (brightnessType0 < brightnessType1) {
//        //printf("board is adjusted left-right, thus it needs to be rotated 90deg\n");
//        cv::transpose(plainBoardImg, plainBoardImg);
//        cv::flip(plainBoardImg, plainBoardImg, 0);
//    }
//    
//    cv::Mat sub = srcImg(cv::Rect(srcImg.cols - plainBoardImg.cols, 0, plainBoardImg.cols, plainBoardImg.rows));
//    plainBoardImg.copyTo(sub);
//    
//    //    [self.subView setImage:[CvMatUIImageConverter UIImageFromCVMat:fieldType0Mean]];
//    [self.subView setImage:[CvMatUIImageConverter UIImageFromCVMat:plainBoardImg]];
//    
//    
//    UIImage* combinedImg = [CvMatUIImageConverter UIImageFromCVMat:srcImg];
////    self.imgView.image = combinedImg;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
