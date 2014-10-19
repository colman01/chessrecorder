//
//  HomographyTransform.h
//  chessrecorder
//
//  Created by colman on 02/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HomographyTransform : NSObject

- (UIImage *) transform:(NSMutableArray *) chosenPoints withImage:(UIImage *)sourceImage;

@end
