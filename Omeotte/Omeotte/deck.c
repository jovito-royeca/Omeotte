//
//  deck.c
//  Omeotte
//
//  Created by Jovito Royeca on 9/18/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#include <stdlib.h>

#include "Omeotte.h"

ODeck createDeck()
{
    ODeck deck = (ODeck) malloc(sizeof(ODeck));
    
    deck->cardsInLibrary =  ll_create();
    deck->cardsInGraveyard = ll_create();
    
    LinkedList cards = allCards();
        
    for (int i=0; i<MAX_DECK_SIZE; i++)
    {
        int random = randomNumber(0, MAX_DECK_SIZE-1);
            
        deck->cardsInLibrary[i] = cards[random];
        ll_addAtIndex(deck->cardsInLibrary, ll_get(cards, random), i);
    }
    
    return deck;
}

void shuffle(ODeck deck)
{
    
}

OCard drawOnTop(ODeck deck)
{
    int last = ll_size(deck->cardsInLibrary)-1;
    OCard card = ll_get(deck->cardsInLibrary, last);
    
    ll_removeAtIndex(deck->cardsInLibrary, last);
    return card;
}

OCard drawRandom(ODeck deck)
{
    int random = randomNumber(0, ll_size(deck->cardsInLibrary));
    OCard card = ll_get(deck->cardsInLibrary, random);
    
    ll_removeAtIndex(deck->cardsInLibrary, random);
    return card;
}

void discard(ODeck deck, OCard card)
{
    ll_add(deck->cardsInGraveyard, card);
}
