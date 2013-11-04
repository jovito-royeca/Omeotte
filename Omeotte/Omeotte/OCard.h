//
//  OCard.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import  <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

#import "Omeotte.h"
#import "OStats.h"

typedef enum
{
    Quarry = 0,
    Magic,
    Dungeon,
    Mixed
} CardType;

typedef enum
{
    CardPlayAnother = 0,
    CardUndiscardable,
    CardDraw,
    CardDiscard
} CardSpecialPower;

@interface OCard : NSObject

@property(strong, nonatomic) NSString *name;
@property(assign, nonatomic) OStats *cost;
@property(strong, nonatomic) NSString *text;
@property(nonatomic) CardType type;
@property(assign,nonatomic) Eval eval;
@property(strong,nonatomic) NSMutableArray *effects;
@property(strong,nonatomic) NSMutableArray *specialPowers;

+(NSArray*) allCards;
+(NSArray*) onlyThisCard:(NSString*)cardName;
+(NSString*) specialPowerName:(CardSpecialPower)sp;

-(int) totalCost;
-(int) totalDamage;
-(NSString*) canonicalText;
-(BOOL) hasSpecialPower:(CardSpecialPower)sp;

@end
