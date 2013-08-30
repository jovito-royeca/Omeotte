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
    return [hand count] < maxHand;
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
    
    NSUInteger random = arc4random() % [cards count];
    return [cards objectAtIndex:random];
}

-(OCard*) chooseCardToDiscard
{
    NSMutableArray *cards = [[NSMutableArray alloc] init];
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
