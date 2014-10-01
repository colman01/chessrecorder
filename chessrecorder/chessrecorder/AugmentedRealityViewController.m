//
//  AugmentedRealityViewController.m
//  chessrecorder
//
//  Created by colman on 01/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "AugmentedRealityViewController.h"

@interface AugmentedRealityViewController ()

@end

@implementation AugmentedRealityViewController

@synthesize cameraView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareCamera];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) prepareCamera {
//    CGRect mainScreenFrame = [[UIScreen mainScreen] applicationFrame];
//    UIView *primaryView = [[UIView alloc] initWithFrame:mainScreenFrame] ;
//    primaryView.backgroundColor = [UIColor blueColor];
//    self.view = primaryView;
    
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    pipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:nil input:videoCamera output:self.cameraView];
    
    [videoCamera startCameraCapture];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
