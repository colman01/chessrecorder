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
NSMutableArray *imageViewFieldArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMatrix];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self transformField];
}


- (void) transform {
    int dstImgSize = 400;
    
    UIImage* srcImgUi;
    cv::Point2f* src = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    cv::Point2f* dst = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));

    
    switch (rand() % 5) {
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
            src[0] = cv::Point2f( 82,  84);
            src[1] = cv::Point2f(521, 141);
            src[2] = cv::Point2f(519, 636);
            src[3] = cv::Point2f( 83, 696);
            break;
        case 3:
            srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Chess_table" ofType:@"jpg"]];
            src[0] = cv::Point2f(340, 243);
            src[1] = cv::Point2f(549, 216);
            src[2] = cv::Point2f(652, 314);
            src[3] = cv::Point2f(404, 355);
            break;
        case 4:
            srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Chess_board_top" ofType:@"jpg"]];
            src[0] = cv::Point2f( 83,  96);
            src[1] = cv::Point2f(708,  87);
            src[2] = cv::Point2f(706, 715);
            src[3] = cv::Point2f( 86, 711);
            break;
    }

//    dst[0] = cv::Point2f(         0,          0);
//    dst[1] = cv::Point2f(dstImgSize,          0);
//    dst[2] = cv::Point2f(dstImgSize, dstImgSize);
//    dst[3] = cv::Point2f(         0, dstImgSize);
    
    
    
    dst[0] = cv::Point2f(dstImgSize / 8    , dstImgSize / 8    );
    dst[1] = cv::Point2f(dstImgSize / 8 * 7, dstImgSize / 8    );
    dst[2] = cv::Point2f(dstImgSize / 8 * 7, dstImgSize / 8 * 7);
    dst[3] = cv::Point2f(dstImgSize / 8    , dstImgSize / 8 * 7);
    
    cv::Mat srcImg = [CvMatUIImageConverter cvMatFromUIImage:srcImgUi];
    
    std::vector<cv::Point2f> detectedCorners = CheckDet::getOuterCheckerboardCorners(srcImg);
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
    
    UIImage* srcImgUi;
    cv::Point2f* src = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    cv::Point2f* dst = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    
//    image = [UIImage imageNamed:@"2_w_B_f4.JPG"];
//    [images addObject:image];
//    image = [UIImage imageNamed:@"2_b_e6.JPG"];
    
//    NSMutableArray *pointsSet3 = [[NSMutableArray alloc] init];
//    p1 = CGPointMake(310, 425);
//    [pointsSet3 addObject:[NSValue valueWithCGPoint:p1]];
//    p2 = CGPointMake(2100, 444);
//    [pointsSet3 addObject:[NSValue valueWithCGPoint:p2]];
//    p3 = CGPointMake(2150, 2222);
//    [pointsSet3 addObject:[NSValue valueWithCGPoint:p3]];
//    p4 = CGPointMake(270, 2250);
//    [pointsSet3 addObject:[NSValue valueWithCGPoint:p4]];
//    
//    NSMutableArray *pointsSet4 = [[NSMutableArray alloc] init];
//    p1 = CGPointMake(300, 480);
//    [pointsSet4 addObject:[NSValue valueWithCGPoint:p1]];
//    p2 = CGPointMake(2220, 430);
//    [pointsSet4 addObject:[NSValue valueWithCGPoint:p2]];
//    p3 = CGPointMake(2300, 2400);
//    [pointsSet4 addObject:[NSValue valueWithCGPoint:p3]];
//    p4 = CGPointMake(290, 2420);
//    [pointsSet4 addObject:[NSValue valueWithCGPoint:p4]];
    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chess_rotate" ofType:@"jpg"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Chess_table" ofType:@"jpg"]];
    
    src[0] = cv::Point2f( 82,  84);
    src[1] = cv::Point2f(521, 141);
    src[2] = cv::Point2f(519, 636);
    src[3] = cv::Point2f( 83, 696);
    
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chess_rotate" ofType:@"jpg"]];
//    src[0] = cv::Point2f( 82,  84);
//    src[1] = cv::Point2f(521, 141);
//    src[2] = cv::Point2f(519, 636);
//    src[3] = cv::Point2f( 83, 696);
    
    //    dst[0] = cv::Point2f(         0,          0);
    //    dst[1] = cv::Point2f(dstImgSize,          0);
    //    dst[2] = cv::Point2f(dstImgSize, dstImgSize);
    //    dst[3] = cv::Point2f(         0, dstImgSize);
    
    
    
    dst[0] = cv::Point2f(dstImgSize / 8    , dstImgSize / 8    );
    dst[1] = cv::Point2f(dstImgSize / 8 * 7, dstImgSize / 8    );
    dst[2] = cv::Point2f(dstImgSize / 8 * 7, dstImgSize / 8 * 7);
    dst[3] = cv::Point2f(dstImgSize / 8    , dstImgSize / 8 * 7);
    
    cv::Mat srcImg = [CvMatUIImageConverter cvMatFromUIImage:srcImgUi];
    
    std::vector<cv::Point2f> detectedCorners = CheckDet::getOuterCheckerboardCorners(srcImg);
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
            [fields addObject:[CvMatUIImageConverter UIImageFromCVMat:field]];
            
            field /= 32;
            
            if ((i + j) % 2 == 0) {
                fieldType0Mean += field;
            } else {
                fieldType1Mean += field;
            }
        }
    }
    
