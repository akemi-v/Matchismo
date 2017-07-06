//
//  PlayingCard.h
//  Matchismo
//
//  Created by Apple on 6/27/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
