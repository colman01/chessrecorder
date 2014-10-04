//
//  CreateSampleGameData.h
//  chessrecorder
//
//  Created by colman on 04/10/14.
//  Copyright (c) 2014 Colman Marcus-Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Data.h"

@interface CreateSampleGameData : NSObject

- (void) createSampleData;
    
@end


//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.1"]
//[White "Shabalov, Alexander"]
//[Black "Kobalia, Mikhail"]
//[Result "1/2-1/2"]
//[ECO "D15"]
//[WhiteElo "2593"]
//[BlackElo "2614"]
//[PlyCount "43"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. d4 d5 2. c4 c6 3. Nc3 Nf6 4. Nf3 a6 5. a4 e6 6. Bg5 a5 7. e3 Na6 8. Be2 Be7
//9. O-O O-O 10. Qb3 Nb4 11. Rfd1 b6 12. Na2 Nxa2 13. Rxa2 Nd7 14. Bf4 Bb7 15.
//cxd5 exd5 16. Raa1 Bb4 17. Qc2 Re8 18. Rac1 Qe7 19. Qf5 Ba6 20. Bd3 Nf8 21. Ne5
//Rac8 22. Qh3 1/2-1/2
//
//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.2"]
//[White "Areshchenko, Alex"]
//[Black "Postny, Evgeny"]
//[Result "1-0"]
//[ECO "C66"]
//[WhiteElo "2625"]
//[BlackElo "2559"]
//[PlyCount "87"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6 4. d3 d6 5. O-O g6 6. d4 Bd7 7. d5 Nb8 8. Bxd7+
//Nbxd7 9. Re1 Nc5 10. b4 Ncxe4 11. Qd3 Bg7 12. Rxe4 Nxe4 13. Qxe4 O-O 14. Bb2 a5
//15. b5 b6 16. a4 f5 17. Qc4 g5 18. h3 h6 19. Nbd2 Qd7 20. Re1 Rae8 21. Nf1 Qf7
//22. Ng3 Re7 23. Qb3 Ree8 24. c4 Qg6 25. Qd1 Bf6 26. Nd2 Bd8 27. Bc3 Rf7 28. c5
//dxc5 29. Nc4 Bf6 30. d6 e4 31. Bxf6 Qxf6 32. dxc7 Rxc7 33. Qd5+ Rf7 34. Nd6 Re5
//35. Qxf7+ Qxf7 36. Nxf7 Kxf7 37. Nf1 Rd5 38. Ne3 Rd4 39. Nxf5 Rxa4 40. Nd6+ Kg6
//41. Rxe4 Rb4 42. Re6+ Kh7 43. Re7+ Kg8 44. Rb7 1-0
//
//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.3"]
//[White "Korneev, Oleg"]
//[Black "Gormally, Daniel"]
//[Result "1/2-1/2"]
//[ECO "C92"]
//[WhiteElo "2594"]
//[BlackElo "2557"]
//[PlyCount "80"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 4. Ba4 Nf6 5. O-O Be7 6. Re1 b5 7. Bb3 O-O 8. h3
//d6 9. c3 Bb7 10. d4 Re8 11. Ng5 Rf8 12. Nf3 Re8 13. Nbd2 Bf8 14. a4 Qd7 15. Bc2
//h6 16. d5 Ne7 17. b3 c6 18. c4 g6 19. Nf1 cxd5 20. cxd5 Nh5 21. Bd3 Bg7 22.
//axb5 axb5 23. Rxa8 Rxa8 24. b4 Nf4 25. Bxf4 exf4 26. Qe2 Ba6 27. N1d2 Re8 28.
//Qf1 Qb7 29. Rc1 Rc8 30. Rxc8+ Nxc8 31. Nb3 Na7 32. Nbd4 Qb6 33. Ne2 g5 34. Qc1
//Bc8 35. Qa3 Bf6 36. Bc2 Qc7 37. Bd3 Bd7 38. Qa6 Bc8 39. Qa3 Bd7 40. Qa6 Bc8
//1/2-1/2

