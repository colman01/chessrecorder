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

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _chessImages = [[NSMutableArray alloc] init];
    }
    [_slider addTarget:self action:@selector(handleValueChanged:event:) forControlEvents:UIControlEventValueChanged];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    self.collectionView = collectionView;
    self.collectionView.allowsSelection = YES;
    
    UIImageView *imgV = [cell viewWithTag:2];
//    UICollectionViewCell *imgV = [cell viewWithTag:1];
    
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

@end
