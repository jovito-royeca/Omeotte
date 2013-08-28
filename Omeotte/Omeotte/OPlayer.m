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
        base = [[Stats alloc] init];
        cardsInHand = [[NSMutableArray alloc] initWithCapacity:6];
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
    return self.base.bricks >= card.cost.bricks &&
           self.base.gems >= card.cost.gems &&
           self.base.recruits >= card.cost.recruits;
}

-(void) draw
{
    [[self cardsInHand] addObject:[deck drawOnTop]];
}

-(void) startTurn
{
    self.base.bricks += self.base.quarries;
    self.base.gems += self.base.magics;
    self.base.recruits += self.base.dungeons;
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
    /*if (card.ops)
    {
        int i, count = [card.ops count];
        
        for (i=0; i<count; i++)
        {
            struct _Ops o;
            [[card.ops objectAtIndex:i] getValue:&o];
            do_ops(&o, self.base, target.base);
        }
    }

    if (card.statFields)
    {
        for (NSNumber *i in [card.statFields allKeys])
        {
            int w = [i intValue];
            int x = [[card.statFields objectForKey:i] intValue];
            Stats y = self.base;
            Stats z = target.base;
        
            set_statsfield(w, x, y, z);
        }
    }

    if (card.playAgain)
    {
     
    }*/
}

-(void) discard:(OCard*)card
{
    [[self cardsInHand] removeObject:card];
    [[self deck] discard:card];
}

@end
