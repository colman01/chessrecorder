//
//  FilterPreviewCollectionViewController.h
//  chessrecorder
//
//  Created by colman on 23/09/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>

typedef enum {
    ORIG,
    FOUND_CORNERS,
    TRANSFERED

} ImageFilterType;

@interface FilterPreviewCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property ImageFilterType *imageFilterType;


@property NSMutableArray *origImages;
@property NSMutableArray *foundCornersImages;
@property NSMutableArray *transformedImages;



@end
