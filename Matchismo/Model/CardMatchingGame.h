//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Apple on 7/5/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property(nonatomic, readonly) NSInteger score;

@end
