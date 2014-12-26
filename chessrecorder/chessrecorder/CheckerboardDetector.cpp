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

namespace CheckDet {
    
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
        
        //showTime("getCheckerboardCornerHeatmap start", false);
        
        for (int rowIdx = maxRadius; rowIdx < mat.rows - maxRadius; rowIdx++) {
            for (int colIdx = maxRadius; colIdx < mat.cols - maxRadius; colIdx++) {
                result.at<float>(rowIdx, colIdx) = getCheckerboardCornerHeat(mat, rowIdx, colIdx, maxRadius);
            }
        }
        
        //showTime("getCheckerboardCornerHeatmap end", false);
        
        return result;
    }
    
    Point2fSt getBarycenter(Mat& mat, float minHeat, Mat& visited, int row, int col) {
        Point2fSt result(0, 0, 0);
        
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
            result.strength += v;
            
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
        
        result.x /= result.strength;
        result.y /= result.strength;
        
        return result;
    }
    
    vector<Point2fSt> getHeatSourcesForHeatmap(Mat& mat, float minHeat) {
        vector<Point2fSt> result;
        vector<float> weight;
        
        Mat visited = Mat(mat.rows, mat.cols, CV_8UC1, Scalar::all(0)); // 0: not visited, 1: visited
        for (int colIdx = 0; colIdx < mat.cols; colIdx++) {
            for (int rowIdx = 0; rowIdx < mat.rows; rowIdx++) {
                
                if (visited.at<uchar>(rowIdx, colIdx) != 0) {
                    continue;
                }
                visited.at<uchar>(rowIdx, colIdx) = 1;
                
                if (mat.at<float>(rowIdx, colIdx) < minHeat) {
                    continue;
                }
                
                Point2fSt barycenter = getBarycenter(mat, minHeat, visited, rowIdx, colIdx);
                
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
    
    struct Point2fStByStrengthComparator {
        bool operator ()(Point2fSt const& a, Point2fSt const& b) {
            return a.strength > b.strength;
        }
    };
    
    void nthElementByZ(vector<Point2fSt>& vec, size_t n) {
        if (n >= vec.size())
            return;

        Point2f barycenter(0, 0);
        for (int i = 0; i < vec.size(); i++) {
            barycenter += vec[i];
        }
        barycenter *= (1.0/vec.size());
        nth_element(vec.begin(), vec.begin() + n, vec.end(), Point2fStByStrengthComparator());
    }
    
    float firstNAvgStrength(const vector<Point2fSt>& vec, size_t n) {
        vector<Point2fSt>::const_iterator end;
        if (n > vec.size()) {
            n = vec.size();
        }
        end = vec.begin() + n;
        
        float sum = 0;
        for (vector<Point2fSt>::const_iterator it = vec.begin(); it != end; ++it) {
            sum += (*it).strength;
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
    
    float getMinDistancesMedian(vector<Point2fSt>& points, size_t pointIdx, size_t count) {
        assert((count & 1) == 1);
        
        Point2fSt curr = points[pointIdx];
        
        vector<float> minDistancesSqList(count, +10000000);
        
        for (int i = 0; i < points.size(); i++) {
            if (pointIdx != i) {
                Point2fSt other = points[i];
                
                float dx = curr.x - other.x;
                float dy = curr.y - other.y;
                float currDistanceSq = dx*dx + dy*dy;
                
                keepMinSorted(minDistancesSqList, currDistanceSq);
            }
        }
        
        return sqrtf(minDistancesSqList[count / 2]);
    }
    
    float getMedianOfMinDistanceMedians(vector<Point2fSt>& points, size_t minDistanceCount) {
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
    
    void removeFarOutliers(vector<Point2fSt>& points) {
        bool pointsWereRemoved;
        do {
            pointsWereRemoved = false;
            
            float medianOfMedians = getMedianOfMinDistanceMedians(points, 5);
            
            for (int i = 0; i < points.size(); i++) {
                float currMinDistanceMedian = getMinDistancesMedian(points, i, 5);
                
                float ratio = currMinDistanceMedian / medianOfMedians;
                
                if (ratio > 2.0) {
                    points.erase(points.begin() + i);
                    pointsWereRemoved = true;
                }
            }
        } while (pointsWereRemoved);
    }
    
    size_t getNearestIdx(vector<Point2fSt>& points, size_t pointIdx) {
        Point2fSt curr = points[pointIdx];
        
        float minDistanceSq = +10000000;
        size_t minOtherIdx = -1;
        
        for (int i = 0; i < points.size(); i++) {
            if (pointIdx != i) {
                Point2fSt other = points[i];
                
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
    
    void removeCloseInliers(vector<Point2fSt>& points) {
        bool pointsWhereRemoved;
        do {
            pointsWhereRemoved = false;
            
            float minDistancesMedian = getMedianOfMinDistanceMedians(points, 1);
            
            for (int i = 0; i < points.size(); i++) {
                Point2fSt curr = points[i];
                
                for (int j = 0; j < points.size(); j++) {
                    if (i != j) {
                        Point2fSt other = points[j];
                        
                        float dx = curr.x - other.x;
                        float dy = curr.y - other.y;
                        float currDistance = sqrtf(dx*dx + dy*dy);
                        
                        float ratio = currDistance / minDistancesMedian;
                        
                        if (ratio < 0.5) {
                            if (curr.strength >= other.strength) {
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
    
    void applyDistanceFilters(vector<Point2fSt>& points) {
        removeFarOutliers(points);
        removeCloseInliers(points);
    }
    
    vector<Point2f> getOuterCorners(vector<Point2fSt>& points) {
        vector<Point2f> result;
        
        
        
        return result;
    }
    
//    vector<Point2f> convertPointVec3fTo2f(vector<Point2fSt>& src) {
//        vector<Point2f> dst(src.size());
//        
//        vector<Point2fSt>::iterator Point2fStIter = src.begin();
//        vector<Point2fSt>::iterator Point2fStEnd = src.end();
//        vector<Point2f>::iterator point2fIter = dst.begin();
//        for (; Point2fStIter != Point2fStEnd; ++Point2fStIter, ++point2fIter) {
//            *point2fIter = Point2f((*Point2fStIter).x, (*Point2fStIter).y);
//        }
//        
//        return dst;
//    }
    
    Point2f LineF::delta(Point2f& p) const {
        Point2f r = start - p;
        Point2f oriNormed = ori * (1/norm(ori));

        return r - (r.dot(oriNormed) * oriNormed);
    }
    
    float LineF::distance(Point2f& p) const {
        return norm(delta(p));
    }
    
    LineFSt fitLineThroughPoints(vector<Point2fSt>& points) {
        LineFSt result;
        
        if (points.size() == 2) {
            result.start = points[0];
            result.ori = points[1] - points[0];
            result.strength = points[0].strength + points[1].strength;
        } else {
            for (int i = 0; i < points.size(); i++) {
                result.start += points[i];
            }
            result.start.x /= points.size();
            result.start.y /= points.size();
            
            Point2f xPosAvg(0, 0);
            Point2f yPosAvg(0, 0);
            for (int i = 0; i < points.size(); i++) {
                Point2f p = points[i] - result.start;
                
                xPosAvg += (p.x >= 0) ? p : -p;
                yPosAvg += (p.y >= 0) ? p : -p;
            }
            xPosAvg.x /= points.size();
            xPosAvg.y /= points.size();
            yPosAvg.x /= points.size();
            yPosAvg.y /= points.size();

            float normXPosAvg = norm(xPosAvg);
            float normYPosAvg = norm(yPosAvg);
            Point2f ori;
            if (normXPosAvg > normYPosAvg) {
                ori = xPosAvg * (1/normXPosAvg);
            } else {
                ori = yPosAvg * (1/normYPosAvg);
            }
            // TODO: use a better fitting algorithm for the above
            
            float minProjLen = +10000000;
            float maxProjLen = -10000000;
            for (int i = 0; i < points.size(); i++) {
                Point2f p = points[i] - result.start;
                float projLen = p.dot(ori);
                if (projLen < minProjLen) {
                    minProjLen = projLen;
                }
                if (projLen > maxProjLen) {
                    maxProjLen = projLen;
                }
            }
            float lineLen = maxProjLen - minProjLen;
            result.start += ori * minProjLen;
            result.ori = ori * lineLen;

            result.strength = 0;
            for (int i = 0; i < points.size(); i++) {
                float distance = result.distance(points[i]);
                result.strength += points[i].strength / (1 + distance);
            }
            result.strength *= points.size() / abs(lineLen);
        }
        
        return result;
    }
    
    template <typename T> bool contains(vector<T> const& vec, T item) {
        return find(vec.begin(), vec.end(), item) != vec.end();
    }
    
    LineFSt getLineThroughPointsSubset(vector<Point2fSt>& points, int minPointsPerLine, float maxErrorPerPoint, int pairIdx0, int pairIdx1) {        
        vector<size_t> memberIdxs;
        memberIdxs.push_back(pairIdx0);
        memberIdxs.push_back(pairIdx1);
        
        vector<Point2fSt> members;
        members.push_back(points[pairIdx0]);
        members.push_back(points[pairIdx1]);
        
        LineFSt l;
        while (true) {
            l = fitLineThroughPoints(members);
            
            int minDistanceIdx = -1;
            float minDistance = +10000000;
            for (int i = 0; i < points.size(); i++) {
                if (!contains<size_t>(memberIdxs, i)) {
                    float currDistance = l.distance(points[i]);
                    if (currDistance < minDistance) {
                        minDistance = currDistance;
                        minDistanceIdx = i;
                    }
                }
            }
            
            if (minDistanceIdx != -1 && minDistance <= maxErrorPerPoint) {
                //printf("    adding point %i at %5.1f %5.1f (distance: %5.1f)\n", minDistanceIdx, points[minDistanceIdx].x, points[minDistanceIdx].y, minDistance);
                memberIdxs.push_back(minDistanceIdx);
                members.push_back(points[minDistanceIdx]);
            } else {
                break;
            }
        }
        
        if (memberIdxs.size() < minPointsPerLine) {
            return LineFSt(0, 0, 0, 0, -10000000);
        }
        
        return l;
    }
    
    float difference(LineF& l, LineF& k) {
        Point2f lOri = l.ori * (1/norm(l.ori));
        Point2f kOri = k.ori * (1/norm(k.ori));
        
        return l.distance(l.start) + k.distance(l.start) + 10 * abs(lOri.cross(kOri));
    }
    
    vector<LineFSt> getLinesThroughPoints(vector<Point2fSt>& points, int minPointsPerLine, float maxErrorPerPoint) {
        vector<LineFSt> result;
        
        // imagine a line through each pair of points.
        // for each such line, find points very near to this line. with the new points added, recalculate the line.
        for (int i = 0; i < points.size(); i++) {
            for (int j = i + 1; j < points.size(); j++) {
                LineFSt line = getLineThroughPointsSubset(points, minPointsPerLine, maxErrorPerPoint, i, j);
                if (line.strength > 0) {
                    if (!contains(result, line)) {
                        result.push_back(line);
                    }
                }
            }
        }
        
        for (int i = 0; i < result.size(); i++) {
            for (int j = result.size() - 1; j > i; j--) {
                if (difference(result[i], result[j]) < 1) {
                    result.erase(result.begin() + j);
                }
            }
        }
        
        return result;
    }
    
    bool isBorderingLine(LineFSt& line, vector<Point2fSt>& points, float maxDistancePerPoint) {
        bool result = true;
        
        bool firstDeltaFound = false;
        Point2f firstDelta;
        for (int i = 0; i < points.size(); i++) {
            Point2fSt p = points[i];
            Point2f delta = line.delta(p);
            float distance = norm(delta);
            
            if (distance > maxDistancePerPoint) {
                delta *= 1/distance;
                
                if (firstDeltaFound) {
                    float side = firstDelta.dot(delta);
                    if (side < 0) {
                        result = false;
                        break;
                    }
                } else {
                    firstDelta = delta;
                    firstDeltaFound = true;
                }
            }
        }
        
        return result;
    }

    vector<LineFSt> getBorderingLines(vector<LineFSt>& lines, vector<Point2fSt>& points, float maxDistancePerPoint) {
        vector<LineFSt> result;
        
        for (int i = 0; i < lines.size(); i++) {
            LineFSt l = lines[i];
            
            if (isBorderingLine(l, points, maxDistancePerPoint)) {
                result.push_back(l);
            }
        }
        
        return result;
    }
    
    Point2f getIntersection(LineF& l, LineF& k) {
        Point2f result;
        
        float x1 = l.start.x;
        float y1 = l.start.y;
        float x2 = x1 + l.ori.x;
        float y2 = y1 + l.ori.y;
        float x3 = k.start.x;
        float y3 = k.start.y;
        float x4 = x3 + k.ori.x;
        float y4 = y3 + k.ori.y;
        
        float denom = (x1 - x2)*(y3 - y4) - (y1 - y2)*(x3 - x4);
        if (denom == 0) {
            result.x = NAN;
            result.y = NAN;
        } else {
            float a = x1*y2 - y1*x2;
            float b = x3*y4 - y3*x4;
            result.x = (a*(x3 - x4) - (x1 - x2)*b) / denom;
            result.y = (a*(y3 - y4) - (y1 - y2)*b) / denom;
        }
        
        return result;
    }
    
    vector<Point2f> getIntersections(vector<LineFSt>& lines) {
        vector<Point2f> result;
        
        for (int i = 0; i < lines.size(); i++) {
            for (int j = i + 1; j < lines.size(); j++) {
                if (i != j) {
                    Point2f intersection = getIntersection(lines[i], lines[j]);
                    
                    if (!isnan(intersection.x)) {
                        result.push_back(intersection);
                    }
                }
            }
        }
        
        // remove outliers
        while (result.size() > lines.size()) {
            Point2f center(0, 0);
            for (int i = 0; i < result.size(); i++) {
                center += result[i];
            }
            center *= 1.0/result.size();
            
            float maxDistance = -10000000;
            size_t maxDistanceIdx = -1;
            for (int i = 0; i < result.size(); i++) {
                float distance = norm(result[i] - center);
                if (distance > maxDistance) {
                    maxDistance = distance;
                    maxDistanceIdx = i;
                }
            }
            result.erase(result.begin() + maxDistanceIdx);
        }
        
        return result;
    }
    
    struct ClockwiseOrderComparator {
        Point2f center;
        
        ClockwiseOrderComparator(Point2f const& center_) : center(center_) {}
        
        bool operator()(Point2f const& a, Point2f const& b) {
            Point2f r;
            
            r = a - center;
            float alpha = atan2f(-r.y, r.x);
            
            r = b - center;
            float beta = atan2f(-r.y, r.x);
            
            return alpha > beta;
        }
    };
    
    vector<Point2f> orderClockwise(vector<Point2f>& points) {
        Point2f center(0, 0);
        for (int i = 0; i < points.size(); i++) {
            center += points[i];
        }
        center *= (1.0/points.size());
        
        sort(points.begin(), points.end(), ClockwiseOrderComparator(center));
        
        return vector<Point2f>();
    }
    
    vector<Point2f> getOuterCheckerboardCorners(Mat& mat) {
        vector<Point2fSt> cornerList = CheckDet::getLooseCheckerboardCorners(mat);
        vector<LineFSt> lineList = CheckDet::getLinesThroughPoints(cornerList, 3, 5);
        vector<LineFSt> borderingLineList = CheckDet::getBorderingLines(lineList, cornerList, 5);
        vector<Point2f> outerCornerList = CheckDet::getIntersections(borderingLineList);
        
        for (int i = 0; i < lineList.size(); i++) {
            LineFSt l = lineList[i];
//            line(mat, l.start, l.start + l.ori, Scalar(255, 0, 0), 1);
        }
        
        for (int i = 0; i < cornerList.size(); i++) {
            Point2f p = cornerList[i];
//            circle(mat, p, 7, Scalar(0, 255, 0), -1);
        }
        
        for (int i = 0; i < borderingLineList.size(); i++) {
            LineFSt l = borderingLineList[i];
//            line(mat, l.start, l.start + l.ori, Scalar(255, 255, 255), 3);
        }
        
        for (int i = 0; i < outerCornerList.size(); i++) {
            Point2f p = outerCornerList[i];
//            circle(mat, p, 7, Scalar(127, 127, 255), -1);
        }

        orderClockwise(outerCornerList);
        
        return outerCornerList;
    }

    vector<Point2fSt> getLooseCheckerboardCorners(Mat& mat) {
        const int MAX_RADIUS = 8;
        
        Mat tmp;
        
        mat.convertTo(tmp, CV_32FC1);
        cvtColor(tmp, tmp, CV_RGB2GRAY);
        
        tmp = getCheckerboardCornerHeatmap(tmp, MAX_RADIUS);
        
        threshold(tmp, tmp, 0, 0, THRESH_TOZERO);
        normalize(tmp, 255);
        vector<Point2fSt> cornerList = getHeatSourcesForHeatmap(tmp, 150);
        
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
    
}