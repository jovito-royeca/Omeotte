//
//  OPlayer.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OPlayer.h"

@implementation OPlayer

@synthesize name;
@synthesize base;
@synthesize hand;
@synthesize deck;
@synthesize ai;

-(id) init
{
    self = [super init];

    if (self)
    {
        base = [[Stats alloc] init];
        hand = [[NSMutableArray alloc] initWithCapacity:6];
        deck = [[ODeck alloc] init];
        
        [deck shuffle];
    }
    return self;
}

-(NSArray*) draw:(int)num
{
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    
    for (int i=0; i<num; i++)
    {
        OCard *card = [deck drawOnTop];
        
        [hand addObject:card];
        [cards addObject:card];
    }
    return cards;
}

-(BOOL) shouldDiscard:(int)maxHand
{
    BOOL canPlay = NO;

    for (OCard* card in hand)
    {
        canPlay = [self canPlayCard:card];

        if (canPlay)
            break;
    }

    return [hand count] >= maxHand && !canPlay;
}

-(BOOL) canPlayCard:(OCard*)card
{
    return self.base.bricks >= card.cost.bricks &&
           self.base.gems >= card.cost.gems &&
           self.base.recruits >= card.cost.recruits;
}

-(void) upkeep
{
    self.base.bricks += self.base.quarries;
    self.base.gems += self.base.magics;
    self.base.recruits += self.base.dungeons;
}

-(OCard*) chooseCardToPlay
{
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    
    for (OCard *card in hand)
    {
        if ([self canPlayCard:card])
        {
            [cards addObject:card];
        }
    }
    
    if (cards.count == 0)
    {
        return nil;
    }
    else if (cards.count == 1)
    {
        return [cards objectAtIndex:0];
    }
    else if (cards.count > 1)
    {
        NSUInteger random = arc4random() % [cards count];
        return [cards objectAtIndex:random];
    }
    else
    {
        return nil;
    }
}

-(OCard*) chooseCardToDiscard
{
    OCard *highest = nil;
    
    for (OCard *card in hand)
    {
        if (highest)
        {
            if (card.totalCost > highest.totalCost)
            {
                highest = card;
            }
        }
        else
        {
            highest = card;
        }
    }
    
    return highest;
}

-(void) play:(OCard*)card onTarget:(OPlayer*)target
{
    base.bricks -= card.cost.bricks;
    base.gems -= card.cost.gems;
    base.recruits -= card.cost.recruits;
    
    if (card.effects)
    {
        for (int i=0; i<card.effects.count; i++)
        {
            struct _Effect e;
            [[card.effects objectAtIndex:i] getValue:&e];

            switch (e.target)
            {
                case Current:
                {
                    [base setStatField:e.field withValue:e.value];
                    break;
                }
                case Opponent:
                {
                    [target.base setStatField:e.field withValue:e.value];
                    break;
                }
            }
        }
    }
    
    // To Do: handle ops
    // ...
    
    [self discard:card];
}

-(void) discard:(OCard*)card
{
    [hand removeObject:card];
    [deck discard:card];
}

//+(NSString*) description
//{
//    return [NSString stringWithFormat:@"tower=%d, wall=%d, bricks=%d, gems=%d, recruits=%d, quarries=%d, magics=%d, dungeons=%d",
//            base.tower, self.base.wall, self.base.bricks, self.base.gems, self.base.recruits, self.base.quarries, self.base.magics, self.base.dungeons];
//}

@end
