//
//  CheckerboardDetector.cpp
//
//  Created by Daniel Strecker on 03.10.14.
//  Copyright (c) 2014 Daniel Strecker. All rights reserved.
//

#include "CheckerboardDetector.h"
#include <unistd.h>
#include <sys/time.h>
#include <algorithm>

using namespace std;
using namespace cv;

float getCheckerboardCornerHeat(Mat& mat, int rowIdx, int colIdx, int maxRadius) {
    float diffResponse = 0;
    float sumResponse = 0;
    float meanResponse = 0;
    
    Mat localMeanMat = mat.rowRange(rowIdx - 1, rowIdx + 3).colRange(colIdx - 1, colIdx + 3);
    float localMean = norm(mean(localMeanMat));
    
    // unoptimized but readable code
//    for (int r = 3; r <= maxRadius; r++) {
//        int sideLen = 2 * r;
//        
//        int row0 = rowIdx - r;
//        int row1 = rowIdx + r;
//        int col0 = colIdx - r;
//        int col1 = colIdx + r;
//        
//        float strokeMean = 0;
//        for (int i = 0; i < sideLen; i++) {
//            float v0 = mat.at<float>(row0, col0 + i); // top
//            float v1 = mat.at<float>(row0 + i, col1); // right
//            float v2 = mat.at<float>(row1, col1 - i); // bottom
//            float v3 = mat.at<float>(row1 - i, col0); // left
//            
//            sumResponse += abs(v0 + v2 - (v1 + v3));
//            diffResponse += abs(v0 - v2) + abs(v1 - v3);
//            strokeMean += v0 + v2 + v1 + v3;
//        }
//        strokeMean /= 4 * sideLen;
//        
//        float strokeMeanResponse = abs(localMean - strokeMean) * 2 * sideLen;
//        
//        meanResponse += strokeMeanResponse;
//    }

    // optimized code
    for (int radius = 3; radius <= maxRadius; radius++) {
        int row0 = rowIdx - radius;
        int row1 = rowIdx + radius;
        int col0 = colIdx - radius;
        int col1 = colIdx + radius;
        
        float strokeMean = 0;
        float* topPtr = mat.ptr<float>(row0) + col0;
        float* botPtr = mat.ptr<float>(row1) + col1;
        float* rigPtr = mat.ptr<float>(row0) + col1;
        float* lefPtr = mat.ptr<float>(row1) + col0;
        float* topEnd = rigPtr;
        int cols = mat.cols;
        
        if (mat.isContinuous()) {
            for (; topPtr < topEnd;) {
                sumResponse += abs(*topPtr + *botPtr - (*rigPtr + *lefPtr));
                diffResponse += abs(*topPtr - *botPtr) + abs(*rigPtr - *lefPtr);
                strokeMean += *topPtr + *botPtr + (*rigPtr + *lefPtr);
                
                topPtr++;
                botPtr--;
                
                rigPtr += cols;
                lefPtr -= cols;
            }
        } else {
            for (; topPtr < topEnd;) {
                sumResponse += abs(*topPtr + *botPtr - (*rigPtr + *lefPtr));
                diffResponse += abs(*topPtr - *botPtr) + abs(*rigPtr - *lefPtr);
                strokeMean += *topPtr + *botPtr + (*rigPtr + *lefPtr);
                
                topPtr++;
                botPtr--;
                row0++;
                row1--;
                rigPtr = mat.ptr<float>(row0) + col1;
                lefPtr = mat.ptr<float>(row1) + col0;
            }
        }
        strokeMean /= 4 * (2 * radius);
        
        meanResponse += abs(localMean - strokeMean) * 4 * (2 * radius);
    }

    return sumResponse - diffResponse - meanResponse;
}

Mat getCheckerboardCornerHeatmap(Mat& mat, int maxRadius) {
    Mat result(mat.rows, mat.cols, mat.type(), Scalar(0));
    
    showTime("getCheckerboardCornerHeatmap start", false);
    
    for (int rowIdx = maxRadius; rowIdx < mat.rows - maxRadius; rowIdx++) {
        for (int colIdx = maxRadius; colIdx < mat.cols - maxRadius; colIdx++) {
            result.at<float>(rowIdx, colIdx) = getCheckerboardCornerHeat(mat, rowIdx, colIdx, maxRadius);
        }
    }
    
    showTime("getCheckerboardCornerHeatmap end", false);
    
    return result;
}

