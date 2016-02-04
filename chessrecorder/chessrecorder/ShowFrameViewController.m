//
//  ShowFrameViewController.m
//  chessrecorder
//
//  Created by colman on 26/11/15.
//  Copyright © 2015 Colman Marcus-Quinn. All rights reserved.
//

#import "ShowFrameViewController.h"

@interface ShowFrameViewController ()

@end

@implementation ShowFrameViewController

static NSString * const reuseIdentifier = @"Cell";

@synthesize imgView;
@synthesize subView;
@synthesize chessImages;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!imgView) {
        imgView = [[UIImageView alloc] init];
        chessImages = [[NSMutableArray alloc] init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(chessImages) {
      
        return chessImages.count;
    }
    else {
      return 10;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    if (indexPath.row % 2 == 0) {
//        UIImageView *imgV = [cell viewWithTag:1];
//        imgV.image = [UIImage imageNamed:@"AlphaBPawn.tiff"];
//    }
    // Configure the cell
    self.collectionView = collectionView;

    UIImageView *imgV = [cell viewWithTag:1];
    
    if (chessImages) {
        UIImage *image = [chessImages objectAtIndex:indexPath.row];
        [imgV setImage:image];
    }

    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"chessFilterView"]) {
        return;
    }
}


@end
