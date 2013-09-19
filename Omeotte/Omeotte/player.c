//
//  player.c
//  Omeotte
//
//  Created by Jovito Royeca on 9/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#include "Omeotte.h"

void initPlayer(OPlayer player)
{
    OStats base;
    initStats(base);
    player->base = base;
    player->hand = malloc(MAX_CARDS_IN_HAND * sizeof(OCard));
    
    ODeck deck;
    initDeck(deck);
    player->deck = deck;
    shuffle(player->deck);
}

OCard* draw(OPlayer player, int num)
{
    OCard* cards =  malloc(num * sizeof(OCard));
    
    for (int i=0; i<num; i++)
    {
        OCard card = drawOnTop(player->deck);
        
        for (int j=0; j<NARRAY(player->hand); j++)
        {
            if (player->hand[j] == NULL)
            {
                player->hand[j] = card;
                break;
            }
        }
        cards[i] = card;
    }
    return cards;
}

int shouldDiscard(OPlayer player, int maxHand)
{
    int canPlay = 0;
    
    for (int i=0; i<NARRAY(player->hand); i++)
    {
        canPlay = canPlayCard(player, player->hand[i]);
        
        if (canPlay)
            break;
    }
    
    
    
    return NARRAY(player->hand) >= maxHand && !canPlay;
}

int canPlayCard(OPlayer player, OCard card)
{
    return player->base->bricks >= card->cost->bricks &&
    player->base->gems >= card->cost->gems &&
    player->base->recruits >= card->cost->recruits;
}

void upkeep(OPlayer player)
{
    player->base->bricks += player->base->quarries;
    player->base->gems += player->base->magics;
    player->base->recruits += player->base->dungeons;
}

OCard chooseCardToPlay(OPlayer player)
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
    base->bricks -= card.cost->bricks;
    base->gems -= card.cost->gems;
    base->recruits -= card.cost->recruits;
    
    if (card.effects)
    {
        for (int i=0; i<card.effects.count; i++)
        {
            struct _OEffect e;
            [[card.effects objectAtIndex:i] getValue:&e];
            
            switch (e.target)
            {
                case Current:
                {
                    setStatsField(base, e.field, e.value);
                    break;
                }
                case Opponent:
                {
                    setStatsField(target.base, e.field, e.value);
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