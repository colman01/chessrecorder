//
//  CreateSampleGameData.m
//  chessrecorder
//
//  Created by colman on 04/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import "CreateSampleGameData.h"

@implementation CreateSampleGameData

- (void) createSampleData {
    AppDelegate *appDelegate =  [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    DmGameInformation *gameInfo = [NSEntityDescription insertNewObjectForEntityForName:@"GameInformation" inManagedObjectContext:context];
    gameInfo.event  = @"F/S Return Match";
    gameInfo.site   = @"Belgrade, Serbia Yugoslavia|JUG";
    gameInfo.round  = [NSNumber numberWithInt:29];
    gameInfo.white  = @"Fischer, Robert J.";
    gameInfo.black  = @"Spassky, Boris V.";
    gameInfo.result = @"1/2 - 1/2";
    NSString *dateString = @"1992-11-04";
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy/mm/dd"];
    gameInfo.date = [f dateFromString:dateString];
    gameInfo.notation = @"1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 {This opening is called the Ruy Lopez.} 4. Ba4 Nf6 5. O-O Be7 6. Re1 b5 7. Bb3 d6 8. c3 O-O 9. h3 Nb8  10. d4 Nbd711. c4 c6 12. cxb5 axb5 13. Nc3 Bb7 14. Bg5 b4 15. Nb1 h6 16. Bh4 c5 17. dxe5Nxe4 18. Bxe7 Qxe7 19. exd6 Qf6 20. Nbd2 Nxd6 21. Nc4 Nxc4 22. Bxc4 Nb6 23. Ne5 Rae8 24. Bxf7+ Rxf7 25. Nxf7 Rxe1+ 26. Qxe1 Kxf7 27. Qe3 Qg5 28. Qxg5 hxg5 29. b3 Ke6 30. a3 Kd6 31. axb4 cxb4 32. Ra5 Nd5 33. f3 Bc8 34. Kf2 Bf5 35. Ra7 g6 36. Ra6+ Kc5 37. Ke1 Nf4 38. g3 Nxh3 39. Kd2 Kb5 40. Rd6 Kc5 41. Ra6 Nf2 42. g4 Bd3 43. Re6 1/2-1/2";
    
    [appDelegate saveContext];
    
    
    gameInfo = [NSEntityDescription insertNewObjectForEntityForName:@"GameInformation" inManagedObjectContext:context];
    gameInfo.event  = @"Monarch Assurance";
    gameInfo.site   = @"Port Erin IOM";
    gameInfo.round  = [NSNumber numberWithFloat:6.1];
    gameInfo.white  = @"Shabalov, Alexander";
    gameInfo.black  = @"Kobalia, Mikhail";
    gameInfo.result = @"1/2 - 1/2";
    dateString = @"2005.09.29";
    gameInfo.date = [f dateFromString:dateString];
    gameInfo.notation = @"1. d4 d5 2. c4 c6 3. Nc3 Nf6 4. Nf3 a6 5. a4 e6 6. Bg5 a5 7. e3 Na6 8. Be2 Be7 9. O-O O-O 10. Qb3 Nb4 11. Rfd1 b6 12. Na2 Nxa2 13. Rxa2 Nd7 14. Bf4 Bb7 15. cxd5 exd5 16. Raa1 Bb4 17. Qc2 Re8 18. Rac1 Qe7 19. Qf5 Ba6 20. Bd3 Nf8 21. Ne5 Rac8 22. Qh3 1/2-1/2";
    [appDelegate saveContext];
    
    gameInfo = [NSEntityDescription insertNewObjectForEntityForName:@"GameInformation" inManagedObjectContext:context];
    gameInfo.event  = @"Monarch Assurance";
    gameInfo.site   = @"Port Erin IOM";
    gameInfo.round  = [NSNumber numberWithFloat:6.2];
    gameInfo.white  = @"Areshchenko, Alex";
    gameInfo.black  = @"Postny, Evgeny";
    gameInfo.result = @"1 - 0";
    dateString = @"2005.09.30";
    gameInfo.date = [f dateFromString:dateString];
    gameInfo.notation = @"1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6 4. d3 d6 5. O-O g6 6. d4 Bd7 7. d5 Nb8 8. Bxd7+ Nbxd7 9. Re1 Nc5 10. b4 Ncxe4 11. Qd3 Bg7 12. Rxe4 Nxe4 13. Qxe4 O-O 14. Bb2 a5 15. b5 b6 16. a4 f5 17. Qc4 g5 18. h3 h6 19. Nbd2 Qd7 20. Re1 Rae8 21. Nf1 Qf7 22. Ng3 Re7 23. Qb3 Ree8 24. c4 Qg6 25. Qd1 Bf6 26. Nd2 Bd8 27. Bc3 Rf7 28. c5 dxc5 29. Nc4 Bf6 30. d6 e4 31. Bxf6 Qxf6 32. dxc7 Rxc7 33. Qd5+ Rf7 34. Nd6 Re5 35. Qxf7+ Qxf7 36. Nxf7 Kxf7 37. Nf1 Rd5 38. Ne3 Rd4 39. Nxf5 Rxa4 40. Nd6+ Kg6 41. Rxe4 Rb4 42. Re6+ Kh7 43. Re7+ Kg8 44. Rb7 1-0";
    [appDelegate saveContext];
    
    gameInfo = [NSEntityDescription insertNewObjectForEntityForName:@"GameInformation" inManagedObjectContext:context];
    gameInfo.event  = @"Monarch Assurance";
    gameInfo.site   = @"Port Erin IOM";
    gameInfo.round  = [NSNumber numberWithFloat:6.3];
    gameInfo.white  = @"Korneev, Oleg";
    gameInfo.black  = @"Gormally, Daniel";
    gameInfo.result = @"1/2 - 1/2";
    dateString = @"2005.09.29";
    gameInfo.date = [f dateFromString:dateString];
    gameInfo.notation = @"1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 4. Ba4 Nf6 5. O-O Be7 6. Re1 b5 7. Bb3 O-O 8. h3 d6 9. c3 Bb7 10. d4 Re8 11. Ng5 Rf8 12. Nf3 Re8 13. Nbd2 Bf8 14. a4 Qd7 15. Bc2 h6 16. d5 Ne7 17. b3 c6 18. c4 g6 19. Nf1 cxd5 20. cxd5 Nh5 21. Bd3 Bg7 22. axb5 axb5 23. Rxa8 Rxa8 24. b4 Nf4 25. Bxf4 exf4 26. Qe2 Ba6 27. N1d2 Re8 28. Qf1 Qb7 29. Rc1 Rc8 30. Rxc8+ Nxc8 31. Nb3 Na7 32. Nbd4 Qb6 33. Ne2 g5 34. Qc1 Bc8 35. Qa3 Bf6 36. Bc2 Qc7 37. Bd3 Bd7 38. Qa6 Bc8 39. Qa3 Bd7 40. Qa6 Bc8";
    [appDelegate saveContext];
    
}

@end