//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.4"]
//[White "Ikonnikov, Vyacheslav"]
//[Black "Mikhalevski, Victor"]
//[Result "1/2-1/2"]
//[ECO "D85"]
//[WhiteElo "2560"]
//[BlackElo "2572"]
//[PlyCount "174"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. d4 Nf6 2. Nf3 g6 3. c4 Bg7 4. Nc3 d5 5. cxd5 Nxd5 6. e4 Nxc3 7. bxc3 c5 8.
//Be3 Qa5 9. Qd2 O-O 10. Rc1 Rd8 11. Bh6 cxd4 12. Bxg7 Kxg7 13. cxd4 Nc6 14. Qxa5
//Nxa5 15. Kd2 Bg4 16. Ke3 Bxf3 17. gxf3 e6 18. Be2 Rd7 19. Rc5 b6 20. Rc3 Rad8
//21. Rd1 Rd6 22. Bb5 a6 23. Bxa6 Nc6 24. Rc4 f5 25. exf5 exf5 26. Bb7 Re8+ 27.
//Kf4 Ne7 28. Rc7 Kf6 29. Kg3 Red8 30. Rb1 f4+ 31. Kh3 Re6 32. Rc4 Rd7 33. Be4
//Rdd6 34. Kg4 Nd5 35. Rb5 h5+ 36. Kh3 Ne7 37. a4 Kg7 38. Kg2 Kf7 39. h4 Kg7 40.
//Kf1 Kf6 41. Ke2 Nf5 42. d5 Re8 43. Rcb4 Rb8 44. Bd3 Nxh4 45. Rxf4+ Nf5 46. Rfb4
//Ke5 47. f4+ Kf6 48. Kf1 Ne7 49. Be4 Kf7 50. Kg2 Ra8 51. Rxb6 Rxa4 52. Rxd6 Rxb4
//53. f3 Rb2+ 54. Kh3 Rd2 55. Kg3 Kg7 56. Rd7 Kf6 57. Rd6+ Kf7 58. Ra6 Nf5+ 59.
//Kh3 Kg7 60. Bxf5 gxf5 61. Rd6 Kf7 62. Kh4 Ke7 63. Re6+ Kf7 64. Kxh5 Rxd5 65.
//Re5 Rd1 66. Kg5 Rf1 67. Re3 Rb1 68. Ra3 Rc1 69. Kxf5 Rc5+ 70. Kg4 Rb5 71. Ra6
//Rc5 72. Rh6 Ra5 73. Rh5 Ra6 74. Rh7+ Kg6 75. Rb7 Kf6 76. Rb8 Ra5 77. Rf8+ Kg6
//78. Re8 Kf6 79. Rh8 Kg6 80. f5+ Kg7 81. Rh4 Ra3 82. Kf4 Ra1 83. Kg5 Rg1+ 84.
//Rg4 Rf1 85. f6+ Kf7 86. f4 Ra1 87. Rg2 Ra5+ 1/2-1/2
//
//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.5"]
//[White "Brodsky, Michail"]
//[Black "Tiviakov, Sergei"]
//[Result "1/2-1/2"]
//[ECO "E06"]
//[WhiteElo "2554"]
//[BlackElo "2678"]
//[PlyCount "36"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. Nf3 Nf6 2. c4 b6 3. g3 Bb7 4. Bg2 e6 5. O-O Be7 6. d4 c6 7. Nc3 d5 8. Ne5
//O-O 9. e4 dxc4 10. Nxc4 Ba6 11. b3 b5 12. Ne5 b4 13. Ne2 Bxe2 14. Qxe2 Qxd4 15.
//Bb2 Qb6 16. Nc4 Qb5 17. Bxf6 Bxf6 18. e5 Be7 1/2-1/2
//
//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.6"]
//[White "Howell, David W"]
//[Black "Epishin, Vladimir"]
//[Result "1/2-1/2"]
//[ECO "B22"]
//[WhiteElo "2471"]
//[BlackElo "2600"]
//[PlyCount "50"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. e4 c5 2. c3 Nf6 3. e5 Nd5 4. Nf3 Nc6 5. d4 cxd4 6. cxd4 d6 7. Bc4 e6 8. O-O
//Be7 9. Qe2 O-O 10. Nc3 Nxc3 11. bxc3 dxe5 12. dxe5 Qc7 13. Qe4 Rd8 14. Re1 Rd7
//15. Ng5 Bxg5 16. Bxg5 Nxe5 17. Bxe6 fxe6 18. Bf4 Qc4 19. Qxe5 Rd5 20. Qe3 Rd3
//21. Qe2 Rxc3 22. Rad1 Qxe2 23. Rxe2 Rc4 24. Bg3 Bd7 25. h3 Bc6 1/2-1/2
//
//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.7"]
//[White "Galkin, Alexander"]
//[Black "Bobras, Piotr"]
//[Result "1-0"]
//[ECO "B33"]
//[WhiteElo "2598"]
//[BlackElo "2525"]
//[PlyCount "83"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. e4 c5 2. Nf3 Nc6 3. d4 cxd4 4. Nxd4 Nf6 5. Nc3 e5 6. Ndb5 d6 7. Bg5 a6 8.
//Na3 b5 9. Bxf6 gxf6 10. Nd5 f5 11. Bd3 Be6 12. O-O Bxd5 13. exd5 Ne7 14. c3 Bg7
//15. Qh5 e4 16. Bc2 Qc8 17. Rae1 O-O 18. f3 b4 19. cxb4 Bxb2 20. fxe4 Bxa3 21.
//Re3 Qxc2 22. Rg3+ Ng6 23. Rh3 Rfe8 24. exf5 Nf4 25. Qg5+ Kf8 26. Qxf4 Bb2 27.
//Qxd6+ Kg8 28. Qg3+ Kf8 29. f6 Re2 30. Kh1 Rc8 31. Qg7+ Ke8 32. Rxh7 Qg6 33.
//Qxg6 fxg6 34. Rh8+ Kd7 35. Rxc8 Kxc8 36. f7 Bg7 37. f8=Q+ Bxf8 38. Rxf8+ Kd7
//39. h3 Ke7 40. Rg8 Kf7 41. Ra8 Rxa2 42. d6 1-0
//
//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.8"]
//[White "Sulskis, Sarunas"]
//[Black "Erenburg, Sergey"]
//[Result "0-1"]
//[ECO "C42"]
//[WhiteElo "2535"]
//[BlackElo "2595"]
//[PlyCount "106"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. e4 e5 2. Nf3 Nf6 3. Nxe5 d6 4. Nxf7 Kxf7 5. d4 c5 6. Nc3 cxd4 7. Bc4+ Be6 8.
//Bxe6+ Kxe6 9. Qxd4 Kf7 10. Bf4 Qc8 11. Bxd6 Bxd6 12. Qxd6 Rd8 13. Qg3 Nc6 14.
//O-O Nd4 15. e5 Nd5 16. Rae1 Nxc3 17. bxc3 Nf5 18. Qf4 Kg8 19. e6 Rf8 20. Qb4
//Re8 21. Re5 Ne7 22. Qb3 Qc7 23. Rfe1 Rf8 24. h3 Rad8 25. R5e2 Rf5 26. c4 Rf4
//27. Qe3 b6 28. Rd2 Rxd2 29. Qxd2 Rxc4 30. Qd7 h6 31. Re2 Qc5 32. Qxa7 Qd6 33.
//Qa8+ Kh7 34. Qf3 Rd4 35. Re1 Qd5 36. Qf7 Qd6 37. g3 Rd5 38. Qf3 Rf5 39. Qe4 Qd5
//40. Qe3 b5 41. f4 Qxa2 42. g4 Rd5 43. Re2 Qc4 44. f5 Rd1+ 45. Kh2 Nd5 46. Qe5
//Qc6 47. Kg3 Rg1+ 48. Kh2 Rf1 49. Kg3 Nf6 50. Kh4 Rf3 51. Rd2 Qc4 52. e7 Qf1 53.
//Rh2 Qc1 0-1
//
//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.10"]
//[White "Neelotpal, Das"]
//[Black "Kritz, Leonid"]
//[Result "0-1"]
//[ECO "B30"]
//[WhiteElo "2467"]
//[BlackElo "2544"]
//[PlyCount "78"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. e4 c5 2. Nf3 Nc6 3. Bb5 e6 4. O-O Nge7 5. c3 a6 6. Be2 d5 7. exd5 exd5 8. d4
//c4 9. Re1 g6 10. Ne5 Nxe5 11. dxe5 Bg7 12. Nd2 O-O 13. Nf3 Nc6 14. Bg5 Qa5 15.
//Qd2 Nxe5 16. Nxe5 Bxe5 17. Bf3 d4 18. Rxe5 Qxe5 19. Re1 Qb5 20. h4 d3 21. Re7
//Be6 22. Bf6 Qf5 23. Bd4 Rad8 24. Qe3 Rxd4 25. Qxd4 b5 26. Ra7 Bc8 27. Bd5 h5
//28. g3 Be6 29. Bxe6 Qxe6 30. Rd7 Re8 31. Kh2 Qe5 32. b3 Qxd4 33. Rxd4 Re1 34.
//bxc4 bxc4 35. Kg2 Rc1 36. Kf3 Rxc3 37. a4 Rc2 38. Ke3 Kf8 39. Rd6 Ke7 0-1
//
//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.11"]
//[White "Ghaem Maghami, Ehsan"]
//[Black "Dworakowska, Joanna"]
//[Result "1-0"]
//[ECO "E97"]
//[WhiteElo "2603"]
//[BlackElo "2401"]
//[PlyCount "73"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. d4 Nf6 2. c4 g6 3. Nc3 Bg7 4. Nf3 O-O 5. e4 d6 6. Be2 e5 7. O-O Nc6 8. Be3
//Ng4 9. Bg5 f6 10. Bh4 Qd7 11. d5 Ne7 12. Ne1 h5 13. h3 Nh6 14. Bg3 f5 15. c5 f4
//16. Bh4 Nf7 17. cxd6 cxd6 18. Nf3 Bh6 19. Bf6 g5 20. Nh2 g4 21. hxg4 h4 22. Rc1
//Bg5 23. Bxg5 Nxg5 24. Nf3 Qxg4 25. Nxe5 Nh3+ 26. Kh1 Qg7 27. gxh3 Qxe5 28. Rg1+
//Kh7 29. Bg4 f3 30. Nb5 Bxg4 31. Rxg4 Rf4 32. Qg1 Raf8 33. Rc7 R8f7 34. Rxf4
//Qxf4 35. Qg4 Qd2 36. Qxh4+ Kg7 37. Rxe7 1-0
//
//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.12"]
//[White "Fridman, Daniel2"]
//[Black "Kononenko, Tatiana"]
//[Result "0-1"]
//[ECO "A11"]
//[WhiteElo "2566"]
//[BlackElo "2442"]
//[PlyCount "94"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. Nf3 d5 2. c4 c6 3. e3 Nf6 4. Nc3 a6 5. d4 Bf5 6. Ne5 Nbd7 7. Qb3 Qc7 8. Nxd7
//Qxd7 9. Na4 Qc7 10. Nb6 Rd8 11. Bd2 e6 12. Ba5 Bd6 13. c5 Be7 14. Be2 O-O 15.
//O-O Qb8 16. Qd1 e5 17. f3 exd4 18. exd4 Nd7 19. Nxd7 Rxd7 20. Be1 Bg5 21. Bf2
//b6 22. b4 a5 23. b5 cxb5 24. Bxb5 Rdd8 25. c6 Bf4 26. g3 Bd6 27. Qb3 Bh3 28.
//Rfc1 Bc7 29. Bf1 Bxf1 30. Kxf1 h5 31. Kg2 Rd6 32. Qb5 Qd8 33. Re1 Rg6 34. Rac1
//h4 35. Re5 Bxe5 36. dxe5 Qg5 37. Qb2 b5 38. Rc5 Rc8 39. c7 b4 40. g4 Qe7 41.
//Rxa5 Qxc7 42. Rxd5 Rxg4+ $1 43. fxg4 Qb7 44. Kh3 Qxd5 45. Kxh4 Qe4 46. Qd2 Qh7+
//47. Kg3 Rc3+ 0-1
//
//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.13"]
//[White "Yakovich, Yuri"]
//[Black "Zatonskih, Anna"]
//[Result "0-1"]
//[ECO "A29"]
//[WhiteElo "2560"]
//[BlackElo "2435"]
//[PlyCount "64"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. c4 e5 2. Nc3 Nc6 3. Nf3 Nf6 4. g3 Nd4 5. Bg2 Nxf3+ 6. Bxf3 Bb4 7. Qb3 Bc5 8.
//d3 h6 9. O-O O-O 10. Bd2 c6 11. Bg2 Re8 12. Rad1 b6 13. Qa4 Bb7 14. b4 Bf8 15.
//b5 Qc8 16. Qb3 Qc7 17. a4 Rad8 18. Rb1 Ba8 19. Rfe1 Bc5 20. a5 bxa5 21. Na4 Bb4
//22. Bxb4 axb4 23. Qxb4 cxb5 24. Qxb5 Bxg2 25. Kxg2 Rb8 26. Qc5 Qxc5 27. Nxc5 d5
//28. Rxb8 Rxb8 29. cxd5 Nxd5 30. Ra1 Nc3 31. Kf3 Rb5 32. Na4 $4 Ra5 0-1
//
//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.15"]
//[White "Kuzubov, Yuri"]
//[Black "Roeder, Mathias"]
//[Result "1-0"]
//[ECO "E92"]
//[WhiteElo "2535"]
//[BlackElo "2393"]
//[PlyCount "79"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. d4 Nf6 2. Nf3 g6 3. c4 Bg7 4. Nc3 O-O 5. e4 d6 6. Be2 e5 7. Be3 Ng4 8. Bg5
//f6 9. Bh4 g5 10. Bg3 Nh6 11. d5 Na6 12. Nd2 f5 13. exf5 Bxf5 14. Nde4 Nc5 15.
//Bd3 Nxd3+ 16. Qxd3 g4 17. O-O Bg6 18. Qe2 Bh5 19. c5 a6 20. h3 Qd7 21. Qd1 Rf5
//22. hxg4 Nxg4 23. Qb3 Rb8 24. cxd6 cxd6 25. Qb6 Bf8 26. Bh4 Bg6 27. f3 Nh6 28.
//Nf6+ Rxf6 29. Bxf6 Nf5 30. Ne4 Nd4 31. Rae1 Qf7 32. Bg5 Bxe4 33. fxe4 Qh5 34.
//Bd8 Ne2+ 35. Rxe2 Qxe2 36. Rxf8+ Kxf8 37. Qxd6+ Kf7 38. Qe6+ Kf8 39. Be7+ Kg7
//40. Bf6+ 1-0
//
//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.18"]
//[White "Lalic, Bogdan"]
//[Black "Gupta, Abhijeet"]
//[Result "1-0"]
//[ECO "D15"]
//[WhiteElo "2491"]
//[BlackElo "2380"]
//[PlyCount "59"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. d4 d5 2. c4 c6 3. Nf3 Nf6 4. Nc3 a6 5. e3 b5 6. c5 g6 7. b4 Bg4 8. a4 Nbd7
//9. Qb3 Bxf3 10. gxf3 Bg7 11. f4 O-O 12. Bg2 e6 13. O-O Qc7 14. Bd2 Rfb8 15. Ra2
//Qb7 16. Rfa1 Ne8 17. Qc2 Nc7 18. Ne2 Nf6 19. Nc1 Qc8 20. Be1 Kf8 21. Nd3 Nfe8
//22. f3 f5 23. Bh4 Qb7 24. Bf1 Nf6 25. Ne5 Nce8 26. Ra3 Ng8 27. axb5 Bxe5 28.
//bxc6 Qxb4 29. fxe5 Nc7 30. Be1 1-0
//
//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.20"]
//[White "Neubauer, Martin"]
//[Black "Negi, Parimarjan"]
//[Result "1/2-1/2"]
//[ECO "B96"]
//[WhiteElo "2468"]
//[BlackElo "2376"]
//[PlyCount "96"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. e4 c5 2. Nf3 d6 3. d4 cxd4 4. Nxd4 Nf6 5. Nc3 a6 6. Bg5 e6 7. f4 Nbd7 8. Qf3
//Qc7 9. O-O-O b5 10. e5 Bb7 11. Qh3 dxe5 12. Nxe6 fxe6 13. Qxe6+ Be7 14. Bxf6
//gxf6 15. Be2 h5 16. Nd5 Bxd5 17. Rxd5 Nc5 18. Qf5 Qc8 19. Qg6+ Kf8 20. fxe5 Qe6
//21. Rf1 Qf7 22. Qxf7+ Kxf7 23. exf6 Bf8 24. Bxh5+ Ke6 25. Rff5 Nd7 26. f7 Bg7
//27. g4 Rad8 28. a4 Ne5 29. Rxd8 Rxd8 30. axb5 axb5 31. Kb1 Bh6 32. h4 Nc4 33.
//c3 Ne5 34. Rf1 Bf8 35. g5 Ke7 36. Kc2 Bg7 37. Be2 b4 38. cxb4 Nxf7 39. Rf4 Rd4
//40. Rxd4 Bxd4 41. g6 Nd6 42. h5 Kf6 43. b3 Nc8 44. Kd3 Bg1 45. Bg4 Nb6 46. Ke4
//Kg7 47. Be6 Bf2 48. Kf5 Be3 1/2-1/2
//
//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.26"]
//[White "Mannion, Stephen"]
//[Black "Sareen, Vishal"]
//[Result "0-1"]
//[ECO "B67"]
//[WhiteElo "2331"]
//[BlackElo "2385"]
//[Annotator "Mikhail Golubev (www.chesstoday.net)"]
//[PlyCount "132"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. e4 c5 2. Nf3 d6 3. d4 cxd4 4. Nxd4 Nf6 5. Nc3 Nc6 6. Bg5 e6 7. Qd2 a6 8.
//O-O-O Bd7 9. f3 Be7 10. h4 h6 11. Be3 h5 12. Bg5 Rc8 13. Nxc6 Bxc6 14. Bd3 b5
//15. Rhe1 Qb6 16. Kb1 b4 17. Ne2 a5 18. Be3 Qb7 19. Nd4 Bd7 20. Qe2 Ra8 21. Bb5
//O-O 22. Bg5 Rfb8 23. Bxd7 Qxd7 24. Rd3 Rb6 25. Red1 g6 26. Qf2 Rab8 27. Qg3 a4
//28. Ne2 Qc7 29. Qf4 Kg7 30. Qe3 Ne8 31. Bxe7 Qxe7 32. g3 e5 33. Qd2 Rd8 34. c4
//Rc8 35. Rc1 Rcc6 36. Rd5 Nc7 37. Ra5 a3 38. b3 Ne6 39. Rd5 Nc5 40. Rd1 Qf6 41.
//Qe3 Ne6 42. Rb5 Nc5 43. Rxb6 Rxb6 44. Nc1 Rc6 45. Nd3 Nxd3 46. Rxd3 Qe6 47. Rd2
//Qh3 48. Qg1 Qe6 49. Rd5 Qf6 50. Qe3 Rc5 51. Rd3 Qe6 52. Kc2 Rc6 53. Rd5 Qh3 54.
//Qg1 Qc8 55. Qf1 Qc7 56. Qf2 Rc5 57. Qd2 Rxd5 58. Qxd5 Qb6 59. c5 Qxc5+ 60. Qxc5
//dxc5 61. Kd3 f5 62. Kc4 g5 63. exf5 {# Quiz} g4 $1 (63... gxh4 $2 64. gxh4 Kf6
//                                                    65. Kxc5 Kxf5 66. Kxb4 Kf4 $11 67. Kc3 (67. Kxa3 Kxf3 68. b4 e4 69. b5 e3 70.
//                                                                                            b6 e2 71. b7 e1=Q 72. b8=Q) 67... Kxf3 68. Kd2 e4 69. Ke1 Ke3 70. b4 Kd4 71.
//                                                    Ke2 Kc4 72. Ke3 Kxb4 73. Kxe4 Kc3 74. Ke3 Kb2 75. Kd2 Kxa2 76. Kc2 Ka1 77. Kc1
//                                                    a2 78. Kc2 {stalemate}) 64. fxg4 e4 $1 65. gxh5 e3 66. Kd3 c4+ $1 0-1
//
//[Event "Monarch Assurance"]
//[Site "Port Erin IOM"]
//[Date "2005.09.29"]
//[Round "6.36"]
//[White "Spence, David"]
//[Black "Fairbairn, Stephen"]
//[Result "1-0"]
//[ECO "B06"]
//[WhiteElo "2218"]
//[BlackElo "2065"]
//[PlyCount "39"]
//[EventDate "2005.09.24"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. e4 g6 2. d4 d6 3. Nc3 Bg7 4. Bg5 a6 5. Bc4 b5 6. Bb3 Nf6 7. Nf3 O-O 8. e5
//dxe5 9. dxe5 Ng4 10. Qe2 c6 11. h3 Nh6 12. Rd1 Qc7 13. Qd2 Nf5 14. g4 h6 15.
//Bf4 g5 16. gxf5 gxf4 17. Qxf4 Nd7 18. Rg1 Kh8 19. Ke2 Nf6 20. Rxg7 1-0
//
//[Event "WCh-FIDE"]
//[Site "San Luis ARG"]
//[Date "2005.09.29"]
//[Round "2"]
//[White "Adams, Michael"]
//[Black "Polgar, Judit"]
//[Result "1/2-1/2"]
//[ECO "B48"]
//[Annotator "www.chesstoday.net"]
//[PlyCount "95"]
//[EventDate "2005.09.28"]
//[EventType "tourn"]
//[EventRounds "14"]
//[EventCountry "ARG"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. e4 c5 2. Nf3 e6 3. d4 cxd4 4. Nxd4 Nc6 5. Nc3 Qc7 6. Be3 a6 7. Bd3 b5 8.
//Nxc6 Qxc6 9. e5 Bb4 10. O-O f5 11. Be2 Bb7 12. Bh5+ $5 $146 g6 13. Bf3 Qc8 14.
//Bd2 Bxc3 15. Bxc3 Ne7 16. Bb4 Bxf3 17. Qxf3 Nd5 18. c3 Qc4 19. Rfd1 Qg4 20. Qd3
//Kf7 21. h3 Qf4 22. Qe2 Qc4 23. Qf3 a5 24. Bd6 a4 25. Rd4 Qc6 26. Rad1 $36 h6
//27. R1d3 (27. Rxd5 $2 exd5 28. Rxd5 Ke6 $1) 27... Kg7 28. Kh2 Rac8 29. Qg3 Kh7
//30. Qh4 Rhg8 31. Rg3 g5 32. Qh5 Rg7 33. Qd1 Nf4 34. h4 Rh8 35. Kg1 Kg8 36. b3
//axb3 37. axb3 Rhh7 38. h5 Rh8 $1 39. Ba3 Kh7 40. Bc1 Nd5 41. c4 bxc4 42. bxc4
//Nb6 43. Rd6 Qa4 44. Qxa4 Nxa4 45. Ra3 Nc5 46. Ra7 Rc8 47. Be3 f4 48. Bxc5 (48.
//                                                                           Bxc5 Rxc5 49. Rdxd7 Rxd7 50. Rxd7+ Kg8 $11) (48. Bd4 $5) 1/2-1/2
//
//[Event "WCh-FIDE"]
//[Site "San Luis ARG"]
//[Date "2005.09.29"]
//[Round "2"]
//[White "Kasimdzhanov, Rustam"]
//[Black "Svidler, Peter"]
//[Result "1/2-1/2"]
//[ECO "B09"]
//[Annotator "www.chesstoday.net"]
//[PlyCount "47"]
//[EventDate "2005.09.28"]
//[EventType "tourn"]
//[EventRounds "14"]
//[EventCountry "ARG"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. e4 g6 2. d4 Bg7 3. Nc3 d6 4. f4 Nf6 5. Nf3 O-O 6. Be3 b6 7. Qd2 Bb7 8. e5
//Ng4 9. O-O-O c5 10. dxc5 bxc5 11. Bxc5 Qa5 12. Ba3 dxe5 13. Nd5 $146 (13. h3
//                                                                      Bh6 14. Ng5) 13... Qxd2+ 14. Rxd2 Bxd5 15. Rxd5 Ne3 (15... Bh6 $5) 16. Rd2 Nc6
//17. Bb5 $1 Rfc8 (17... Nd4 18. Nxd4 exd4 19. Bxe7 Rfc8) 18. Bxc6 Rxc6 19. Nxe5
//Bxe5 20. fxe5 Nc4 21. Bxe7 $1 Nxd2 22. Kxd2 Rb8 23. Kc1 Rc4 24. Bd6 $14 1/2-1/2
//
//[Event "WCh-FIDE"]
//[Site "San Luis ARG"]
//[Date "2005.09.29"]
//[Round "2"]
//[White "Leko, Peter"]
//[Black "Morozevich, Alexander"]
//[Result "1/2-1/2"]
//[ECO "B90"]
//[Annotator "www.chesstoday.net"]
//[PlyCount "136"]
//[EventDate "2005.09.28"]
//[EventType "tourn"]
//[EventRounds "14"]
//[EventCountry "ARG"]
//[Source "Chess Today"]
//[SourceDate "2005.09.30"]
//
//1. e4 c5 2. Nf3 d6 3. d4 cxd4 4. Nxd4 Nf6 5. Nc3 a6 6. f3 e6 7. Be3 Be7 8. Qd2
//O-O 9. g4 Nc6 10. O-O-O Nd7 11. h4 Nde5 12. Qf2 Bd7 13. Kb1 Na5 $146 14. g5
//Nec4 15. Bc1 b5 16. f4 b4 17. Nce2 Qb6 18. Rh2 d5 19. exd5 Bc5 20. Qf3 Rad8 21.
//Nb3 Nxb3 22. axb3 Ne3 23. Bxe3 Bxe3 24. Rd3 Bc5 25. dxe6 Bxe6 26. Nc1 g6 $2 27.
//Bh3 $16 f5 28. gxf6 Bf7 29. f5 Bd4 30. fxg6 hxg6 31. Qg4 Bxf6 32. Re2 $6 a5 33.
//Re4 Kg7 34. Qg3 $6 (34. h5 g5) 34... Rh8 $132 35. Bf5 Rh5 36. Rxd8 Qxd8 37. Be6
//Bxh4 $13 38. Qg2 Be8 39. Rg4 Re5 40. Bc4 Re1 41. Bd3 Qf6 42. Qd2 Qf2 43. Be2
//Bf6 44. Rc4 Qg3 45. Rc7+ Qxc7 46. Qxe1 g5 47. Nd3 Bg6 48. Qg1 Qe7 49. Bg4 Qe4
//50. Qg3 Bf7 51. Qh3 Bd5 52. Bf5 Qh4 53. Qe3 Qd4 54. Qg3 Bf7 55. Qg2 Qd5 56. Be4
//Qe6 57. Nc5 Qd6 58. Nd3 Be6 59. Qh1 Qd4 60. Qh7+ Kf8 61. Bf5 Bf7 62. Qh6+ Ke7
//63. Qh2 Qd6 (63... a4 $5) 64. Qh7 Qb8 65. Bg4 Kf8 66. Qh6+ Ke7 67. Qh7 Kf8 68.
//Qh6+ Ke7 1/2-1/2