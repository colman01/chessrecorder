//
//  CustomGpuImageVidCam.m
//  chessrecorder
//
//  Created by colman on 26/11/15.
//  Copyright © 2015 Colman Marcus-Quinn. All rights reserved.
//

#import "CustomGpuImageVidCam.h"

@implementation CustomGpuImageVidCam

@synthesize imageFrame;

- (void)processVideoSampleBuffer:( CMSampleBufferRef )sampleBuffer {
    [super processVideoSampleBuffer:sampleBuffer];
    [self imageFromSamplePlanerPixelBuffer:sampleBuffer];
}

// Create a UIImage from sample buffer data
// Works only if pixel format is kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
-(UIImage *) imageFromSamplePlanerPixelBuffer:(CMSampleBufferRef) sampleBuffer{
    
    @autoreleasepool {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer, 0);
        
        // Get the number of bytes per row for the plane pixel buffer
        void *baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
        
        // Get the number of bytes per row for the plane pixel buffer
        size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,0);
        // Get the pixel buffer width and height
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        // Create a device-dependent gray color space
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        
        // Create a bitmap graphics context with the sample buffer data
        CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                     bytesPerRow, colorSpace, kCGImageAlphaNone);
        // Create a Quartz image from the pixel data in the bitmap graphics context
        CGImageRef quartzImage = CGBitmapContextCreateImage(context);
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        
        // Free up the context and color space
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        // Create an image object from the Quartz image
        UIImage *image = [UIImage imageWithCGImage:quartzImage];
        
        // Release the Quartz image
        CGImageRelease(quartzImage);
        
        imageFrame = [UIImage init];
        imageFrame = image;
        
        return (image);
    }
}

//- (void)maxFromImage:(const vImage_Buffer)src toImage:(const vImage_Buffer)dst
//{
//    int kernelSize = 7;
//    vImageMin_Planar8(&src, &dst, NULL, 0, 0, kernelSize, kernelSize, kvImageDoNotTile);
//}

//- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
//    
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    CVPixelBufferLockBaseAddress(imageBuffer, 0);
//    
//    // For the iOS the luma is contained in full plane (8-bit)
//    size_t width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0);
//    size_t height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0);
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
//    
//    Pixel_8 *lumaBuffer = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
//    
//    const vImage_Buffer inImage = { lumaBuffer, height, width, bytesPerRow };
//    
//    Pixel_8 *outBuffer = (Pixel_8 *)calloc(width*height, sizeof(Pixel_8));
//    const vImage_Buffer outImage = { outBuffer, height, width, bytesPerRow };
//    [self maxFromImage:inImage toImage:outImage];
//    
//    CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();
//    CGContextRef context = CGBitmapContextCreate(outImage.data, width, height, 8, bytesPerRow, grayColorSpace, kCGBitmapByteOrderDefault);
//    CGImageRef dstImageFilter = CGBitmapContextCreateImage(context);
//    
//    dispatch_sync(dispatch_get_main_queue(), ^{
////        _customPreviewLayer.contents = (__bridge id)dstImageFilter;
//        super.CALayer.contents = (__bridge id)dstImageFilter;
//    });
//    
//    free(outBuffer);
//    CGImageRelease(dstImageFilter);
//    CGContextRelease(context);
//    CGColorSpaceRelease(grayColorSpace);
//    
//}

@end
