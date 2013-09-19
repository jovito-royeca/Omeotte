//
//  OCard.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#include "Omeotte.h"

OCard createCard()
{
    OCard card = (OCard) malloc(sizeof(OCard));
    
    if (card)
    {
//        char *name;
//        card->cost = createStats();
//        char *text;
        card->playAgain = 0;
        card->type = Mixed;
//        OEffect *effects;
//        OEval eval;
        return card;
    }
    
    return 0;
}

OCard* allCards()
{
    static OCard* cards;
    
    if (!cards)
    {
        NSMutableArray *macards = [[NSMutableArray alloc] init];
        NSArray *pLists = [NSArray arrayWithObjects:@"quarry", @"magic", @"dungeon", nil];
        
        for (NSString *card in pLists)
        {
            NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                      NSUserDomainMask, YES) objectAtIndex:0];
            NSString *path = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"data/%@.plist", card]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path])
            {
                path = [[NSBundle mainBundle] pathForResource:card ofType:@"plist"];
            }
            
            NSMutableArray *ma = [NSMutableArray arrayWithContentsOfFile:path];
            for (NSDictionary *dict in ma)
            {
                OCard card = createCard();
            
                card->name = [[dict valueForKey:@"name"] UTF8String];

                NSDictionary *costDict = [dict valueForKey:@"cost"];
                OStats cost = createStats();
                if ([costDict objectForKey:@"bricks"])
                {
                    cost->bricks = [[costDict objectForKey:@"bricks"] intValue];
                }
                if ([costDict objectForKey:@"gems"])
                {
                    cost->gems = [[costDict objectForKey:@"gems"] intValue];
                }
                if ([costDict objectForKey:@"recruits"])
                {
                    cost->recruits = [[costDict objectForKey:@"recruits"] intValue];
                }
                card->cost = cost;
                card->text = [[dict valueForKey:@"text"] UTF8String];
                card->playAgain = [[dict valueForKey:@"playAgain"] boolValue];
                card->type = [[dict valueForKey:@"type"] intValue];
            
                NSArray *_effects = [dict valueForKey:@"effects"];
                if (_effects)
                {
                    NSMutableArray *effectsArr = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *x in _effects)
                    {
                        OEffect e = createEffect();
                        
                        e->field =  [[dict valueForKey:@"field"] intValue];
                        e->value = [[dict valueForKey:@"value"] intValue];
                        e->target = [[dict valueForKey:@"target"] intValue];

                        /*
                         structs in NSArray...
                         
                         // add:
                         [array addObject:[NSValue value:&p withObjCType:@encode(struct Point)]];
                         
                         // extract:
                         struct Point p;
                         [[array objectAtIndex:i] getValue:&p];
                         */
                        [effectsArr addObject:[NSValue value:e withObjCType:@encode(struct _OEffect)]];
                    }
                    
                    NSRange range = NSMakeRange(0, effectsArr.count);
                    id *cArray = malloc(sizeof(id *) * range.length);
                    [effectsArr getObjects:cArray range:range];
                    card->effects = cArray;
                }
            
                NSDictionary *_eval = [dict valueForKey:@"eval"];
                if (_eval)
                {
                    
//                    card.eval = evalDict;
                }
                
                [macards addObject:card];
            }
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        NSArray *sortedCards = [macards sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        NSRange range2 = NSMakeRange(0, sortedCards.count);
        id *cCards = malloc(sizeof(id *) * range2.length);
        [sortedCards getObjects:cCards range:range2];
    }
    
    return cards;
}

int totalCost(OCard card)
{
    return card->cost->bricks + card->cost->gems + card->cost->recruits;
}
