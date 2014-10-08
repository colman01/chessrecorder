//
//  CheckerboardDetector.h
//  img_transform
//
//  Created by Mac on 03.10.14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#ifndef __img_transform__CheckerboardDetector__
#define __img_transform__CheckerboardDetector__

#include <stdio.h>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

vector<Point2f> getCheckerboardJunctions(Mat& mat);
void drawCrosshair(Mat& mat, Point2i p);
void drawCrosshair(Mat& mat, Point2i p, int thickness);
void drawRect(Mat& mat, Point2i p, int size);
void printMat(const Mat& m);
void printInfo(const Mat& mat);

#endif /* defined(__img_transform__CheckerboardDetector__) */
