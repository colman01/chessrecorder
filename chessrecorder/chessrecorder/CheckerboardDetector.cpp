//
//  CheckerboardDetector.cpp
//
//  Created by Daniel Strecker on 03.10.14.
//  Copyright (c) 2014 Daniel Strecker. All rights reserved.
//

#include "CheckerboardDetector.h"

using namespace std;
using namespace cv;


#define CUBE_255_DIAGONAL 441.6729559300 //sqrt(255^2*3)

void copyMat(Mat& src, Mat& dst, Point2i p) {
    Mat roi = dst.rowRange(p.y, p.y + src.rows);
    roi = roi.colRange(p.x, p.x + src.cols);
    src.copyTo(roi);
}

// maps to the interval [-PI, +PI)
inline float angularDiff(float start, float end) {
    float d = fmodf(end - start, 2*M_PI);
    
    if (d < -M_PI) {
        return d + 2*M_PI;
    } else if (d < M_PI) {
        return d;
    } else {
        return d - 2*M_PI;
    }
}

// strokes for sizes:
//  3 3 3 3 3 3 3
//  3 2 2 2 2 2 3
//  3 2 1 1 1 2 3
//  3 2 1 0 1 2 3
//  3 2 1 1 1 2 3
//  3 2 2 2 2 2 3
//  3 3 3 3 3 3 3
//
// result len: max(r * 8, 1)
Mat extractRectStroke(const Mat& mat, int rowIdx, int colIdx, int size) {
    int len = MAX(4 * (2 * size), 1);
    Mat result(1, len, mat.type(), Scalar(0));
    Mat extracted;
    
    if (size == 0) {
        extracted = mat.rowRange(rowIdx, rowIdx + 1).colRange(colIdx, colIdx + 1);
        extracted.copyTo(result);
        return result;
    }
    
    int c1 = colIdx - size;
    int c2 = colIdx + size;
    int r1 = rowIdx - size;
    int r2 = rowIdx + size;
    
    // top
    extracted = mat.rowRange(r1, r1 + 1).colRange(c1, c2).clone();
    copyMat(extracted, result, Point2i(0, 0));
    
    // right
    extracted = mat.rowRange(r1, r2).colRange(c2, c2 + 1).clone();
    transpose(extracted, extracted);
    copyMat(extracted, result, Point2i(2 * size, 0));
    
    // bottom
    extracted = mat.rowRange(r2, r2 + 1).colRange(c1 + 1, c2 + 1).clone();
    flip(extracted, extracted, 1);
    copyMat(extracted, result, Point2i(4 * size, 0));
    
    // left
    extracted = mat.rowRange(r1 + 1, r2 + 1).colRange(c1, c1 + 1).clone();
    transpose(extracted, extracted);
    flip(extracted, extracted, 1);
    copyMat(extracted, result, Point2i(6 * size, 0));
    
    return result;
}

vector<float> getEdgeStrengthList(const Mat& rowVector) {
    vector<float> result(rowVector.cols);
    
    Scalar prev = rowVector.at<Scalar_<uchar>>(0, rowVector.cols - 1);
    for (int i = 0; i < rowVector.cols; i++) {
        Scalar curr = rowVector.at<Scalar_<uchar>>(0, i);
        
        Scalar delta = curr - prev;
        result[i] = (float)norm(delta);
        
        prev = curr;
    }
    
    return result;
}

