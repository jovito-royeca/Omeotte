//
//  Stats.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/23/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#define create(X) ((X)malloc(sizeof(X)))

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
} StatField;

typedef enum
{
    Current = 0,
    Opponent,
} EffectTarget;

typedef struct _Effect
{
    StatField field;
    int value;
    EffectTarget target;
} *Effect;

typedef struct _Eval
{
    Effect op1;
    Effect op2;
    Effect lesserThanResult;
    Effect equalsResult;
    Effect greaterThanResult;
} *Eval;

@interface OStats : NSObject

@property(nonatomic) int tower;
@property(nonatomic) int wall;

@property(nonatomic) int bricks;
@property(nonatomic) int gems;
@property(nonatomic) int recruits;

@property(nonatomic) int quarries;
@property(nonatomic) int magics;
@property(nonatomic) int dungeons;

+(void) applyEffect:(Effect)effect onCurrent:(OStats*)current  orOpponent:(OStats*) opponent;

+(void) evaluate:(Eval)eval onCurrent:(OStats*) current  orOpponent:(OStats*) opponent;

-(int) statField:(StatField)field;

-(void) setStatField:(StatField)field withValue:(int)value;

-(void) setStats:(OStats*)src;

-(int) compare:(int)op1 with:(int)op2;

@end
