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
@synthesize playAgain;
@synthesize type;
@synthesize eval;
@synthesize effects;

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
//            free(&e);
//        }
//    }
//    [effects removeAllObjects];
    
    [super dealloc];
}

NSArray *_cards;

+(NSArray*)allCards
{
    if (!_cards)
    {
        NSMutableArray *macards = [[NSMutableArray alloc] init];
        NSArray *cards = [NSArray arrayWithObjects:@"quarry", @"magic", @"dungeon", nil];
        
        for (NSString *card in cards)
        {
            NSString *plistPath;
            NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                      NSUserDomainMask, YES) objectAtIndex:0];
            plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"data/%@.plist", card]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
            {
                plistPath = [[NSBundle mainBundle] pathForResource:card ofType:@"plist"];
            }
            
            NSMutableArray *ma = [NSMutableArray arrayWithContentsOfFile:plistPath];
            for (NSDictionary *dict in ma)
            {
                OCard *card = [[OCard alloc] init];
            
                card.name = [dict valueForKey:@"name"];

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
                card.playAgain = [[dict valueForKey:@"playAgain"] boolValue];
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
                
                NSArray *fx = [dict valueForKey:@"effects"];
                if (fx)
                {
                    NSMutableArray *fxArr = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *x in fx)
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
                        [fxArr addObject:[NSValue value:e withObjCType:@encode(struct _Effect)]];
                    }
                    card.effects = fxArr;
                }
            
                [macards addObject:card];
            }
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        _cards=[macards sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        [macards release];
    }
    
    [_cards retain];
    return _cards;
}

+(NSArray*)onlyThisCard:(NSString*)cardName
{
    NSMutableArray *cards = [[NSMutableArray alloc] initWithCapacity:DEFAULT_CARDS_IN_DECK];
    
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
                cardClone.playAgain = card.playAgain;
                cardClone.type = card.type;
                cardClone.effects = card.effects;
                cardClone.eval = card.eval;
                
                [cards addObject:cardClone];
            }
            break;
        }
    }
    
    return cards;
}

+ (Effect) createEffect:(NSDictionary*)dict
{
    Effect e = create(Effect);
    
    e->field =  [[dict valueForKey:@"field"] intValue];
    e->value = [[dict valueForKey:@"value"] intValue];
    e->target = [[dict valueForKey:@"target"] intValue];
    
    return e;
}

-(int) totalCost
{
    return cost.bricks + cost.gems + cost.recruits;
}

@end