template <typename T>
vector<size_t> getExtremumIndices(const vector<T> v, size_t count, bool minimum) {
    typedef typename vector<T>::const_iterator vectorT_iter;
    
    typedef pair<size_t, vectorT_iter> pair_idx_T;
    
    vector<pair_idx_T> sorted(v.size());
    size_t idx = 0;
    for (vectorT_iter it = v.begin(); it != v.end(); ++it, ++idx) {
        sorted[idx] = make_pair(idx, it);
    }
    
    struct comp_asc {
        bool operator ()(pair<size_t, vectorT_iter> const& a, pair<size_t, vectorT_iter> const& b) {
            return *(a.second) < (*(b.second));
        }
    };
    struct comp_dsc {
        bool operator ()(pair<size_t, vectorT_iter> const& a, pair<size_t, vectorT_iter> const& b) {
            return *(a.second) > (*(b.second));
        }
    };
    
    if (minimum) {
        nth_element(sorted.begin(), sorted.begin() + count, sorted.end(), comp_asc());
    } else {
        nth_element(sorted.begin(), sorted.begin() + count, sorted.end(), comp_dsc());
    }
    
    vector<size_t> result(count);
    for (int i = 0; i < count; i++) {
        result[i] = sorted[i].first;
    }
    
    return result;
}

/**
 * Takes two lists and finds the offset for the matchee for which the two lists are as similar
 * as possible. More precisely, it find the offset so that the following is minimal:
 *
 * sum((reference[i]-matchee[(offset+i) % size]) ^ 2)
 *
 * is minimal, based on a round value interval of [0, 2*PI); i.e. 0 and 1 are the same point.
 */
int getBestMatchingOffset(vector<float> reference, vector<float> matchee) {
    assert(reference.size() == matchee.size());
    
    float minError = 100000000;
    int minErrorOffset = -1;
    
    for (int offset = 0; offset < reference.size(); offset++) {
        float error = 0;
        for (int i = 0; i < reference.size(); i++) {
            float delta = angularDiff(reference[i], matchee[(offset + i) % reference.size()]);
            error += delta*delta;
        }

        if (error < minError) {
            minError = error;
            minErrorOffset = offset;
        }
    }

    return minErrorOffset;
}

typedef enum {
    sumResponse,
    diffResponse,
    meanResponse,
    allCombined,
} JuctionErrorType;

float getJuctionError(Mat& mat, int rowIdx, int colIdx, int edgeCount, int maxRectStrokeSiz, int errorType) {
    float diffError = 0;
    float sumError = 0;
    float meanError = 0;
    
    Mat localMeanMat = mat.rowRange(rowIdx - 1, rowIdx + 3).colRange(colIdx - 1, colIdx + 3);
    Scalar localMean = mean(localMeanMat);
    
    for (int r = 3; r <= maxRectStrokeSiz; r += 1) {
        Mat stroke = extractRectStroke(mat, rowIdx, colIdx, r);
        
        Mat strokePart0 = stroke.colRange(0, stroke.cols / 2);
        Mat strokePart1 = stroke.colRange(stroke.cols / 2, stroke.cols);
        Mat oppositeDiff = strokePart0 - strokePart1;
        float diffResponse = norm(sum(abs(oppositeDiff)));
        
        Mat oppositeSum = strokePart0 + strokePart1;
        Mat oppositeSumPart0 = oppositeSum.colRange(0, oppositeSum.cols / 2);
        Mat oppositeSumPart1 = oppositeSum.colRange(oppositeSum.cols / 2, oppositeSum.cols);
        Mat orthogonalDiff = oppositeSumPart0 - oppositeSumPart1;
        float sumResponse = norm(sum(abs(orthogonalDiff)));
        
        Scalar strokeMean = mean(stroke);
        float meanResponse = norm(localMean - strokeMean) * stroke.cols / 2;
        
        sumError += sumResponse;
        diffError += diffResponse;
        meanError += meanResponse;
    }
//    sumError /= 2;
//    diffError /= 2;
//    meanError /= 2;
    
    switch (errorType) {
        case sumResponse:
            return sumError;
        case diffResponse:
            return diffError;
        case meanResponse:
            return meanError;
        case allCombined:
            return sumError - diffError - meanError;
        default:
            return 0;
    }
}