Point3f getBarycenter(Mat& mat, float minHeat, Mat& visited, int row, int col) {
    Point3f result(0, 0, 0);

    vector<Point2i> fresh;
    fresh.push_back(Point2i(col, row));
    
    while (!fresh.empty()) {
        Point2i p = fresh.back();
        fresh.pop_back();
        
        float v = mat.at<float>(p);
        if (v < minHeat) {
            continue;
        }
        
        result.x += p.x * v;
        result.y += p.y * v;
        result.z += v;
        
        Point2i childPointList[8];
        childPointList[0] = Point2i(p.x - 1, p.y    );
        childPointList[1] = Point2i(p.x + 1, p.y    );
        childPointList[2] = Point2i(p.x    , p.y - 1);
        childPointList[3] = Point2i(p.x    , p.y + 1);
        childPointList[4] = Point2i(p.x - 1, p.y - 1);
        childPointList[5] = Point2i(p.x + 1, p.y - 1);
        childPointList[6] = Point2i(p.x + 1, p.y + 1);
        childPointList[7] = Point2i(p.x - 1, p.y + 1);
        for (Point2i* childPointPtr = childPointList; childPointPtr < childPointList + 8; childPointPtr++) {
            if ((*childPointPtr).x > 0 && (*childPointPtr).x < mat.cols) {
                if ((*childPointPtr).y > 0 && (*childPointPtr).y < mat.rows) {
                    if (visited.at<uchar>(*childPointPtr) == 0) {
                        visited.at<uchar>(*childPointPtr) = 1;
                        fresh.push_back(*childPointPtr);
                    }
                }
            }
        }
    }
    
    result.x /= result.z;
    result.y /= result.z;
    
    return result;
}

vector<Point3f> getHeatSourcesForHeatmap(Mat& mat, float minHeat) {
    vector<Point3f> result;
    vector<float> weight;
    
    Mat visited = Mat(mat.rows, mat.cols, CV_8UC1, Scalar::all(0)); // 0: not visited, 1: visited
    for (int rowIdx = 0; rowIdx < mat.rows; rowIdx++) {
        for (int colIdx = 0; colIdx < mat.cols; colIdx++) {
            
            if (visited.at<uchar>(rowIdx, colIdx) != 0) {
                continue;
            }
            visited.at<uchar>(rowIdx, colIdx) = 1;
            
            if (mat.at<float>(rowIdx, colIdx) < minHeat) {
                continue;
            }
            
            Point3f barycenter = getBarycenter(mat, minHeat, visited, rowIdx, colIdx);
            
            result.push_back(barycenter);
        }
    }
    
    return result;
}

void printInfo(const Mat& mat) {
    printf("(%ix%i); type, channels, depth: %i, %i, %i\n", mat.rows, mat.cols, mat.type(), mat.channels(), mat.depth());
}

template <typename T> void applySomething(Mat& m) {
    int rowCount = m.rows;
    int colCount = m.cols * m.channels();
    
    // in case of continuous matrix, we effectively only use the inner for loop
    if (m.isContinuous()) {
        colCount *= rowCount;
        rowCount = 1;
    }
    
    T* p;
    T* rowEnd;
    for(int i = 0; i < rowCount; ++i) {
        p = m.ptr<T>(i);
        rowEnd = p + colCount;
        
        for (; p != rowEnd; p++) {
            if (*p != 0) *p = 255;
            //*p = sqrt(*p);
        }
    }
}

struct Point3fByZComparator {
    bool operator ()(Point3f const& a, Point3f const& b) {
        return a.z > b.z;
    }
};

void nthElementByZ(vector<Point3f>& vec, size_t n) {
    if (n >= vec.size())
        return;
    
    nth_element(vec.begin(), vec.begin() + n, vec.end(), Point3fByZComparator());
}

