//
//  player.c
//  Omeotte
//
//  Created by Jovito Royeca on 9/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#include <stdlib.h>

#include "LinkedList.h"
#include "Omeotte.h"

OPlayer createPlayer()
{
    OPlayer player = (OPlayer) malloc(sizeof(OPlayer));
    
    player->base = createStats();
    player->hand = ll_create();
    player->deck = createDeck();
    shuffle(player->deck);
    
    return player;
}

LinkedList draw(OPlayer player, int num)
{
    LinkedList cards = ll_create();
    
    for (int i=0; i<num; i++)
    {
        OCard card = drawOnTop(player->deck);
        
        for (int j=0; j<NARRAY(player->hand); j++)
        {
            if (ll_get(player->hand, j) == NULL)
            {
                ll_addAtIndex(player->hand, card, j);
                break;
            }
        }

        ll_add(cards, card);
    }
    return cards;
}

int shouldDiscard(OPlayer player, int maxHand)
{
    int canPlay = 0;
    
    for (int i=0; i<NARRAY(player->hand); i++)
    {
        canPlay = canPlayCard(player, ll_get(player->hand, i));
        
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
    LinkedList cards = ll_create();
    
    for (int i=0; i<NARRAY(player->hand); i++)
    {
        OCard card = ll_get(player->hand, i);
        
        if (canPlayCard(player, card))
        {
            ll_add(cards, card);
        }
    }
    
    int count = ll_size(cards);
    if (count == 0)
    {
        return NULL;
    }
    else if (count == 1)
    {
        return ll_get(cards, 0);
    }
    else if (count > 1)
    {
        int random = randomNumber(1, count);
        return ll_get(cards, random);
    }
    else
    {
        return NULL;
    }
}

OCard chooseCardToDiscard(OPlayer player)
{
    OCard highest = NULL;
    
    for (int i=0; i<NARRAY(player->hand); i++)
    {
        OCard card = ll_get(player->hand, i);
        
        if (highest)
        {
            if (totalCost(card) > totalCost(highest))
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

void playCard(OPlayer player, OCard card, OPlayer target)
{
    player->base->bricks -= card->cost->bricks;
    player->base->gems -= card->cost->gems;
    player->base->recruits -= card->cost->recruits;
    
    if (card->effects)
    {
        for (int i=0; i<ll_size(card->effects); i++)
        {
            OEffect e = ll_get(card->effects, i);
            
            switch (e->target)
            {
                case Current:
                {
                    setStatsField(player->base, e->field, e->value);
                    break;
                }
                case Opponent:
                {
                    setStatsField(target->base, e->field, e->value);
                    break;
                }
            }
        }
    }
    
    // To Do: handle ops
    // ...
    
    discardCard(player, card);
}

void discardCard(OPlayer player, OCard card)
{
    ll_remove(player->hand, card);
    discard(player->deck, card);
}
