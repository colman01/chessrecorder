//
//  ShowFramePadViewController.m
//  chessrecorder
//
//  Created by colman on 06/05/16.
//  Copyright © 2016 Colman Marcus-Quinn. All rights reserved.
//

#import "ShowFramePadViewController.h"

@implementation ShowFramePadViewController

static NSString * const reuseIdentifier = @"Cell";

@synthesize board;
@synthesize square;

@synthesize numberOfCorners;
@synthesize meanThres;
@synthesize stdThres;
@synthesize eigenvalue1Thres;
@synthesize eigenvalue2Thres;


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupBoard];
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _chessImages = [[NSMutableArray alloc] init];
    }
    [self configureSliderMethods];
    [self configureSliderRange];
    
    [_slider addTarget:self action:@selector(handleValueChanged:event:) forControlEvents:UIControlEventValueChanged];
    
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    self.collectionView = collectionView;
    self.collectionView.allowsSelection = YES;
    
    UIImageView *imgV = [cell viewWithTag:2];

    
    if (_chessImages) {
        UIImage *image = [_chessImages objectAtIndex:indexPath.row];
        [imgV setImage:image];
    }
    
    
    return cell;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(_chessImages) {
        
        return _chessImages.count;
    }
    else {
        return 10;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"should set values");
    
    [self resetupBoard];
    if(!_newSelection) {
        _newSelection = YES;
    }
}


-(void) setupBoard{
    int side = 30;
    
    for (int i=0; i<8; i++) {
        int x = i*side;
        for (int j=0; j<8; j++) {
            UIImageView *imgView = [[UIImageView alloc] init];
            int y = j*side;
            imgView.image = [UIImage imageNamed:@"AlphaWPawn.tiff"];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            [imgView setFrame:CGRectMake(x, y, side, side)];
            
            [board addSubview:imgView];
        }
    }
    
}

-(void) resetupBoard{
    
    for (UIImageView *imgV in board.subviews) {
        imgV.image = nil;
    }
    
}


- (void) configureSliderRange {
    
    [self.numberOfCorners setMaximumValue:49];
    [self.numberOfCorners setMinimumValue:0];
    
    [self.meanThres setMinimumValue:0.0];
    [self.meanThres setMaximumValue:0.0];
    
}

- (void) configureSliderMethods {
    [numberOfCorners addTarget:self action:@selector(numberOfCornersChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void) numberOfCornersChanged:(UIControlEvents *)event {
    NSLog(@"%f", numberOfCorners.value);
    
}



@end