//    UIImageView* tempField = [imageViewFieldArray objectAtIndex:i+j];
//    tempField.image = [CvMatUIImageConverter UIImageFromCVMat:field];
    
    int i =0;
    for (UIImageView *img in imageViewFieldArray) {
        UIImage* tempField = [fields objectAtIndex:i];
        i++;
        img.image = tempField;
    }
    
//    for (int i = 0; i < 8; i++) {
//        for (int j = 0; j < 8; j++) {
//            fieldRect.x = fieldRect.width * i;
//            fieldRect.y = fieldRect.height * j;
//            
//            cv::Mat field(plainBoardImg, fieldRect);
//            field.convertTo(field, CV_16UC4);
//            [fields addObject:[CvMatUIImageConverter UIImageFromCVMat:field]];
//            
////            UIImageView* tempField = [imageViewFieldArray objectAtIndex:i+j];
////            tempField.image = [CvMatUIImageConverter UIImageFromCVMat:field];
//            
//            field /= 32;
//
//            if ((i + j) % 2 == 0) {
//                fieldType0Mean += field;
//            } else {
//                fieldType1Mean += field;
//            }
//        }
//    }
    
    
//    [self.testField1 setImage:[fields objectAtIndex:0]];
//    [self.testField2 setImage:[fields objectAtIndex:1]];
//    [self.testField3 setImage:[fields objectAtIndex:2]];
//    [self.testField4 setImage:[fields objectAtIndex:3]];
    
    
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
    
//    cv::Rect sampleFieldRectangle = cv::Rect(srcImg.cols - plainBoardImg.cols, 0, plainBoardImg.cols / 8, plainBoardImg.rows / 8);
//    cv::Mat internalData = srcImg(sampleFieldRectangle);
//    internalData.convertTo(internalData, CV_16SC1);
//    UIImage* uiimageInternalData = [CvMatUIImageConverter UIImageFromCVMat:internalData];
//    [self.meanField0 setImage:uiimageInternalData];
    
    
    //    [self.subView setImage:[CvMatUIImageConverter UIImageFromCVMat:fieldType0Mean]];
    [self.subView setImage:[CvMatUIImageConverter UIImageFromCVMat:plainBoardImg]];
    UIImage* combinedImg = [CvMatUIImageConverter UIImageFromCVMat:srcImg];
    self.imgView.image = combinedImg;
}

