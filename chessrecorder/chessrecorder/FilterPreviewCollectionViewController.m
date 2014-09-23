//
//  FilterPreviewCollectionViewController.m
//  chessrecorder
//
//  Created by colman on 23/09/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "FilterPreviewCollectionViewController.h"

@interface FilterPreviewCollectionViewController ()

@end

@implementation FilterPreviewCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

@synthesize origImages, foundCornersImages, transformedImages;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    self.collectionView = self.view;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return (self.origImages.count-1)*3;
    return 18;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2" forIndexPath:indexPath];
//    rownum*3 + col
    NSInteger col = indexPath.row % 3;
    NSInteger row = indexPath.row / 3;
    switch (col) {
        case 0: {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2" forIndexPath:indexPath];
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:3];
            imgView.image = [origImages objectAtIndex:row];
            break;
        }
        case 1: {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell3" forIndexPath:indexPath];
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:3];
            imgView.image = [foundCornersImages objectAtIndex:row];
            break;
        }
            
        case 2:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell4" forIndexPath:indexPath];
            UIImageView *imgView = (UIImageView *)[cell viewWithTag:3];
            imgView.image = [transformedImages objectAtIndex:row];
            break;
        }
            
            
        default:
            break;
    }
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:2];
//    [lbl setText:[NSString stringWithFormat:@"%i", indexPath.row]];
    
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







#pragma mark Setup Data
- (void) setupData {
    
    if (!self.origImages) {
        self.origImages = [[NSMutableArray alloc] init];
        self.foundCornersImages = [[NSMutableArray alloc] init];
        self.transformedImages = [[NSMutableArray alloc] init];
    }
    
    UIImage * img = [UIImage imageNamed:@"Chess_table.jpg"];
    GPUImageCannyEdgeDetectionFilter *filter = [[GPUImageCannyEdgeDetectionFilter alloc] init];
    GPUImageLineGenerator *filter2 = [[GPUImageLineGenerator alloc] init];
    UIImage *result = [filter imageByFilteringImage:img];
    if(!result)
        result = [UIImage imageNamed:@"Chess_table.jpg"];
    
    [foundCornersImages addObject:result];
    
    result = [filter2 imageByFilteringImage:img];

    if(!result)
        result = [UIImage imageNamed:@"Chess_table.jpg"];
    
    [transformedImages addObject:result];
    [origImages addObject:img];
    
    img = [UIImage imageNamed:@"Chess-board.jpg"];
    filter = [[GPUImageCannyEdgeDetectionFilter alloc] init];
    filter2 = [[GPUImageLineGenerator alloc] init];
    result = [filter imageByFilteringImage:img];
    if(!result)
        result = [UIImage imageNamed:@"Chess_table.jpg"];
    [foundCornersImages addObject:result];
    
    result = [filter2 imageByFilteringImage:img];
    
    if(!result)
        result = [UIImage imageNamed:@"Chess_table.jpg"];
    
    [transformedImages addObject:result];
    [origImages addObject:img];
    
    img = [UIImage imageNamed:@"Chess_board_opening.jpg"];
    result = [filter imageByFilteringImage:img];
    if(!result)
        result = [UIImage imageNamed:@"Chess_table.jpg"];
    
    [foundCornersImages addObject:result];
    result = [filter2 imageByFilteringImage:img];
    
    if(!result)
        result = [UIImage imageNamed:@"Chess_table.jpg"];
    
    [transformedImages addObject:result];
    [origImages addObject:img];
    
    img = [UIImage imageNamed:@"Chess_board_top.jpg"];
    result = [filter imageByFilteringImage:img];
    if(!result)
        result = [UIImage imageNamed:@"Chess_table.jpg"];
    
    [foundCornersImages addObject:result];
    result = [filter2 imageByFilteringImage:img];
    
    if(!result)
        result = [UIImage imageNamed:@"Chess_table.jpg"];
    
    [transformedImages addObject:result];
    [origImages addObject:img];
    
    img = [UIImage imageNamed:@"chess-top-view.jpg"];
    result = [filter imageByFilteringImage:img];
    if(!result)
        result = [UIImage imageNamed:@"Chess_table.jpg"];
    [foundCornersImages addObject:result];
    result = [filter2 imageByFilteringImage:img];
    
    if(!result)
        result = [UIImage imageNamed:@"Chess_table.jpg"];
    
    [transformedImages addObject:result];
    [origImages addObject:img];
    
    img = [UIImage imageNamed:@"Chess-board.jpg"];
    result = [filter imageByFilteringImage:img];
    if(!result)
        result = [UIImage imageNamed:@"Chess_table.jpg"];
    [foundCornersImages addObject:result];
    result = [filter2 imageByFilteringImage:img];
    
    if(!result)
        result = [UIImage imageNamed:@"Chess_table.jpg"];
    
    [transformedImages addObject:result];
    [origImages addObject:img];
    

    
}









@end
