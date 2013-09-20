//
//  Omeotte.h
//  Deck of Omeotte
//
//  Created by Jovito Royeca on 9/4/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#include <math.h>
#include <stdlib.h>

#include "LinkedList.h"

#ifndef Omeotte_h
#define Omeotte_h

#ifdef __cplusplus
extern "C" {
#endif

#define GAME_TITLE    @"Deck of Omeotte"

#define MAX_DECK_SIZE           500
#define MAX_CARDS_IN_HAND       6

#define NARRAY(x)  (sizeof(x) / sizeof(x[0]))

typedef enum
{
    None     = -1,
    Tower    = 0,
    Wall     = 1,
    Bricks   = 2,
    Gems     = 3,
    Recruits = 4,
    Quarries = 5,
    Magics   = 6,
    Dungeons = 7
} OStatsField;

typedef enum
{
    Current = 0,
    Opponent,
} OEffectTarget;

typedef struct _OEffect
{
    OStatsField field;
    int value;
    OEffectTarget target;
} *OEffect;

typedef struct _OEval
{
    OEffect op1;
    OEffect op2;
    OEffect lesserThanResult;
    OEffect equalsResult;
    OEffect greaterThanResult;
} *OEval;

typedef struct _OStats
{
    int tower;
    int wall;

    int bricks;
    int gems;
    int recruits;

    int quarries;
    int magics;
    int dungeons;
} *OStats;

typedef enum
{
    Quarry = 0,
    Magic,
    Dungeon,
    Mixed
} OCardType;

typedef struct _OCard
{
    char *name;
    OStats cost;
    char *text;
    int playAgain;
    OCardType type;
    LinkedList effects;
    OEval eval;
} *OCard;

typedef struct _ODeck
{
    LinkedList cardsInLibrary;
    LinkedList cardsInGraveyard;
    
} *ODeck;

typedef struct _OPlayer
{
    char* name;
    OStats base;
    LinkedList hand;
    ODeck deck;
    int ai;
} *OPlayer;

typedef struct _ORule
{
    char *name;
    char *location;
    OStats base;
    int cardsInHand;
    int winningTower;
    int winningResource;
    int price;
} *ORule;
    
/* OStats functions */
OStats createStats();
OEffect createEffect();
void applyEffect(OStats current, OStats opponent, OEffect effect);
void evaluate(OStats current, OStats opponent, OEval eval);
int statsField(OStats stats, OStatsField field);
void setStatsField(OStats stats, OStatsField field, int value);
void setStats(OStats dest, OStats src);

/* OCard functions */
OCard createCard();
LinkedList allCards();
int totalCost(OCard card);

/* ODeck functions */
ODeck createDeck();
void shuffle(ODeck deck);
OCard drawOnTop(ODeck deck);
OCard drawRandom(ODeck deck);
void discard(ODeck deck, OCard card);

/* OPlayer functions */
OPlayer createPlayer();
int shouldDiscard(OPlayer player, int maxHand);
int canPlayCard(OPlayer player, OCard card);
LinkedList draw(OPlayer player, int num);
void upkeep(OPlayer player);
OCard chooseCardToPlay(OPlayer player);
OCard chooseCardToDiscard(OPlayer player);
void playCard(OPlayer player, OCard card, OPlayer target);
void discardCard(OPlayer player, OCard card);

/* ORule functions */
LinkedList allRules();

/* Miscellaneous functions */
int compare(int op1, int op2);
int randomNumber(int min, int max);

#ifdef __cplusplus
}
#endif

#endif
