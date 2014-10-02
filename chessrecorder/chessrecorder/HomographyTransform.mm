//
//  HomographyTransform.m
//  chessrecorder
//
//  Created by colman on 02/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "HomographyTransform.h"
#import "CvMatUIImageConverter.h"
#include <opencv2/imgproc/imgproc.hpp>

@implementation HomographyTransform



- (UIImage *) transform:(NSMutableArray *) chosenPoints withImage:(UIImage *)sourceImage {
    int dstImgSize = 400;
    
    UIImage* srcImgUi;
    cv::Point2f* src = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    cv::Point2f* dst = (cv::Point2f*) malloc(4 * sizeof(cv::Point2f));
    

    srcImgUi = sourceImage;
    src[0] = *(__bridge cv::Point2f*)[chosenPoints objectAtIndex:0];
    src[1] = *(__bridge cv::Point2f*)[chosenPoints objectAtIndex:1];
    src[2] = *(__bridge cv::Point2f*)[chosenPoints objectAtIndex:2];
    src[3] = *(__bridge cv::Point2f*)[chosenPoints objectAtIndex:3];
    
    //    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chessboard_03" ofType:@"jpg"]];
//    src[0] = cv::Point2f(81, 308);
//    src[1] = cv::Point2f(534, 279);
//    src[2] = cv::Point2f(934, 406);
//    src[3] = cv::Point2f(377, 542);

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
    
    cv::Mat plainBoardImg;
    cv::warpPerspective(srcImg, plainBoardImg, m, cv::Size(dstImgSize, dstImgSize));
    
    cv::Mat sub = srcImg(cv::Rect(srcImg.cols - plainBoardImg.cols, 0, plainBoardImg.cols, plainBoardImg.rows));
    plainBoardImg.copyTo(sub);
    
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
        printf("board is adjusted left-right, thus it needs to be rotated 90deg\n");
    } else {
        printf("board is adjusted top-bottom, thus there is no need to rotate it by 90deg\n");
    }
    
    UIImage* combinedImg = [CvMatUIImageConverter UIImageFromCVMat:srcImg];
//    self.imgView.image = combinedImg;
}



@end
