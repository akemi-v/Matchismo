//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Apple on 7/5/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property(nonatomic, readwrite) NSInteger score;
@property(nonatomic, strong) NSMutableArray *cards; // of Card
@property(nonatomic, strong) NSMutableArray *faceUpCards; // of Card
@property(nonatomic, readwrite) NSInteger lastFlipPoints;

@end

@implementation CardMatchingGame

- (void)setNumberOfPicked:(NSUInteger)numberOfPicked
{
    _numberOfPicked = numberOfPicked >= 2 ? numberOfPicked :2;
}

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init]; // super's designated initializer
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            // put a card in faceUpCard array; match against other chosen cards
            self.faceUpCards = [[NSMutableArray alloc] initWithArray:@[card]];
            self.lastFlipPoints = 0;
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [self.faceUpCards insertObject:otherCard atIndex:0];
                    if ([self.faceUpCards count] == self.numberOfPicked) {
                        int matchScore = [card match:self.faceUpCards];
                        if (matchScore) {
                            self.lastFlipPoints = matchScore * MATCH_BONUS;
                            for (Card *faceUpCard in self.faceUpCards) {
                                faceUpCard.matched = YES;
                            }
                        } else {
                            self.lastFlipPoints = - MISMATCH_PENALTY;
                            for (Card *faceUpCard in self.faceUpCards) {
                                if (faceUpCard != card) faceUpCard.chosen = NO;
                            }
                        }
                        self.matchedCards = [self.faceUpCards copy];
                        break;
                    }
                }
            }
            self.score += self.lastFlipPoints - COST_TO_CHOOSE;
            self.matchedCards = [self.faceUpCards copy];
            card.chosen = YES;
        }
    }
}
@end
