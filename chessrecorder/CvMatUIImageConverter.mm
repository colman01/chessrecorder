//
//  CvMatUIImageConverter.m
//  chessrecorder
//
//  Created by Mac on 25.09.14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "CvMatUIImageConverter.h"

@implementation CvMatUIImageConverter

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image {
    return [self cvMatFromUIImage:image type:CV_8UC4];
}

+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    cv::Mat result = [self cvMatFromUIImage:image type:CV_8UC1 colorSpace:colorSpace];
    
    CGColorSpaceRelease(colorSpace);
    
    return result;
}

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image type:(int)type colorSpace:(CGColorSpaceRef)colorSpace{
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    printf("%s: %.1f, %.1f\n", __FUNCTION__, cols, rows);
    
    
    cv::Mat cvMat(rows, cols, type);
    printf("%s: cvMat.step[0]: %zu\n", __FUNCTION__, cvMat.step[0]);
    printf("%s: %.1f, %.1f\n", __FUNCTION__, cols, rows);
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
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

+ (UIImage*) UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

@end
