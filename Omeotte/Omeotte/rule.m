//
//  rule.c
//  Omeotte
//
//  Created by Jovito Royeca on 9/20/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#include <stdlib.h>

#include "Omeotte.h"

LinkedList allRules()
{
    static LinkedList rules;
    
    if (!rules)
    {
        rules = ll_create();
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"rules" ofType:@"plist"];
        NSMutableArray *ma = [NSMutableArray arrayWithContentsOfFile:filePath];
        
        for (NSDictionary *dict in ma)
        {
            ORule rule = (ORule) malloc(sizeof(ORule));
            
            const char* name = [[dict valueForKey:@"name"] UTF8String];
            rule->name = (char*)malloc(sizeof(char)+1);
            memcpy(card->name, name, sizeof(name));
            
            rule.name = [dict valueForKey:@"name"];
            rule.location = [dict valueForKey:@"location"];
            
            OStats base = createStats();
            base->tower = [[dict valueForKey:@"tower"] intValue];
            base->wall = [[dict valueForKey:@"wall"] intValue];
            base->bricks = [[dict valueForKey:@"bricks"] intValue];
            base->gems = [[dict valueForKey:@"gems"] intValue];
            base->recruits = [[dict valueForKey:@"recruits"] intValue];
            base->quarries = [[dict valueForKey:@"quarries"] intValue];
            base->magics = [[dict valueForKey:@"magics"] intValue];
            base->dungeons = [[dict valueForKey:@"dungeons"] intValue];
            rule.base = base;
            
            rule.cardsInHand = [[dict valueForKey:@"cardsInHand"] intValue];
            rule.winningTower = [[dict valueForKey:@"winningTower"] intValue];
            rule.winningResource = [[dict valueForKey:@"winningResource"] intValue];
            rule.price = [[dict valueForKey:@"price"] intValue];
            
            [_rules addObject:rule];
        }
        
    }
    
    return rules;
}
