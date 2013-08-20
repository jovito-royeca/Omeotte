//
//  OPlayer.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OPlayer.h"

@implementation OPlayer

@synthesize bricks;
@synthesize gems;
@synthesize recruits;

@synthesize mines;
@synthesize magics;
@synthesize dungeons;

@synthesize tower;
@synthesize wall;

@synthesize cardsInHand;
@synthesize deck;

-(BOOL) canPlayCard:(OCard*)card
{
    return self.bricks >= card.cost.bricks &&
    self.gems >= card.cost.gems &&
    self.recruits >= card.cost.recruits;
}

-(BOOL) canDrawCard
{
    return [[self cardsInHand] count] < 6;
}

-(void) play:(OCard*)card onTarget:(OPlayer*)target
{
    target.bricks   += card.damage.bricks;
    target.gems     += card.damage.gems;
    target.recruits += card.damage.recruits;
    target.mines    += card.damage.mines;
    target.magics   += card.damage.magics;
    target.dungeons += card.damage.dungeons;
    target.tower    += card.damage.tower;
    target.wall     += card.damage.wall;
    
    self.bricks   += card.bonus.bricks;
    self.gems     += card.bonus.gems;
    self.recruits += card.bonus.recruits;
    self.mines    += card.bonus.mines;
    self.magics   += card.bonus.magics;
    self.dungeons += card.bonus.dungeons;
    self.tower    += card.bonus.tower;
    self.wall     += card.bonus.wall;
    
    if (card.bonus.drawCard)
    {
        
    }
    
    if (card.bonus.turnAgain)
    {
        
    }
}

@end
