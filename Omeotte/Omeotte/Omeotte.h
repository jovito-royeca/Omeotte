//
//  Omeotte.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/21/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#ifndef Omeotte_Omeotte_h
#define Omeotte_Omeotte_h

#define MAX_PLAYER_HAND 6

#define DECK_SIZE       500

enum
{
    Quarry = 0,
    Magic,
    Dungeon
};
typedef int CardType;

typedef struct _Stats
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

typedef enum
{
    CurrentTower     = 0,
    CurrentWall      = 1,
    CurrentBricks    = 2,
    CurrentGems      = 3,
    CurrentRecruits  = 4,
    CurrentQuarries  = 5,
    CurrentMagics    = 6,
    CurrentDungeons  = 7,
    OpponentTower    = 8,
    OpponentWall     = 9,
    OpponentBricks   = 10,
    OpponentGems     = 11,
    OpponentRecruits = 12,
    OpponentQuarries = 13,
    OpponentMagics   = 14,
    OpponentDungeons = 15,
    None             = -1
} StatFields;

enum
{
    Eval = 0,
    Eq,
};
typedef int OpType;

typedef struct _Ops
{
    int op1;
    int op2;
    int opResult;
    int opTarget;
    int opValue;
    OpType opType;
} *Ops;

#define create_stats ((Stats)malloc(sizeof(Stats)))
#define create_ops  ((Ops)malloc(sizeof(Ops)))

int get_statsfield(StatFields field, Stats stats);
void set_statsfield(StatFields field, int value, Stats current, Stats opponent);
void set_stats(Stats src, Stats dest);
int compare(int op1, int op2);
void do_ops(Ops ops, Stats current, Stats opponent);

#endif
