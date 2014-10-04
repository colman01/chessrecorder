//
//  DmGameInformation.h
//  chessrecorder
//
//  Created by colman on 04/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DmGameInformation : NSManagedObject

@property (nonatomic, retain) NSString * notation;
@property (nonatomic, retain) NSString * event;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * site;
@property (nonatomic, retain) NSNumber * round;
@property (nonatomic, retain) NSString * white;
@property (nonatomic, retain) NSString * black;
@property (nonatomic, retain) NSNumber * result;

@end
