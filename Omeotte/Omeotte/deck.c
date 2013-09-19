//
//  deck.c
//  Omeotte
//
//  Created by Jovito Royeca on 9/18/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#include "Omeotte.h"

void initDeck(ODeck deck)
{
    deck->cardsInLibrary =  malloc(MAX_DECK_SIZE * sizeof(ODeck));
    deck->cardsInGraveyard = malloc(MAX_DECK_SIZE * sizeof(ODeck));
    
    OCard *cards = allCards();
        
    for (int i=0; i<MAX_DECK_SIZE; i++)
    {
        int random = randomNumber(0, MAX_DECK_SIZE-1);
            
        deck->cardsInLibrary[i] = cards[random];
    }
}

void shuffle(ODeck deck)
{
    
}

OCard drawOnTop(ODeck deck)
{
//    OCard *card = [cardsInLibrary objectAtIndex:[cardsInLibrary count]-1];
    int last = NARRAY(deck->cardsInLibrary)-1;
    OCard card = deck->cardsInLibrary[last];
    
    deck->cardsInLibrary[last] = NULL;
    return card;
}

OCard drawRandom(ODeck deck)
{
    int random = randomNumber(0, NARRAY(deck->cardsInLibrary));
    OCard card = deck->cardsInLibrary[random];
    
    deck->cardsInLibrary[random] = NULL;
    return card;
}

void discard(ODeck deck, OCard card)
{
    for (int i=0; i<MAX_DECK_SIZE; i++)
    {
        if (deck->cardsInGraveyard[i] == NULL)
        {
            deck->cardsInGraveyard[i] = card;
            break;
        }
    }
}
