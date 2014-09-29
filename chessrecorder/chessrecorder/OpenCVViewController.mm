//
//  OpenCVViewController.m
//  chessrecorder
//
//  Created by colman on 28/09/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "OpenCVViewController.h"
#import "CvMatUIImageConverter.h"
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/calib3d/calib3d.hpp>
#include <opencv2/highgui/highgui.hpp>

#include <opencv2/legacy/legacy.hpp>

#include <vector>

@interface OpenCVViewController ()

@end

@implementation OpenCVViewController

@synthesize imageView, imageViewC45,imageViewCxy, imageViewI;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    
    GPUImageGaussianBlurFilter *gaussian = [[GPUImageGaussianBlurFilter alloc] init];
    gaussian.blurRadiusInPixels = 5.0;
    
    GPUImage3x3ConvolutionFilter *derivativeXConv = [[GPUImage3x3ConvolutionFilter alloc] init];
    [(GPUImage3x3ConvolutionFilter *)derivativeXConv setConvolutionKernel:(GPUMatrix3x3){
        {1.0f,  0.0f, -1.0f},
        {1.0f, 0.0f, -1.0f},
        {1.0f,  0.0f, -1.0f}
    }];
    
    GPUImage3x3ConvolutionFilter *derivativeYConv = [[GPUImage3x3ConvolutionFilter alloc] init];
    [(GPUImage3x3ConvolutionFilter *)derivativeYConv setConvolutionKernel:(GPUMatrix3x3){
        {1.0f,  1.0f, 1.0f},
        {0.0f, 0.0f, 0.0f},
        {-1.0f,  -1.0f, -1.0f}
    }];
    
    GPUImage3x3ConvolutionFilter *cosConv = [[GPUImage3x3ConvolutionFilter alloc] init];
    [(GPUImage3x3ConvolutionFilter *)cosConv setConvolutionKernel:(GPUMatrix3x3){
        {cosf(M_PI_4),  0.0f, 0.0f},
        {0.0f, cosf(M_PI_4), 0.0f},
        {0.0f,  0.0f, cosf(M_PI_4)}
    }];
    
    GPUImage3x3ConvolutionFilter *negCosConv = [[GPUImage3x3ConvolutionFilter alloc] init];
    [(GPUImage3x3ConvolutionFilter *)negCosConv setConvolutionKernel:(GPUMatrix3x3){
        {-cosf(M_PI_4),  0.0f, 0.0f},
        {0.0f, -cosf(M_PI_4), 0.0f},
        {0.0f,  0.0f, -cosf(M_PI_4)}
    }];
    
    GPUImage3x3ConvolutionFilter *sinConv = [[GPUImage3x3ConvolutionFilter alloc] init];
    [(GPUImage3x3ConvolutionFilter *)sinConv setConvolutionKernel:(GPUMatrix3x3){
        {sinf(M_PI_4),  0.0f, 0.0f},
        {0.0f, sinf(M_PI_4), 0.0f},
        {0.0f,  0.0f, sinf(M_PI_4)}
    }];
    
    GPUImage3x3ConvolutionFilter *negSinConv = [[GPUImage3x3ConvolutionFilter alloc] init];
    [(GPUImage3x3ConvolutionFilter *)negSinConv setConvolutionKernel:(GPUMatrix3x3){
        {-sinf(M_PI_4),  0.0f, 0.0f},
        {0.0f, -sinf(M_PI_4), 0.0f},
        {0.0f,  0.0f, -sinf(M_PI_4)}
    }];
    
    UIImage *outputImage  = [[UIImage alloc] init];
    
    cv::Mat image1, image2, image3, image4;
    
    UIImage *img = [UIImage imageNamed:@"nicely.jpg"];
    
    cv::Mat grayImage = [CvMatUIImageConverter cvMatGrayFromUIImage:img];
    
    img = [CvMatUIImageConverter UIImageFromCVMat:grayImage];

    
    UIImage *gaussianImage = [gaussian imageByFilteringImage:img];
    UIImage *Ix = [derivativeXConv imageByFilteringImage:gaussianImage];
    UIImage *Iy = [derivativeYConv imageByFilteringImage:gaussianImage];
    
    
    //    UIImage *Ix_45_cos = [cosConv imageByFilteringImage:Ix];
    //    UIImage *Iy_45_sin = [sinConv imageByFilteringImage:Iy];
    
    
    //    cv::Mat cvResult = [CvMatUIImageConverter cvMatGrayFromImage:outputImage];
    cv::Mat cvResult = [CvMatUIImageConverter cvMatGrayFromUIImage:outputImage];
    //    cv::Mat cvIx_cos = [CvMatUIImageConverter cvMatGrayFromUIImage:Ix_45_cos];
    //    cv::Mat cvIy_sin = [CvMatUIImageConverter cvMatGrayFromUIImage:Iy_45_sin];
    
    cv::Mat cv_Ix_ = [CvMatUIImageConverter cvMatFromUIImage:gaussianImage];
    cv::Mat cv_Iy_ = [CvMatUIImageConverter cvMatFromUIImage:gaussianImage];
    cv::Mat cvIx_cos = cv_Ix_*cosf(M_PI_4);
    cv::Mat cvIy_sin = cv_Iy_*-sinf(M_PI_4);
    
    cv::add(cvIx_cos, cvIy_sin, cvResult);
    
    UIImage *I_45 = [CvMatUIImageConverter UIImageFromCVMat:cvResult];
    UIImage *Ixy = [derivativeYConv imageByFilteringImage:I_45];
    //    UIImage *Ixy = [xyFilter imageByFilteringImage:I_45];
    
        UIImage *I_45_x = [derivativeXConv imageByFilteringImage:I_45];
    //    UIImage *I_45_y = [derivativeYConv imageByFilteringImage:I_45];
    
    
    //    I_45_x * cos(-pi/4)
    //    I_45_y * sin(-pi/4)
