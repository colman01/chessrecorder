//
//  CvMatUIImageConverter.m
//  chessrecorder
//
//  Created by Mac on 25.09.14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "CvMatUIImageConverter.h"

@implementation CvMatUIImageConverter

+ (cv::Mat) cvMatFromUIImage:(UIImage *)image {
    cv::Mat result = [self cvMatFromUIImage:image type:CV_8UC4];
    return result;
}

+ (cv::Mat) cvMatGrayFromUIImage:(UIImage *)image {
    cv::Mat result = [self cvMatFromUIImage:image type:CV_8UC1];
    return result;
}

+ (cv::Mat) cvMatFromUIImage:(UIImage *)image type:(int)type {
    CGColorSpaceRef colorSpace;
    
    if (type == CV_8UC4) {
        colorSpace = CGImageGetColorSpace(image.CGImage);
    } else if (type == CV_8UC1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    }
    
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, type);
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    (type == CV_8UC4 ? kCGImageAlphaNoneSkipLast : 0) |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);

    return cvMat;
}

+ (UIImage*) UIImageFromCVMat:(cv::Mat)cvMat {
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
