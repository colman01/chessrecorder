//
//  ShowFrameViewController.m
//  chessrecorder
//
//  Created by colman on 26/11/15.
//  Copyright © 2015 Colman Marcus-Quinn. All rights reserved.
//

#import "ShowFrameViewController.h"
#import "AppDelegate.h"
#import "Data.h"

@interface ShowFrameViewController ()

@end

@implementation ShowFrameViewController

static NSString * const reuseIdentifier = @"Cell";

@synthesize imgView;
@synthesize subView;
@synthesize chessImages;
@synthesize slider;
@synthesize numberOfCorners;
@synthesize saveImages;
@synthesize averageColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!imgView) {
        imgView = [[UIImageView alloc] init];
        chessImages = [[NSMutableArray alloc] init];
    }
    [slider addTarget:self action:@selector(handleValueChanged:event:) forControlEvents:UIControlEventValueChanged];
}

- (void)handleValueChanged:(id)sender event:(id)event {
    UITouch *touchEvent = [[event allTouches] anyObject]; // there's only one touch
    if (touchEvent.phase == UITouchPhaseEnded) {
        /* place your code here */
        numberOfCorners = [[NSNumber alloc] initWithFloat:slider.value];
    }}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Slider Number of points
//[slider addTarget:self action:@selector(handleValueChanged:event:) forControlEvents:UIControlEventValueChanged];
//
//- (void)handleValueChanged:(id)sender event:(id)event {
//    UITouch *touchEvent = [[event allTouches] anyObject]; // there's only one touch
//    if (touchEvent.phase == UITouchPhaseEnded) { /* place your code here */ }}

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
        
        if (saveImages.isOn) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
        
        
//        AppDelegate *appDelegate =  [UIApplication sharedApplication].delegate;
//        NSManagedObjectContext *context = [appDelegate managedObjectContext];
//        DmGameInformation *gameInfo = [NSEntityDescription insertNewObjectForEntityForName:@"GameInformation" inManagedObjectContext:context];
//        NSMutableArray *array = gameInfo.images;
//        if (!array) {
//            array    = [[NSMutableArray alloc] init];
//            [array addObject:image];
//        }
//        [appDelegate saveContext];
        
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