//        UIImage *I_45_x_cos_n_pi4 = [negCosConv imageByFilteringImage:I_45_x];
    //    UIImage *I_45_y_sin_n_pi4 = [negSinConv imageByFilteringImage:I_45_y];
    
    
    cv::Mat posCos = cv_Ix_*cosf(M_PI_4);
    cv::Mat posSin = cv_Iy_*sinf(M_PI_4);
    
    cv::Mat negCos = cv_Ix_*cosf(-M_PI_4);
    cv::Mat negSin = cv_Iy_*sinf(-M_PI_4);

//    UIImage *I_45_x_cos_n_pi4 = [CvMatUIImageConverter UIImageFromCVMat:negCos];
    UIImage *I_45_y_sin_n_pi4 = [CvMatUIImageConverter UIImageFromCVMat:negSin];
    
    
    
    
    cv::Mat cv_Ixy = [CvMatUIImageConverter cvMatFromUIImage:Ixy];
//    cv::Mat cv_I_45_x_cos_n_pi4 = [CvMatUIImageConverter cvMatFromUIImage:I_45_x_cos_n_pi4];
    cv::Mat cv_I_45_x_cos_n_pi4 = negCos;
    cv::Mat cv_I_45_y_sin_n_pi4 = [CvMatUIImageConverter cvMatFromUIImage:I_45_y_sin_n_pi4];
    
    //    % first derivative at 45 degrees
    //    I_45 = Ix * cos(pi/4) + Iy * sin(pi/4);
    //    I_n45 = Ix * cos(-pi/4) + Iy * sin(-pi/4);
    
    cv::Mat cv_Ix_45;
    cv::Mat cv_Iy_45;
    cv::Mat cv_I_45;
    cv::add(posCos, posSin, cv_I_45);
    
    cv::Mat cv_I_n45;
    cv::add(negCos, negSin, cv_I_n45);
    
    //    I_45_45 = I_45_x * cos(-pi/4) + I_45_y * sin(-pi/4);
    cv::Mat negSum;
    
//    cv::add(negCos, cv_I_n45, negSum);

    cv::Mat cv_cos_n45 = cosf(-M_PI_4)*negCos;
    cv::Mat cv_sin_n45 = sinf(-M_PI_4)*negSin;
    cv::Mat Img_45_45;
    cv::add(cv_cos_n45, cv_sin_n45, Img_45_45);
    
//    cv::add(negCos, cv_I_45_y_sin_n_pi4, negSum);
    cvResult = Img_45_45;

