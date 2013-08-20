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
    return
        self.base->bricks   >= card.cost.bricks &&
        self.base->gems     >= card.cost.gems &&
        self.base->recruits >= card.cost.recruits;
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
    target.base->tower    += card.damage->tower;
    target.base->wall     += card.damage->wall;
    target.base->bricks   += card.damage->bricks;
    target.base->gems     += card.damage->gems;
    target.base->recruits += card.damage->recruits;
    target.base->quarries += card.damage->quarries;
    target.base->magics   += card.damage->magics;
    target.base->dungeons += card.damage->dungeons;
    
    self.base->tower    += card.bonus->tower;
    self.base->wall     += card.bonus->wall;
    self.base->bricks   += card.bonus->bricks;
    self.base->gems     += card.bonus->gems;
    self.base->recruits += card.bonus->recruits;
    self.base->quarries += card.bonus->quarries;
    self.base->magics   += card.bonus->magics;
    self.base->dungeons += card.bonus->dungeons;
    
    if (card.drawCard)
    {
        [self draw];
    }
    
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
