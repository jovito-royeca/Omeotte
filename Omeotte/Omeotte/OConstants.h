//
//  OConstants.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/20/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#ifndef Omeotte_OConstants_h
#define Omeotte_OConstants_h


#define MAX_PLAYER_HAND 6

#define DECK_SIZE       500

#define create_stats ((Stats)malloc(sizeof(Stats)))

#define set_stats(X,Y) ({ \
    (X)->tower    += (Y)->tower; \
    (X)->wall     += (Y)->wall; \
    (X)->bricks   += (Y)->bricks; \
    (X)->gems     += (Y)->gems; \
    (X)->recruits += (Y)->recruits; \
    (X)->quarries += (Y)->quarries; \
    (X)->magics   += (Y)->magics; \
    (X)->dungeons += (Y)->dungeons; })

typedef struct
{
    int tower;
    int wall;
    
    int bricks;
    int gems;
    int recruits;
    
    int quarries;
    int magics;
    int dungeons;
} *Stats;

#endif