//    cv::add(cv_I_45_x_cos_n_pi4, cv_I_45_y_sin_n_pi4, negSum);
//    cv::add(negCos, cv_I_45_y_sin_n_pi4, negSum);
//    cvResult = I_45_45;

    cv::Mat absIxy = cv::abs(cv_Ixy);
    cv::Mat abs_I_45 = cv::abs(cv_I_45_x_cos_n_pi4);
    cv::Mat abs_I_n45 = cv::abs(cv_I_45_y_sin_n_pi4);
    
    cv::Mat LHS ;
    cv::add(abs_I_45, abs_I_n45, LHS);
    LHS *= 2;
    cv::Mat RHS = 4*absIxy;
    cv::Mat I_n45;
    cv::subtract(RHS, LHS, I_n45);
    // I_n45
    // image1 = I_n45;
    
//    cv::Mat mask = I_n45 <= 0 ;
//    cv::Mat masked = cvResult.setTo(0, cvResult<0 );
//    I_n45 = I_n45.setTo(0, I_n45<= 0);
    
    cv::Mat mask = (I_n45 <= 0);

 
//    I_n45 = I_n45.setTo(0.5,mask);
    cv::Mat nonZeroLocations;
//    cv::findNonZero(I_n45, nonZeroLocations);
//    cv::threshold(I_n45, nonZeroLocations, 0, 1, cv::THRESH_MASK);
    
    
    //    cv::Mat mask = cvResult <= 0 ;
    //    cvResult.setTo(mask);
    //    cv::Mat masked = cvResult.setTo(0, cvResult<0 );
    
    //    Mat im = ReadSomeImage(...);
    //    Mat masked = im.setTo(0,im<0); /// <<<
    
    //    UIImage *cvOutput = [CvMatUIImageConverter UIImageFromCVMat:masked];
    //    c45 = sigma^2 * abs(I_45_45) - sigma * (abs(Ix) + abs(Iy));
//    cv::Mat absI4545 = cv::abs(cv_I_45_45);
    cv::Mat absI4545 = cv::abs(Img_45_45);
    cv::Mat sigmaAbsI4545 = 4*absI4545;
    cv::Mat cv_Ix = [CvMatUIImageConverter cvMatFromUIImage:Ix];
    cv::Mat cv_Iy = [CvMatUIImageConverter cvMatFromUIImage:Iy];
    cv::Mat absIx, absIy;
    absIx = cv::abs(cv_Ix);
    absIy = cv::abs(cv_Iy);
    cv::add(absIx, absIy, LHS);
    LHS *= 2;
    RHS = 4*absI4545;
    cv::Mat cv_c45;
    cv::subtract(RHS, LHS, cv_c45);
    
    image1 = cvResult;
    image2 = cv_c45;
//    UIImage *cvOutput = [CvMatUIImageConverter UIImageFromCVMat:cv_c45];
    [imageView setImage:Ix];
    [imageViewC45 setImage:Iy];
//    [imageViewCxy setImage:[CvMatUIImageConverter UIImageFromCVMat:Img_45_45]]; //cv_I_n45
    [imageViewCxy setImage:[CvMatUIImageConverter UIImageFromCVMat:mask]]; //cv_I_n45
    [imageViewI setImage:[CvMatUIImageConverter UIImageFromCVMat:cv_c45]]; //I_n45
//    [imageViewI setImage:cvOutput];
}

//- (void) returnNoZero  {
////    cv::Mat m = (cv::Mat)n;
////
//////    cv::Mat someMat(1, 4, CV_64F, &someData);;
////    cv::Matiterator_<double> _it = m.begin<double>();
////    for(;_it!=m.end<double>(); _it++){
////        std::cout << *_it << std::endl;
////    }
//    cv::Mat m;
//    for(int i = 0; i < m.rows; i++) {
////        double* mi = m.at<cvScalar>(i);
//        double* mi = m.ptr<CvScalar>(i);
//        
//        
//        for(int j = 0; j < m.cols; j++) {
//            if (mi[j] < 0) {
//                printf("changing [%i, %i] from %8.1f to 0\n", i, j, mi[j]);
//                mi[j] = cvScalar(0,0,0);
//            }
//        }
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
