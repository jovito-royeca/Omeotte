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
            
            NSString *name = [dict valueForKey:@"name"];
            const char* cname = [name UTF8String];
            rule->name = (char*)malloc(sizeof(char)*name.length);
            memcpy(rule->name, cname, sizeof(cname));
            
            NSString *location = [dict valueForKey:@"location"];
            const char* clocation = [location UTF8String];
            rule->location = (char*)malloc(sizeof(char)*location.length);
            memcpy(rule->location, clocation, sizeof(clocation));
            
            OStats base = createStats();
            base->tower = [[dict valueForKey:@"tower"] intValue];
            base->wall = [[dict valueForKey:@"wall"] intValue];
            base->bricks = [[dict valueForKey:@"bricks"] intValue];
            base->gems = [[dict valueForKey:@"gems"] intValue];
            base->recruits = [[dict valueForKey:@"recruits"] intValue];
            base->quarries = [[dict valueForKey:@"quarries"] intValue];
            base->magics = [[dict valueForKey:@"magics"] intValue];
            base->dungeons = [[dict valueForKey:@"dungeons"] intValue];
            rule->base = base;
            
            rule->cardsInHand = [[dict valueForKey:@"cardsInHand"] intValue];
            rule->winningTower = [[dict valueForKey:@"winningTower"] intValue];
            rule->winningResource = [[dict valueForKey:@"winningResource"] intValue];
            rule->price = [[dict valueForKey:@"price"] intValue];
            
            ll_add(rules, rule);
        }
        
    }
    
    return rules;
}