float avgZ_tillN(const vector<Point3f>& vec, size_t n) {
    vector<Point3f>::const_iterator end;
    if (n > vec.size()) {
        n = vec.size();
    }
    end = vec.begin() + n;
    
    float sum = 0;
    for (vector<Point3f>::const_iterator it = vec.begin(); it != end; ++it) {
        sum += (*it).z;
    }
    
    return sum / n;
}

void normalize(Mat& m, float norm) {
    double min, max;
    minMaxIdx(m, &min, &max);
    
    m *= norm / MAX(max, abs(min));
}

void plotFirstRow(Mat& src, Mat& dst, int yOffset) {
    float barW = dst.cols / (float)src.cols;
    for (int i = 0; i < src.cols; i++) {
        float v = src.at<float>(0, i);
        
        Scalar color;
        if (i < 49) {
            color = Scalar(255, 0, 0);
        } else {
            color = Scalar(0, 255, 0);
        }
        
        int x0 = i * barW;
        int x1 = x0 + barW;
        int y1 = yOffset;
        int y0 = yOffset - v;
        if (y0 > y1) {
            int tmp = y1;
            y1 = y0;
            y0 = tmp;
        }
        if (y0 != y1) {
            dst.rowRange(y0, y1).colRange(x0, x1) = color;
        }
    }
}

template <typename T> Mat combineMats(Mat& m, Mat& o) {
    assert(o.rows == m.rows);
    assert(o.cols == m.cols);
    assert(o.type() == m.type());
    assert(o.channels() == m.channels());
    
    Mat result(m.rows, m.cols, m.type());
    
    int rowCount = m.rows;
    int colCount = m.cols * m.channels();
    
    // in case of continuous matrix, we effectively only use the inner for loop
    if (m.isContinuous() && o.isContinuous() && result.isContinuous()) {
        colCount *= rowCount;
        rowCount = 1;
    }
    
    T* pm;
    T* po;
    T* pr;
    T* rowEnd;
    for(int i = 0; i < rowCount; ++i) {
        pm = m.ptr<T>(i);
        po = o.ptr<T>(i);
        pr = result.ptr<T>(i);
        
        rowEnd = pm + colCount;
        for (; pm != rowEnd; pm++, po++, pr++) {
            if ((*pm) != 0) {
                *pr = *pm;
            } else {
                *pr = *po;
            }
        }
    }
    
    return result;
}

Mat scaleMat(Mat& src, cv::Size dstSize) {
    Mat dst(dstSize, src.type());
    
    for (int i = 0; i < dst.rows; i++) {
        for (int j = 0; j < dst.cols; j++) {
            dst.at<float>(i, j) = src.at<float>(i * src.rows / dst.rows, j * src.cols / dst.cols);
        }
    }

    return dst;
}

void drawMatToMat(Mat& src, Mat& dst, Point2i dstPos, Size2i dstSize) {
    int dstXStart = dstPos.x;
    int dstYStart = dstPos.y;
    int dstXEnd = dstPos.x + dstSize.width;
    int dstYEnd = dstPos.y + dstSize.height;
    
    if (dstXStart < 0) {
        dstXStart = 0;
    }
    if (dstYStart < 0) {
        dstYStart = 0;
    }
    if (dstXEnd > dst.cols) {
        dstXEnd = dst.cols;
    }
    if (dstYEnd > dst.rows) {
        dstYEnd = dst.rows;
    }
    
    for (int dstY = dstYStart; dstY < dstYEnd; dstY++) {
        for (int dstX = dstXStart; dstX < dstXEnd; dstX++) {
            
        }
    }
}

void keepMinSorted(vector<float>& vec, float v) {
    vector<float>::iterator bound = lower_bound(vec.begin(), vec.end(), v);
    
    if (bound < vec.end()) {
        vec.pop_back();
        vec.insert(bound, v);
    }
}