Mat getJunctionMat(Mat& mat, int maxRectStrokeSize, int edgeCount) {
    Mat result(mat.rows, mat.cols, mat.type(), Scalar(0));
    
    int prevPercent = -1;
    
    printf("|");
    for (int i = 0; i < 50; i++) {
        printf("-");
    }
    printf("|\n");
    
    printf("|");
    for (int rowIdx = maxRectStrokeSize; rowIdx < mat.rows - maxRectStrokeSize; rowIdx++) {
        int percent = rowIdx * 100 / (mat.rows - 2 * maxRectStrokeSize);
        if (percent != prevPercent && (percent % 2 == 0)) {
            printf(">");
            prevPercent = percent;
        }
        
        for (int colIdx = maxRectStrokeSize; colIdx < mat.cols - maxRectStrokeSize; colIdx++) {
            float error = getJuctionError(mat, rowIdx, colIdx, edgeCount, maxRectStrokeSize, allCombined);
            
            float v = 0.05 * error;
            result.at<float>(rowIdx, colIdx) = v;
        }
    }
    printf("|\n");
    
    return result;
}

void printInfo(const Mat& mat) {
    printf("(%ix%i); type, channels, depth: %i, %i, %i\n", mat.rows, mat.cols, mat.type(), mat.channels(), mat.depth());
}

vector<Point2f> getCheckerboardJunctions(Mat& mat) {
    const int MAX_RECTSTROKE_SIZE = 8;
    int EDGE_COUNT = 4; // 2: straight edge; 4: checkerboard; 6: triangles, ...

    
    mat.convertTo(mat, CV_32FC1);
    cvtColor(mat, mat, CV_RGB2GRAY);

    int x = 425 - 100;
    int y = 288 - 100;
    Mat roi = mat.rowRange(y, y + 400).colRange(x, x + 400);
    Mat junctionMat = getJunctionMat(roi, MAX_RECTSTROKE_SIZE, EDGE_COUNT);
    copyMat(junctionMat, mat, Point2i(x, y));

//    mat = getJunctionMat(mat, MAX_RECTSTROKE_SIZE, EDGE_COUNT);

//    mat.at<Scalar_<uchar>>(105 - 1, 105 - 1) = Scalar(x, 0, 0);
//    mat.at<Scalar_<uchar>>(105 - 1, 105    ) = Scalar(0, x, 0);
//    mat.at<Scalar_<uchar>>(105 - 1, 105 + 1) = Scalar(0, 0, x); x += 64;
//    mat.at<Scalar_<uchar>>(105    , 105 + 1) = Scalar(x, 0, 0);
//    mat.at<Scalar_<uchar>>(105 + 1, 105 + 1) = Scalar(0, x, 0);
//    mat.at<Scalar_<uchar>>(105 + 1, 105    ) = Scalar(0, 0, x); x += 64;
//    mat.at<Scalar_<uchar>>(105 + 1, 105 - 1) = Scalar(x, 0, 0);
//    mat.at<Scalar_<uchar>>(105    , 105 - 1) = Scalar(0, x, 0);
//    
//    mat.at<Scalar_<uchar>>(105    , 105    ) = Scalar(0, 0, 64*4-1);
//    
//    Mat stroke = extractRectStroke(mat, 105, 105, 1);
//    resize(stroke, stroke, Size(512, 40), 0, 0, INTER_NEAREST);
//    copyMat(stroke, mat, Point2i(0, 0));

    cvtColor(mat, mat, CV_GRAY2RGBA);
    mat.convertTo(mat, CV_8UC4);
    
    return vector<Point2f>(0);
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

void drawRect(Mat& mat, Point2i p, int size) {
    Scalar color = Scalar(0, 255, 0, 255);
    
    Point2i s(p.x - size, p.y - size);
    Point2i e(p.x + size, p.y + size);

    rectangle(mat, s, e, color);
}

void drawCrosshair(Mat& mat, Point2i p) {
    drawCrosshair(mat, p, 2);
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
