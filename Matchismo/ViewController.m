//
//  ViewController.m
//  Matchismo
//
//  Created by Apple on 6/8/17.
//  Copyright © 2017 Mari. All rights reserved.
//

#import "ViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface ViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numberOfPickedSegment;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (strong, nonatomic) NSMutableArray *flipsHistory;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (nonatomic) NSInteger flipCount;
@property (weak, nonatomic) IBOutlet UILabel *sliderMaxValue;

@end

@implementation ViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    _game.numberOfPicked = [self numberOfPicked];
    return _game;
}

- (NSUInteger)numberOfPicked
{
    return self.numberOfPickedSegment.selectedSegmentIndex + 2;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSMutableArray *)flipsHistory
{
    if (!_flipsHistory) _flipsHistory = [[NSMutableArray alloc] init];
    return _flipsHistory;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    self.numberOfPickedSegment.enabled = NO;
    unsigned long int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
    self.flipCount++;
}

- (IBAction)touchNewGameButton:(UIButton *)sender
{
    self.numberOfPickedSegment.enabled = YES;
    self.game = nil;
    self.flipsHistory = nil;
    self.flipCount = 0;
    [self updateUI];
}

- (IBAction)changeNumberOfPicked:(UISegmentedControl *)sender
{
    self.game = nil;
    [self updateUI];
}

- (IBAction)changeSlider:(UISlider *)sender
{
    int selectedIndex = (int)sender.value;
    if (selectedIndex < 0 || selectedIndex > self.flipCount - 1) return;
    self.resultsLabel.alpha = (selectedIndex < self.flipCount - 1) ? 0.5 : 1;
    NSString *text = [NSString stringWithFormat:@"%d:", selectedIndex + 1];
    self.resultsLabel.text = [text stringByAppendingString:[self.flipsHistory objectAtIndex:selectedIndex]];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        unsigned long int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
    }
    [self updateFlipResult];
    self.historySlider.maximumValue = self.flipCount;
    [self.historySlider setValue:self.flipCount animated:YES];
    self.sliderMaxValue.text = [NSString stringWithFormat:@"%d", (int)self.historySlider.maximumValue];
}

- (void)updateFlipResult
{
    NSString *text = @"";
    if ([self.game.matchedCards count] > 0) {
        text = [text stringByAppendingString:[[self.game.matchedCards valueForKey:@"contents"] componentsJoinedByString:@" "]];
        if ([self.game.matchedCards count] == [self numberOfPicked]) {
            if (self.game.lastFlipPoints < 0) {
                text = [text stringByAppendingString:[NSString stringWithFormat:@"Penalty: -%ld", self.game.lastFlipPoints]];
            } else {
                text = [text stringByAppendingString:[NSString stringWithFormat:@"Bonus: +%ld", self.game.lastFlipPoints]];
            }
        } else {
            text = [self textForSingleCard];
        }
        [self.flipsHistory addObject:text];
    } else {
        text = @"Start";
    }
    self.resultsLabel.text = text;
}

- (NSString *)textForSingleCard
{
    Card *card = [self.game.matchedCards lastObject];
    return [NSString stringWithFormat:@" %@ flipped", card.contents];
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : nil;
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
