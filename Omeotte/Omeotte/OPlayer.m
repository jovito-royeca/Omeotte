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
@synthesize delegate;

-(id) init
{
    self = [super init];

    if (self)
    {
        base = [[OStats alloc] init];
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
    [delegate showHand];
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
    [delegate showHand];
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

            StatField targetField = (e.field == Wall && target.base.wall <= 0) ?
                Tower : e.field;
            
            switch (e.target)
            {
                case Current:
                {
                    [delegate statChanged:targetField fieldValue:[base statField:e.field] modValue:e.value player:self];
                    [base setStatField:targetField withValue:e.value];
                    break;
                }
                case Opponent:
                {
                    [delegate statChanged:e.field fieldValue:[target.base statField:e.field] modValue:e.value player:target];
                    [target.base setStatField:targetField withValue:e.value];
                    break;
                }
            }
        }
    }
    
    // To Do: handle ops
    // ...
    
    [hand removeObject:card];
    [deck discard:card];
    [delegate putCardToGraveyard:card discarded:NO];
    [delegate showHand];
}

-(void) discard:(OCard*)card
{
    [hand removeObject:card];
    [deck discard:card];
    [delegate putCardToGraveyard:card discarded:YES];
    [delegate showHand];
}

//+(NSString*) description
//{
//    return [NSString stringWithFormat:@"tower=%d, wall=%d, bricks=%d, gems=%d, recruits=%d, quarries=%d, magics=%d, dungeons=%d",
//            base.tower, self.base.wall, self.base.bricks, self.base.gems, self.base.recruits, self.base.quarries, self.base.magics, self.base.dungeons];
//}

@end