float getMinDistancesMedian(vector<Point3f>& points, size_t pointIdx, size_t count) {
    assert((count & 1) == 1);
    
    Point3f curr = points[pointIdx];
    
    vector<float> minDistancesSqList(count, FLT_MAX);
    
    for (int i = 0; i < points.size(); i++) {
        if (pointIdx != i) {
            Point3f other = points[i];
            
            float dx = curr.x - other.x;
            float dy = curr.y - other.y;
            float currDistanceSq = dx*dx + dy*dy;
            
            keepMinSorted(minDistancesSqList, currDistanceSq);
        }
    }
    
    return sqrtf(minDistancesSqList[count / 2]);
}

float getMedianOfMinDistanceMedians(vector<Point3f>& points, size_t minDistanceCount) {
    vector<float> minDistancesMedians(points.size());
    
    for (int i = 0; i < points.size(); i++) {
        minDistancesMedians[i] = getMinDistancesMedian(points, i, 5);
    }
    
    sort(minDistancesMedians.begin(), minDistancesMedians.end());
    
    float medianOfMedians = minDistancesMedians[minDistancesMedians.size() / 2];
    
    return medianOfMedians;
}

Mat vecToMat(vector<float> vec) {
    Mat result(1, vec.size(), CV_32FC1);
    
    for (int i = 0; i < vec.size(); i++) {
        result.at<float>(0, i) = vec[i];
    }
    
    return result;
}

void removeFarOutliers(vector<Point3f>& points) {
    bool pointsWhereRemoved;
    do {
        pointsWhereRemoved = false;
        
        float medianOfMedians = getMedianOfMinDistanceMedians(points, 5);
        
        for (int i = 0; i < points.size(); i++) {
            float currMinDistanceMedian = getMinDistancesMedian(points, i, 5);
            
            float ratio = currMinDistanceMedian / medianOfMedians;
            
            if (ratio > 2.0) {
                points.erase(points.begin() + i);
                pointsWhereRemoved = true;
            }
        }
    } while (pointsWhereRemoved);
}

size_t getNearestIdx(vector<Point3f>& points, size_t pointIdx) {
    Point3f curr = points[pointIdx];
    
    float minDistanceSq = FLT_MAX;
    size_t minOtherIdx = -1;
    
    for (int i = 0; i < points.size(); i++) {
        if (pointIdx != i) {
            Point3f other = points[i];
            
            float dx = curr.x - other.x;
            float dy = curr.y - other.y;
            float currDistanceSq = dx*dx + dy*dy;

            if (currDistanceSq < minDistanceSq) {
                minDistanceSq = currDistanceSq;
                minOtherIdx = i;
            }
        }
    }
    
    return minOtherIdx;
}

void removeCloseInliers(vector<Point3f>& points) {
    bool pointsWhereRemoved;
    do {
        pointsWhereRemoved = false;
        
        float minDistancesMedian = getMedianOfMinDistanceMedians(points, 1);
        
        for (int i = 0; i < points.size(); i++) {
            Point3f curr = points[i];
            
            for (int j = 0; j < points.size(); j++) {
                if (i != j) {
                    Point3f other = points[j];
                    
                    float dx = curr.x - other.x;
                    float dy = curr.y - other.y;
                    float currDistance = sqrtf(dx*dx + dy*dy);
                    
                    float ratio = currDistance / minDistancesMedian;
                    
                    if (ratio < 0.5) {
                        if (curr.z >= other.z) {
                            points.erase(points.begin() + j);
                            j--;
                        } else {
                            points.erase(points.begin() + i);
                            i--;
                        }
                        pointsWhereRemoved = true;
                    }
                }
            }
        }
    } while (pointsWhereRemoved);
}

void applyDistanceFilters(vector<Point3f>& points) {
    removeFarOutliers(points);
    removeCloseInliers(points);
}

vector<Point2f> getOuterCorners(vector<Point3f>& points) {
    vector<Point2f> result;
    
    
    
    return result;
}

vector<Point3f> getCheckerboardCorners(Mat& mat) {
    const int MAX_RADIUS = 8;
    
    Mat tmp;
    
    mat.convertTo(tmp, CV_32FC1);
    cvtColor(tmp, tmp, CV_RGB2GRAY);
    
    tmp = getCheckerboardCornerHeatmap(tmp, MAX_RADIUS);

    threshold(tmp, tmp, 0, 0, THRESH_TOZERO);
    normalize(tmp, 255);
    vector<Point3f> cornerList = getHeatSourcesForHeatmap(tmp, 127);
    
    applyDistanceFilters(cornerList);
    
    return cornerList;
}