- (void) createMatrix {
    imageViewFieldArray = [[NSMutableArray alloc] init];
    [imageViewFieldArray addObject:self.fieldA1];
    [imageViewFieldArray addObject:self.fieldA2];
    [imageViewFieldArray addObject:self.fieldA3];
    [imageViewFieldArray addObject:self.fieldA4];
    [imageViewFieldArray addObject:self.fieldA5];
    [imageViewFieldArray addObject:self.fieldA6];
    [imageViewFieldArray addObject:self.fieldA7];
    [imageViewFieldArray addObject:self.fieldA8];

    [imageViewFieldArray addObject:self.fieldB1];
    [imageViewFieldArray addObject:self.fieldB2];
    [imageViewFieldArray addObject:self.fieldB3];
    [imageViewFieldArray addObject:self.fieldB4];
    [imageViewFieldArray addObject:self.fieldB5];
    [imageViewFieldArray addObject:self.fieldB6];
    [imageViewFieldArray addObject:self.fieldB7];
    [imageViewFieldArray addObject:self.fieldB8];
    
    [imageViewFieldArray addObject:self.fieldC1];
    [imageViewFieldArray addObject:self.fieldC2];
    [imageViewFieldArray addObject:self.fieldC3];
    [imageViewFieldArray addObject:self.fieldC4];
    [imageViewFieldArray addObject:self.fieldC5];
    [imageViewFieldArray addObject:self.fieldC6];
    [imageViewFieldArray addObject:self.fieldC7];
    [imageViewFieldArray addObject:self.fieldC8];
    
    [imageViewFieldArray addObject:self.fieldD1];
    [imageViewFieldArray addObject:self.fieldD2];
    [imageViewFieldArray addObject:self.fieldD3];
    [imageViewFieldArray addObject:self.fieldD4];
    [imageViewFieldArray addObject:self.fieldD5];
    [imageViewFieldArray addObject:self.fieldD6];
    [imageViewFieldArray addObject:self.fieldD7];
    [imageViewFieldArray addObject:self.fieldD8];
    
    [imageViewFieldArray addObject:self.fieldE1];
    [imageViewFieldArray addObject:self.fieldE2];
    [imageViewFieldArray addObject:self.fieldE3];
    [imageViewFieldArray addObject:self.fieldE4];
    [imageViewFieldArray addObject:self.fieldE5];
    [imageViewFieldArray addObject:self.fieldE6];
    [imageViewFieldArray addObject:self.fieldE7];
    [imageViewFieldArray addObject:self.fieldE8];
    
    [imageViewFieldArray addObject:self.fieldF1];
    [imageViewFieldArray addObject:self.fieldF2];
    [imageViewFieldArray addObject:self.fieldF3];
    [imageViewFieldArray addObject:self.fieldF4];
    [imageViewFieldArray addObject:self.fieldF5];
    [imageViewFieldArray addObject:self.fieldF6];
    [imageViewFieldArray addObject:self.fieldF7];
    [imageViewFieldArray addObject:self.fieldF8];
    
    [imageViewFieldArray addObject:self.fieldG1];
    [imageViewFieldArray addObject:self.fieldG2];
    [imageViewFieldArray addObject:self.fieldG3];
    [imageViewFieldArray addObject:self.fieldG4];
    [imageViewFieldArray addObject:self.fieldG5];
    [imageViewFieldArray addObject:self.fieldG6];
    [imageViewFieldArray addObject:self.fieldG7];
    [imageViewFieldArray addObject:self.fieldG8];
    
    [imageViewFieldArray addObject:self.fieldH1];
    [imageViewFieldArray addObject:self.fieldH2];
    [imageViewFieldArray addObject:self.fieldH3];
    [imageViewFieldArray addObject:self.fieldH4];
    [imageViewFieldArray addObject:self.fieldH5];
    [imageViewFieldArray addObject:self.fieldH6];
    [imageViewFieldArray addObject:self.fieldH7];
    [imageViewFieldArray addObject:self.fieldH8];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
