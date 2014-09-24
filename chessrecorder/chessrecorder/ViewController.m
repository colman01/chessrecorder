//
//  ViewController.m
//  chessrecorder
//
//  Created by colman on 19/09/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self warpSpeedImage];
    
    
    
}

- (void) warpSpeedImage {
    
    DHWarpView *warpView = [[DHWarpView alloc] initWithFrame:CGRectMake(0, 0, 3500, 3500)];
    
    
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chessboard_03_rotate.jpg"]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chess.jpg"]];
    
    
    warpView.frame = self.display.bounds;
    warpView.contentMode = UIViewContentModeScaleAspectFit; // or other desired mode
    //    warpView.contentMode = UIViewContentModeScaleToFill;
    //    warpView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    warpView.autoresizingMask = UIViewAutoresizingNone;
    self.display.autoresizingMask = UIViewAutoresizingNone;
    
    [warpView addSubview:imageView];
    [self.display addSubview:warpView];
    //    warpView.topLeft = CGPointMake(97, 49);
    //    warpView.topRight = CGPointMake(677, 46);
    //    warpView.bottomLeft = CGPointMake(15, 580);
    //    warpView.bottomRight = CGPointMake(775, 580);
    
    //    warpView.topLeft = CGPointMake(97, 49);
    //    warpView.topRight = CGPointMake(677, 46);
    //    warpView.bottomLeft = CGPointMake(15, 580);
    //    warpView.bottomRight = CGPointMake(775, 580);
    
    //    warpView.topLeft = CGPointMake(150, 336);
    //    warpView.topRight = CGPointMake(460, 30);
    //    warpView.bottomLeft = CGPointMake(350, 1000);
    //    warpView.bottomRight = CGPointMake(490, 540);
    
    warpView.topLeft = CGPointMake(-30, 30);
    warpView.topRight = CGPointMake(660, 30);
    warpView.bottomLeft = CGPointMake(20, 550);
    warpView.bottomRight = CGPointMake(470, 550);
    
    CGRect center = self.display.frame;
    center.origin.x -= 100;
    center.origin.y -= 100;
    [warpView setFrame:center];
    

    self.display.layer.cornerRadius = 10.0;
    self.display.layer.shadowRadius = 10.0;
    self.display.layer.shadowColor = [UIColor blackColor].CGColor;
    self.display.layer.shadowOpacity = 1.0;
    self.display.layer.shadowRadius = 5.0;
    self.display.layer.shadowOffset = CGSizeMake(0, 3);
    self.display.clipsToBounds = NO;
    

    [warpView warp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

bool dragging;
CGFloat oldX, oldY;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if ([[touch.view class] isSubclassOfClass:[UIView class]]) {
        dragging = YES;
        oldX = touchLocation.x;
        oldY = touchLocation.y;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    dragging = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if ([[touch.view class] isSubclassOfClass:[UIView class]]) {
        UIImageView *label = (UIImageView *)touch.view;
        if (dragging) {
            CGRect frame = label.frame;
            frame.origin.x = label.frame.origin.x + touchLocation.x - oldX;
            frame.origin.y = label.frame.origin.y + touchLocation.y - oldY;
            label.frame = frame;
        }
    }
}

@end
