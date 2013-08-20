//
//  OPlayer.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OPlayer.h"

@implementation OPlayer

@synthesize base;
@synthesize cardsInHand;
@synthesize deck;

-(id) init
{
    self = [super init];

    if (self)
    {
        base = create_stats;
        cardsInHand = [[NSMutableArray alloc] initWithCapacity:MAX_PLAYER_HAND];
        deck = [[ODeck alloc] init];
        
        [deck shuffle];
    }
    return self;
}

-(void) drawInitialHand:(int)maxHand
{
    for (int i=0; i<maxHand; i++)
    {
        [self draw];
    }
}

-(BOOL) shouldDiscard:(int)maxHand
{
    return [[self cardsInHand] count] < maxHand;
}

-(BOOL) canPlayCard:(OCard*)card
{
    switch (card.type)
    {
        case (OQuarry):
        {
            return self.base->bricks >= card.cost;
        }
        case (OMagic):
        {
            return self.base->gems >= card.cost;
        }
        case (ODungeon):
        {
            return self.base->recruits >= card.cost;
        }
        default:
            return NO;
    }
}

-(void) draw
{
    [[self cardsInHand] addObject:[deck drawOnTop]];
}

-(OCard*) chooseCardToPlay
{
    return nil;
}

-(OCard*) chooseCardToDiscard
{
    return nil;
}

-(void) play:(OCard*)card onTarget:(OPlayer*)target
{
    set_stats(self.base, card.currentPlayer);
    set_stats(target.base, card.opponent);
    
    if (card.playAgain)
    {
        
    }
}

-(void) discard:(OCard*)card
{
    [[self cardsInHand] removeObject:card];
    [[self deck] discard:card];
}

@end
