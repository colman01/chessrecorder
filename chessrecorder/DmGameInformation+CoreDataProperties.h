//
//  DmGameInformation+CoreDataProperties.h
//  chessrecorder
//
//  Created by colman on 04/02/16.
//  Copyright © 2016 Colman Marcus-Quinn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DmGameInformation.h"

NS_ASSUME_NONNULL_BEGIN

@interface DmGameInformation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *black;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *event;
@property (nullable, nonatomic, retain) NSString *notation;
@property (nullable, nonatomic, retain) NSString *result;
@property (nullable, nonatomic, retain) NSNumber *round;
@property (nullable, nonatomic, retain) NSString *site;
@property (nullable, nonatomic, retain) NSString *white;
@property (nullable, nonatomic, retain) id images;

@end

NS_ASSUME_NONNULL_END
