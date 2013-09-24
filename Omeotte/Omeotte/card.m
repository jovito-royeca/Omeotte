//
//  OCard.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#include <string.h>

#include "Omeotte.h"

OCard createCard()
{
    OCard card = (OCard) malloc(sizeof(OCard));
    
    if (card)
    {
//        char *name;
        card->cost = createStats();
//        char *text;
        card->playAgain = 0;
        card->type = Mixed;
//        card->effects = createEffect();
//        OEval eval;
        return card;
    }
    
    return 0;
}

LinkedList allCards()
{
    static LinkedList cards;
    
    if (!cards)
    {
        cards = ll_create();
        
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
            
                NSString *name = [dict valueForKey:@"name"];
                const char* cname = [name UTF8String];
                card->name = (char*)malloc(sizeof(char)*name.length);
                memcpy(card->name, cname, sizeof(cname));

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
                
                NSString *text = [dict valueForKey:@"text"];
                const char *ctext = [text UTF8String];
                card->text = (char*) malloc(sizeof(char)*text.length);
                memcpy(card->text, ctext, sizeof(ctext));
                
                card->playAgain = [[dict valueForKey:@"playAgain"] boolValue];
                card->type = [[dict valueForKey:@"type"] intValue];
            
                NSArray *_effects = [dict valueForKey:@"effects"];
                if (_effects)
                {
                    card->effects = ll_create();
                    
                    for (NSDictionary *x in _effects)
                    {
                        OEffect e = createEffect();
                        
                        e->field =  [[dict valueForKey:@"field"] intValue];
                        e->value = [[dict valueForKey:@"value"] intValue];
                        e->target = [[dict valueForKey:@"target"] intValue];
                        ll_add(card->effects, e);
                    }
                }
            
                NSDictionary *_eval = [dict valueForKey:@"eval"];
                if (_eval)
                {
                    
//                    card.eval = evalDict;
                }
                
                /*
                 structs in NSArray...
                 
                 // add:
                 [array addObject:[NSValue value:&p withObjCType:@encode(struct Point)]];
                 
                 // extract:
                 struct Point p;
                 [[array objectAtIndex:i] getValue:&p];
                 */
                [macards addObject:[NSValue value:card withObjCType:@encode(OCard)]];
            }
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        NSArray *sortedCards = [macards sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        for (int i=0; i<sortedCards.count; i++)
        {
            ll_add(cards, [sortedCards objectAtIndex:i]);
        }
    }
    
    return cards;
}

int totalCost(OCard card)
{
    return card->cost->bricks + card->cost->gems + card->cost->recruits;
}
