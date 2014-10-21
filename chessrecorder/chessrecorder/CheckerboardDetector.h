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

namespace CheckDet {
    
    using namespace std;
    using namespace cv;
    
    class Point2fSt : public cv::Point2f {
    public:
        float strength;
        Point2fSt(float x_ = 0, float y_ = 0, float strength_ = 0.0)
        : Point2f(x_, y_), strength(strength_) {}
        
        Point2fSt(Point2fSt const& other) : Point2f(other), strength(other.strength) {}
        
        bool operator==(const Point2fSt& other) const {
            return x == other.x && y == other.y && strength == other.strength;
        }
    };
    
    class LineF {
    public:
        Point2f start;
        Point2f ori;
        
        LineF(float startX_ = 0, float startY_ = 0, float oriX_ = 0, float oriY_ = 0)
        : start(startX_, startY_), ori(oriX_, oriY_) {}
        
        LineF(LineF const& other) : start(other.start), ori(other.ori) {}
        
        LineF& operator=(const LineF & other) {
            start = other.start;
            ori = other.ori;
            
            return *this;
        }
        
        bool operator==(const LineF& other) const {
            return start == other.start && ori == other.ori;
        }

        float distance(Point2f& p) const;
        Point2f delta(Point2f& p) const;
    };
    
    class LineFSt : public LineF {
    public:
        float strength;
        
        LineFSt(float startX_ = 0, float startY_ = 0, float oriX_ = 0, float oriY_ = 0, float strength_ = 0.0)
        : LineF(startX_, startY_, oriX_, oriY_), strength(strength_) {}
        
        LineFSt(LineFSt const& other) : LineF(other), strength(other.strength) {}
        
        LineFSt& operator=(const LineFSt & other) {
            start = other.start;
            ori = other.ori;
            strength = other.strength;
            
            return *this;
        }        
        
        bool operator==(const LineFSt& other) const {
            return start == other.start && ori == other.ori && strength == other.strength;
        }
    };
    
    vector<Point2f> getOuterCheckerboardCorners(Mat& mat);
    vector<Point2fSt> getLooseCheckerboardCorners(Mat& mat);
    vector<LineFSt> getLinesThroughPoints(vector<Point2fSt>& cornerList, int minPointsPerLine = 3, float maxErrorPerPoint = 5);
    vector<LineFSt> getBorderingLines(vector<LineFSt>& lines, vector<Point2fSt>& points, float maxDistancePerPoint = 5);
    vector<Point2f> getIntersections(vector<LineFSt>& lines);
    void drawCrosshair(Mat& mat, Point2i p);
    void drawCrosshair(Mat& mat, Point2i p, int thickness);
    void drawRect(Mat& mat, Point2i p, int size);
    void printMat(const Mat& m);
    void printInfo(const Mat& mat);
    void showTime(const char* msg, bool includeCpuTime);
    
}

#endif /* defined(__img_transform__CheckerboardDetector__) */
