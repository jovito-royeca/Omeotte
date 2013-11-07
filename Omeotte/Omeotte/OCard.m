//
//  OCard.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OCard.h"

@implementation OCard

@synthesize name;
@synthesize cost;
@synthesize text;
@synthesize type;
@synthesize effects;
@synthesize specialPowers;
@synthesize eval;

- (id) init
{
    if ((self = [super init]))
    {
        eval = create(Eval);
    }
    return self;
}

- (void)dealloc
{
    free(eval);
    
//    if (effects)
//    {
//        for (int i=0; i<effects.count; i++)
//        {
//            struct _Effect e;
//            [[effects objectAtIndex:i] getValue:&e];
//            [effects removeObjectAtIndex:i];
//            free(&e);
//        }
//    }
    
    [specialPowers release];
    [super dealloc];
}

+(NSArray*)allCards
{
    NSArray *arrCards;
    
    NSMutableArray *mArrCards = [[NSMutableArray alloc] init];
    
    for (NSString *card in [NSArray arrayWithObjects:@"quarry", @"magic", @"dungeon", nil])
    {
        NSString *plistPath;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                      NSUserDomainMask, YES) objectAtIndex:0];
        plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"data/%@.plist", card]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
        {
            plistPath = [[NSBundle mainBundle] pathForResource:card ofType:@"plist"];
        }
            
        NSMutableArray *mArr = [NSMutableArray arrayWithContentsOfFile:plistPath];
        for (NSDictionary *dict in mArr)
        {
            BOOL bBanned = NO;
            NSString *cardName = [dict valueForKey:@"name"];

#ifdef CARDS_TO_BAN
            NSArray *arrBanned = CARDS_TO_BAN;
            for (NSString *banned in arrBanned)
            {
                if ([cardName isEqualToString:banned])
                {
                    bBanned = YES;
                }
            }
#endif
            if (bBanned)
            {
                continue;
            }

            OCard *card = [[OCard alloc] init];
            
            card.name = cardName;

            NSDictionary *costDict = [dict valueForKey:@"cost"];
            OStats *cost = [[OStats alloc] init];
            if ([costDict objectForKey:@"bricks"])
            {
                cost.bricks = [[costDict objectForKey:@"bricks"] intValue];
            }
            if ([costDict objectForKey:@"gems"])
            {
                cost.gems = [[costDict objectForKey:@"gems"] intValue];
            }
            if ([costDict objectForKey:@"recruits"])
            {
                cost.recruits = [[costDict objectForKey:@"recruits"] intValue];
            }
            card.cost = cost;
            card.text = [dict valueForKey:@"text"];
            card.type = [[dict valueForKey:@"type"] intValue];
            
//                NSDictionary *evalDict = [dict valueForKey:@"eval"];
//                if (evalDict)
//                {
//                    for (NSString *key in [evalDict allKeys])
//                    {
//                        if ([key isEqualToString:@"op1"])
//                        {
//                            card.eval->op1 = [self createEffect:[evalDict objectForKey:key]];
//                        }
//                        else if ([key isEqualToString:@"op2"])
//                        {
//                            card.eval->op2 = [self createEffect:[evalDict objectForKey:key]];
//                        }
//                        else if ([key isEqualToString:@"lesserThanResult"])
//                        {
//                            card.eval->lesserThanResult = [self createEffect:[evalDict objectForKey:key]];
//                        }
//                        else if ([key isEqualToString:@"equalsResult"])
//                        {
//                            card.eval->equalsResult = [self createEffect:[evalDict objectForKey:key]];
//                        }
//                        else if ([key isEqualToString:@"greaterThanResult"])
//                        {
//                            card.eval->greaterThanResult = [self createEffect:[evalDict objectForKey:key]];
//                        }
//                    }
//                }
                
            NSArray *arrFx = [dict valueForKey:@"effects"];
            if (arrFx)
            {
                NSMutableArray *mArrFx = [[NSMutableArray alloc] init];
                    
                for (NSDictionary *x in arrFx)
                {
                    Effect e = [self createEffect:x];
                    
                    /*
                     structs in NSArray...
                         
                    // add:
                    [array addObject:[NSValue value:&p withObjCType:@encode(struct Point)]];
                         
                    // extract:
                    struct Point p;
                    [[array objectAtIndex:i] getValue:&p];
                    */
                    [mArrFx addObject:[NSValue value:e withObjCType:@encode(struct _Effect)]];
                }
                card.effects = mArrFx;
            }
            
            NSArray *arrSpecial = [dict valueForKey:@"specialPowers"];
            if (arrSpecial)
            {
                NSMutableArray *mArrSpecial = [[NSMutableArray alloc] init];
                    
                for (NSNumber *n in arrSpecial)
                {
                    [mArrSpecial addObject:n];
                }
                card.specialPowers = mArrSpecial;
            }
            
            [mArrCards addObject:card];
        }
    }
        
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                           ascending:YES
                                                            selector:@selector(caseInsensitiveCompare:)];
    arrCards=[mArrCards sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    [mArrCards release];
    
    return arrCards;
}

