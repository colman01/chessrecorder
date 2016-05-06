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
//        cv::circle(srcImg, cv::Point2i(detectedCorners[i].x, detectedCorners[i].y), 7, cv::Scalar(127, 127, 255), -1);
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
    
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chess_rotate" ofType:@"jpg"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Chess_table" ofType:@"jpg"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4_w_K_d2" ofType:@"JPG"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_test" ofType:@"png"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_test_rotate" ofType:@"png"]];
    
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1_b_d5" ofType:@"JPG"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1_w_d4" ofType:@"JPG"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2_w_B_f4" ofType:@"JPG"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2_b_e6" ofType:@"JPG"]];
//    
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"3_w_e3" ofType:@"JPG"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"3_b_B_b4" ofType:@"JPG"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4_w_K_d2" ofType:@"JPG"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4_b_Q_h4" ofType:@"JPG"]];
    
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rotate_1_b_d5" ofType:@"JPG"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rotate_1_w_d4" ofType:@"JPG"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rotate_2_w_B_f5" ofType:@"JPG"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rotate_2_b_e5" ofType:@"JPG"]];
//
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rotate_3_Q_d2" ofType:@"JPG"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rotate_3_b_QxB_f5" ofType:@"JPG"]];
    
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cut_4_w_K_d2" ofType:@"JPG"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cut_4_b_Q_h4" ofType:@"JPG"]];
    
//        srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"x_3_w_Q_d2" ofType:@"jpg"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cut" ofType:@"png"]];
    
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cut_r_1_w_d4" ofType:@"png"]];
//        srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cut_r_1_b_d6" ofType:@"png"]];
//        srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data_dammit" ofType:@"png"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rotate_game" ofType:@"jpg"]];
    
//        srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"game_2" ofType:@"jpg"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_1_w_d2" ofType:@"jpg"]];
//    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_1_b_g6" ofType:@"jpg"]];
    srcImgUi = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_2_w_B_f4" ofType:@"jpg"]];
    
    

    
    src[0] = cv::Point2f( 82,  84);
    src[1] = cv::Point2f(521, 141);
    src[2] = cv::Point2f(519, 636);
    src[3] = cv::Point2f( 83, 696);
    
    dst[0] = cv::Point2f(dstImgSize / 8    , dstImgSize / 8    );
    dst[1] = cv::Point2f(dstImgSize / 8 * 7, dstImgSize / 8    );
    dst[2] = cv::Point2f(dstImgSize / 8 * 7, dstImgSize / 8 * 7);
    dst[3] = cv::Point2f(dstImgSize / 8    , dstImgSize / 8 * 7);
    
    cv::Mat srcImg = [CvMatUIImageConverter cvMatFromUIImage:srcImgUi];
    
    std::vector<cv::Point2f> detectedCorners = CheckDet::getOuterCheckerboardCorners(srcImg);
    for (int i = 0; i < MIN(4, detectedCorners.size()); i++) {
//        cv::circle(srcImg, cv::Point2i(detectedCorners[i].x, detectedCorners[i].y), 7, cv::Scalar(127, 127, 255), -1);
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
    
    int i =0;
    for (UIImageView *img in imageViewFieldArray) {
        UIImage* tempField = [fields objectAtIndex:i];
        i++;
        GPUImageCannyEdgeDetectionFilter* filter = [[GPUImageCannyEdgeDetectionFilter alloc] init];
        [filter setBlurTexelSpacingMultiplier:.01];
        CGImageRef res = [filter newCGImageByFilteringCGImage:tempField.CGImage];
        
//        GPUImageCrosshairGenerator *crosshairGenerator = [[GPUImageCrosshairGenerator alloc] init];
//        crosshairGenerator.crosshairWidth = 15.0;
//        [crosshairGenerator forceProcessingAtSize:CGSizeMake(480.0, 640.0)];
//        
//        [(GPUImageHarrisCornerDetectionFilter *)filter setCornersDetectedBlock:^(GLfloat* cornerArray, NSUInteger cornersDetected, CMTime frameTime) {
//            [crosshairGenerator renderCrosshairsFromArray:cornerArray count:cornersDetected frameTime:frameTime];
//            NSLog(@"hum");
//        }];
//        
//        [filter newCGImageByFilteringCGImage:tempField.CGImage];
        
//        GPUImageHistogramFilter* histogram = [[GPUImageHistogramFilter alloc] init];
//        [histogram ]
//        UIImage* fieldImage = [UIImage imageWithCGImage:res];
//        NSData *data = (NSData *)CFBridgingRelease(CGDataProviderCopyData(CGImageGetDataProvider(res)));
//        const char *bytes = (const char *)[data bytes];
//        int len = [data length];
//        
//        // Note: this assumes 32bit RGBA
//        for (int i = 0; i < len; i += 4) {
//            char r = bytes[i];
//            char g = bytes[i+1];
//            char b = bytes[i+2];
//            char a = bytes[i+3];
//        }
//        fieldImage.
        img.image = [UIImage imageWithCGImage:res];
        UIColor *result = [self averageColor:res];
        CGColorRef comps = [result CGColor];
//        CGColor comps = [result CGColor];
        const CGFloat *comp = CGColorGetComponents(comps);
        
        CGFloat red = comp[0];
        CGFloat green = comp[1];
        CGFloat blue = comp[2];

        float threshold = 0.49;
        if ( green < threshold) {
            img.image = nil;
            
        }
//        if (red < threshold | green < threshold | blue < threshold) {
//            img.image = nil;
//            
//        }
        
        
    }
    
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

    [self.subView setImage:[CvMatUIImageConverter UIImageFromCVMat:plainBoardImg]];
    UIImage* combinedImg = [CvMatUIImageConverter UIImageFromCVMat:srcImg];
    self.imgView.image = combinedImg;
}

//- (UIImage *)imageByFilteringImage:(UIImage *)imageToFilter;
//{
//    CGImageRef image = [self newCGImageByFilteringCGImage:[imageToFilter CGImage] orientation:[imageToFilter imageOrientation]];
//    UIImage *processedImage = [UIImage imageWithCGImage:image scale:[imageToFilter scale] orientation:[imageToFilter imageOrientation]];
//    CGImageRelease(image);
//    return processedImage;
//}

- (UIColor *)averageColor:(CGImageRef ) CGImage {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    if(rgba[3] == 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    }
    else {
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
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
