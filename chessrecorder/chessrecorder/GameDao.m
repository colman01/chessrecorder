//
//  GameDao.m
//  chessrecorder
//
//  Created by colman on 04/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "GameDao.h"

@implementation GameDao


static GameDao *instance = NULL;

+(GameDao *)instance {
    @synchronized(self) {
        if (instance == NULL)
            instance = [[self alloc] init];
    }
    return instance;
}

- (void)remove:(DmGameInformation *)gameInfo{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [[appDelegate managedObjectContext] deleteObject:gameInfo];
}

- (NSMutableArray *) getAllGames {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GameInformation" inManagedObjectContext:[appDelegate managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError* error;
    NSArray *fetchedRecords = [[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return [[NSMutableArray alloc] initWithArray:fetchedRecords];
}

- (DmGameInformation *) loadById:(NSNumber *) identifier {
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GameInformation" inManagedObjectContext:[appDelegate  managedObjectContext]];
    [fetchRequest setEntity:entity];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"identifier = %@", identifier];
    
    
//    [fetchRequest setPredicate:predicate];
    NSError* error;
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *result = [[appDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"fetchError = %@, details = %@", error, error.userInfo);
        return nil;
    }
    if (result.count > 0)
        return  result[[identifier intValue]];
    return nil;
}

@end
