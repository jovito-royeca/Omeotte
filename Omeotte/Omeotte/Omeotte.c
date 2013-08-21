//
//  Omeotte.c
//  Omeotte
//
//  Created by Jovito Royeca on 8/21/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#include <stdio.h>

#include "Omeotte.h"

int get_statsfield(StatFields field, Stats stats)
{
    switch (field)
    {
        case CurrentTower:
        {
            return stats->tower;
        }
        case CurrentWall:
        {
            return stats->wall;
        }
        case CurrentBricks:
        {
            return stats->bricks;
        }
        case CurrentGems:
        {
            return stats->gems;
        }
        case CurrentRecruits:
        {
            return stats->recruits;
        }
        case CurrentQuarries:
        {
            return stats->quarries;
        }
        case CurrentMagics:
        {
            return stats->magics;
        }
        case CurrentDungeons:
        {
            return stats->dungeons;
        }
        case None:
        default:
        {
            return 0;
        }
    }
}

void set_statsfield(StatFields field, int value, Stats current, Stats opponent)
{
    switch (field)
    {
        case CurrentTower:
        {
            current->tower += value;
            break;
        }
        case CurrentWall:
        {
            current->wall += value;
            break;
        }
        case CurrentBricks:
        {
            current->bricks += value;
            break;
        }
        case CurrentGems:
        {
            current->gems += value;
            break;
        }
        case CurrentRecruits:
        {
            current->recruits += value;
            break;
        }
        case CurrentQuarries:
        {
            current->quarries += value;
            break;
        }
        case CurrentMagics:
        {
            current->magics += value;
            break;
        }
        case CurrentDungeons:
        {
            current->dungeons += value;
            break;
        }
        case OpponentTower:
        {
            opponent->tower += value;
            break;
        }
        case OpponentWall:
        {
            opponent->wall += value;
            break;
        }
        case OpponentBricks:
        {
            opponent->bricks += value;
            break;
        }
        case OpponentGems:
        {
            opponent->gems += value;
            break;
        }
        case OpponentRecruits:
        {
            opponent->recruits += value;
            break;
        }
        case OpponentQuarries:
        {
            opponent->quarries += value;
            break;
        }
        case OpponentMagics:
        {
            opponent->magics += value;
            break;
        }
        case OpponentDungeons:
        {
            opponent->dungeons += value;
            break;
        }
        case None:
        {
            break;
        }
    }
}

void set_stats(Stats src, Stats dest)
{
    dest->tower    += src->tower;
    dest->wall     += src->wall;
    dest->bricks   += src->bricks;
    dest->gems     += src->gems;
    dest->recruits += src->recruits;
    dest->quarries += src->quarries;
    dest->magics   += src->magics;
    dest->dungeons += src->dungeons;
}

int compare(int op1, int op2)
{
    int result = 0;
    
    if (op1 < op2)
    {
        result = -1;
    }
    else if (op1 == op2)
    {
        result = 0;
    }
    else if (op1 > op2)
    {
        result = 1;
    }
    
    return result;
}

void do_ops(Ops ops, Stats current, Stats opponent)
{
    int op1Value = get_statsfield(ops->op1, current);
    int opValue2 = get_statsfield(ops->op2, current);
    int opResult = compare(op1Value, opValue2);
    
    switch (ops->opType)
    {
        case Eval:
        {
            if (opResult == ops->opResult)
            {
                set_statsfield(ops->opTarget, ops->opResult, current, opponent);
            }
            break;
        }
        case Eq:
        {
            break;
        }
        default:
            break;
    }
}
