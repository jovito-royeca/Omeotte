//
//  Stats.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/23/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "Stats.h"

@implementation Stats

@synthesize tower;
@synthesize wall;

@synthesize bricks;
@synthesize gems;
@synthesize recruits;

@synthesize quarries;
@synthesize magics;
@synthesize dungeons;

+(void) applyEffect:(Effect)effect onCurrent:(Stats*)current  orOpponent:(Stats*) opponent
{
    switch (effect->target)
    {
        case Current:
        {
            [current setStatField:effect->field withValue:effect->value];
            break;
        }
        case Opponent:
        {
            [opponent setStatField:effect->field withValue:effect->value];
            break;
        }
    }
}

+(void) evaluate:(Eval)eval onCurrent:(Stats*) current  orOpponent:(Stats*) opponent
{
    
}

-(int) statField:(StatField)field
{
    switch (field)
    {
        case Tower:
        {
            return self.tower;
        }
        case Wall:
        {
            return self.wall;
        }
        case Bricks:
        {
            return self.bricks;
        }
        case Gems:
        {
            return self.gems;
        }
        case Recruits:
        {
            return self.recruits;
        }
        case Quarries:
        {
            return self.quarries;
        }
        case Magics:
        {
            return self.magics;
        }
        case Dungeons:
        {
            return self.dungeons;
        }
        case None:
        default:
        {
            return 0;
        }
    }
}

-(void) setStatField:(StatField)field withValue:(int)value
{
    switch (field)
    {
        case Tower:
        {
            self.tower += value;
            break;
        }
        case Wall:
        {
            self.wall += value;
            
            if (self.wall < 0)
            {
                self.tower += self.wall;
                self.wall = 0;
            }
            break;
        }
        case Bricks:
        {
            self.bricks += value;
            
            if (self.bricks < 0)
            {
                self.bricks = 0;
            }
            break;
        }
        case Gems:
        {
            self.gems += value;
            
            if (self.gems < 0)
            {
                self.gems = 0;
            }
            break;
        }
        case Recruits:
        {
            self.recruits += value;
            
            if (self.recruits < 0)
            {
                self.recruits = 0;
            }
            break;
        }
        case Quarries:
        {
            self.quarries += value;
            
            if (self.quarries < 0)
            {
                self.quarries = 0;
            }
            break;
        }
        case Magics:
        {
            self.magics += value;
            
            if (self.magics < 0)
            {
                self.magics = 0;
            }
            break;
        }
        case Dungeons:
        {
            self.dungeons += value;
            
            if (self.dungeons < 0)
            {
                self.dungeons = 0;
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



-(void) setStats:(Stats*)src
{
    [self setStatField:Tower withValue:src.tower];
    [self setStatField:Wall withValue:src.wall];
    [self setStatField:Bricks withValue:src.bricks];
    [self setStatField:Gems withValue:src.gems];
    [self setStatField:Recruits withValue:src.recruits];
    [self setStatField:Quarries withValue:src.quarries];
    [self setStatField:Magics withValue:src.magics];
    [self setStatField:Dungeons withValue:src.dungeons];
}

-(int) compare:(int)op1 with:(int)op2
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

@end