void drawCrosshair(Mat& mat, Point2i p, int thickness) {
    int hairLen = 20;
    Scalar color = Scalar(0, 255, 0);
    
    Point2i s, e;
    
    s = Point2i(p.x - hairLen / 2, p.y);
    e = Point2i(p.x + hairLen / 2, p.y);
    line(mat, s, e, color, thickness);
    
    s = Point2i(p.x, p.y - hairLen / 2);
    e = Point2i(p.x, p.y + hairLen / 2);
    line(mat, s, e, color, thickness);
}

void drawCrosshair(Mat& mat, Point2i p) {
    drawCrosshair(mat, p, 2);
}

void drawRect(Mat& mat, Point2i p, int size) {
    Scalar color = Scalar(0, 255, 0, 255);
    
    Point2i s(p.x - size, p.y - size);
    Point2i e(p.x + size, p.y + size);

    rectangle(mat, s, e, color);
}

void printMat(Mat& m) {
    printf("(%ix%i) =\n", m.rows, m.cols);
    
    for (int i = 0; i < m.rows; i++) {
        printf("    ( ");
        
        for (int j = 0; j < m.cols; j++) {
            if (m.depth() < CV_32F) {
                Vec4b e;
                
                if (m.channels() == 1) {
                    uchar e_ = m.at<uchar>(i, j);
                    e = Vec4b(e_, 0, 0, 0);
                } else if (m.channels() == 2) {
                    Vec2b e_ = m.at<Vec2b>(i, j);
                    e = Vec4b(e_[0], e_[1], 0, 0);
                } else if (m.channels() == 3) {
                    Vec3b e_ = m.at<Vec3b>(i, j);
                    e = Vec4b(e_[0], e_[1], e_[2], 0);
                } else if (m.channels() == 4) {
                    e = m.at<Vec4b>(i, j);
                } else {
                    assert(false);
                }
                
                for (int c = 0; c < m.channels(); c++) {
                    printf("%i%s", e[c], c < m.channels() - 1 ? "," : " ");
                }
            } else if (m.depth() == CV_32F) {
                Vec4f e;
                
                if (m.channels() == 1) {
                    float e_ = m.at<float>(i, j);
                    e = Vec4f(e_, 0, 0, 0);
                } else if (m.channels() == 2) {
                    Vec2f e_ = m.at<Vec2f>(i, j);
                    e = Vec4f(e_[0], e_[1], 0, 0);
                } else if (m.channels() == 3) {
                    Vec3f e_ = m.at<Vec3f>(i, j);
                    e = Vec4f(e_[0], e_[1], e_[2], 0);
                } else if (m.channels() == 4) {
                    e = m.at<Vec4f>(i, j);
                } else {
                    assert(false);
                }
                
                for (int c = 0; c < m.channels(); c++) {
                    printf("%5.1f%s", e[c], c < m.channels() - 1 ? "," : " ");
                }
            } else {
                assert(false);
            }
        }
        
        printf(")\n");
    }
}

void showTime(const char* msg, bool includeCpuTime) {
    static time_t c = clock();
    static timeval t1 = {0};
    
    timeval t2;
    gettimeofday(&t2, NULL);

    double wallTimeDiff;
    if (t1.tv_sec != 0) {
        wallTimeDiff = (t2.tv_sec - t1.tv_sec) * 1000 + (double)(t2.tv_usec - t1.tv_usec) / 1000;
    } else {
        wallTimeDiff = 0;
    }
    
    if (includeCpuTime) {
        float cpuTimeDiff = (clock() - c) * 1000 / (float)CLOCKS_PER_SEC;
        printf("%-40s (wall, cpu): %9.3f, %9.3f\n", msg, wallTimeDiff, cpuTimeDiff);
    } else {
        printf("%-40s: %9.3f\n", msg, wallTimeDiff);
    }
    
    gettimeofday(&t1, NULL);
    c = clock();
}