+(NSArray*)onlyThisCard:(NSString*)cardName
{
    NSMutableArray *mArrCards = [[NSMutableArray alloc] initWithCapacity:DEFAULT_CARDS_IN_DECK];
    
    for (OCard *card in [self allCards])
    {
        if ([card.name isEqualToString:cardName])
        {
            for (int i=0; i<DEFAULT_CARDS_IN_DECK; i++)
            {
                OCard *cardClone = [[OCard alloc] init];

                cardClone.name = card.name;
                cardClone.cost = card.cost;
                cardClone.text = card.text;
                cardClone.type = card.type;
                cardClone.effects = card.effects;
                cardClone.specialPowers = card.specialPowers;
                cardClone.eval = card.eval;
                
                [mArrCards addObject:cardClone];
            }
            break;
        }
    }
    
    return mArrCards;
}

+ (Effect) createEffect:(NSDictionary*)dict
{
    Effect e = create(Effect);
    
    e->field =  [[dict valueForKey:@"field"] intValue];
    e->value = [[dict valueForKey:@"value"] intValue];
    e->target = [[dict valueForKey:@"target"] intValue];
    
    return e;
}

+(NSString*) specialPowerName:(CardSpecialPower)sp
{
    switch (sp)
    {
        case CardPlayAnother:
        {
            return @"Play an additional card.";
        }
        case CardUndiscardable:
        {
            return @"This card can't be discarded.";
        }
        case CardDraw:
        {
            return @"Draw 1 card.";
        }
        case CardDiscard:
        {
            return @"Discard 1 card.";
        }
    }
}

-(int) totalCost
{
    return cost.bricks + cost.gems + cost.recruits;
}

-(int) totalDamage
{
    int totalDamage = 0;
    
    for (int i=0; i<effects.count; i++)
    {
        struct _Effect e;
        [[effects objectAtIndex:i] getValue:&e];
        
        if (e.field == Wall || e.field == Tower)
        {
            totalDamage += e.value;
        }
    }
    
    return totalDamage;
}

-(NSString*) canonicalText
{
    NSMutableString *stCurrent = [[NSMutableString alloc] init];
    NSMutableString *stOpponent = [[NSMutableString alloc] init];
    NSMutableString *stAll = [[NSMutableString alloc] init];
    
    if (effects)
    {
        for (int i=0; i<effects.count; i++)
        {
            struct _Effect e;
            [[effects objectAtIndex:i] getValue:&e];
            
            switch (e.target)
            {
                case Current:
                {
                    [stCurrent appendFormat:@"%@%@%d %@", stCurrent.length>0 ? @" ":@"", e.value>0?@"+":@"", e.value, [OStats statName:e.field]];
                    break;
                }
                case Opponent:
                {
                    [stOpponent appendFormat:@"%@%@%d %@", stOpponent.length>0 ? @" ":@"", e.value>0?@"+":@"", e.value, [OStats statName:e.field]];
                    break;
                }
            }
        }
    }
    
    [stAll appendFormat:@"%@", stCurrent];
    if (stOpponent.length > 0)
    {
        [stAll appendFormat:@"\nOpponent: %@", stOpponent];
    }
    [stCurrent release];
    [stOpponent release];
    
    if (specialPowers)
    {
        for (NSNumber *n in specialPowers)
        {
            [stAll appendFormat:@"%@%@", stAll.length>0 ? @"\n":@"", [OCard specialPowerName:[n intValue]]];
        }
    }
    return stAll;
}

-(BOOL) hasSpecialPower:(CardSpecialPower)sp
{
    if (specialPowers)
    {
        for (NSNumber *n in specialPowers)
        {
            if ([n intValue] == sp)
            {
                return YES;
            }
        }
    }
    return NO;
}

@end
