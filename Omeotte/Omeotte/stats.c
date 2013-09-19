//
//  Omeotte.c
//  Omeotte
//
//  Created by Jovito Royeca on 9/18/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#include <stdlib.h>

#include "Omeotte.h"

OStats createStats()
{
    OStats stats = (OStats) malloc(sizeof(OStats));

    if (stats)
    {
        stats->tower = 0;
        stats->wall = 0;
        stats->bricks = 0;
        stats->gems = 0;
        stats->recruits = 0;
        stats->quarries = 0;
        stats->magics = 0;
        stats->dungeons = 0;
    
        return stats;
    }

    return 0;
}

OEffect createEffect()
{
    OEffect effect = (OEffect) malloc(sizeof(OEffect));
    
    if (effect)
    {
        effect->field = None;
        effect->value = 0;
        effect->target = Current;
    
        return effect;
    }
    
    return 0;
}

void applyEffect(OStats current, OStats opponent, OEffect effect)
{
    switch (effect->target)
    {
        case Current:
        {
            setStatsField(current, effect->field, effect->value);
            break;
        }
        case Opponent:
        {
            setStatsField(opponent, effect->field, effect->value);
            break;
        }
    }
}

void evaluate(OStats current, OStats opponent, OEval eval)
{
    
}

int statsField(OStats stats, OStatsField field)
{
    switch (field)
    {
        case Tower:
        {
            return stats->tower;
        }
        case Wall:
        {
            return stats->wall;
        }
        case Bricks:
        {
            return stats->bricks;
        }
        case Gems:
        {
            return stats->gems;
        }
        case Recruits:
        {
            return stats->recruits;
        }
        case Quarries:
        {
            return stats->quarries;
        }
        case Magics:
        {
            return stats->magics;
        }
        case Dungeons:
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

void setStatsField(OStats stats, OStatsField field, int value)
{
    switch (field)
    {
        case Tower:
        {
            stats->tower += value;
            break;
        }
        case Wall:
        {
            stats->wall += value;
            
            if (stats->wall < 0)
            {
                stats->tower += stats->wall;
                stats->wall = 0;
            }
            break;
        }
        case Bricks:
        {
            stats->bricks += value;
            
            if (stats->bricks < 0)
            {
                stats->bricks = 0;
            }
            break;
        }
        case Gems:
        {
            stats->gems += value;
            
            if (stats->gems < 0)
            {
                stats->gems = 0;
            }
            break;
        }
        case Recruits:
        {
            stats->recruits += value;
            
            if (stats->recruits < 0)
            {
                stats->recruits = 0;
            }
            break;
        }
        case Quarries:
        {
            stats->quarries += value;
            
            if (stats->quarries < 0)
            {
                stats->quarries = 0;
            }
            break;
        }
        case Magics:
        {
            stats->magics += value;
            
            if (stats->magics < 0)
            {
                stats->magics = 0;
            }
            break;
        }
        case Dungeons:
        {
            stats->dungeons += value;
            
            if (stats->dungeons < 0)
            {
                stats->dungeons = 0;
            }
            break;
        }
        case None:
        default:
        {
            break;
        }
    }
}

void setStats(OStats dest, OStats src)
{
    setStatsField(dest, Tower, src->tower);
    setStatsField(dest, Wall, src->wall);
    setStatsField(dest, Bricks, src->bricks);
    setStatsField(dest, Gems, src->gems);
    setStatsField(dest, Recruits, src->recruits);
    setStatsField(dest, Quarries, src->quarries);
    setStatsField(dest, Magics, src->magics);
    setStatsField(dest, Dungeons, src->dungeons);
}
