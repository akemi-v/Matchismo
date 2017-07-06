//
//  Deck.h
//  Matchismo
//
//  Created by Apple on 6/28/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
