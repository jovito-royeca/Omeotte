//
//  ORules.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/20/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "ORule.h"

@implementation ORule

@synthesize name;
@synthesize location;
@synthesize base;
@synthesize cardsInHand;
@synthesize winningTower;
@synthesize winningResource;
@synthesize price;

NSMutableArray *_rules;

+(NSArray*)allRules
{
    if (!_rules)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"rules" ofType:@"plist"];
        NSMutableArray *ma = [NSMutableArray arrayWithContentsOfFile:filePath];
        _rules = [[NSMutableArray alloc] initWithCapacity:[ma count]];
        
        for (NSDictionary *dict in ma)
        {
            ORule *rule = [[ORule alloc] init];
            Stats base = create_stats;
            
            rule.name = [dict valueForKey:@"name"];
            rule.location = [dict valueForKey:@"location"];

            base->tower = [[dict valueForKey:@"startingTower"] intValue];
            base->wall = [[dict valueForKey:@"startingWall"] intValue];
            base->bricks = [[dict valueForKey:@"startingBricks"] intValue];
            base->gems = [[dict valueForKey:@"startingGems"] intValue];
            base->recruits = [[dict valueForKey:@"startingRecruits"] intValue];
            base->quarries = [[dict valueForKey:@"startingQuarries"] intValue];
            base->magics = [[dict valueForKey:@"startingMagics"] intValue];
            base->dungeons = [[dict valueForKey:@"startingDungeons"] intValue];
            rule.base = base;
            
            rule.cardsInHand = [[dict valueForKey:@"cardsInHand"] intValue];
            rule.winningTower = [[dict valueForKey:@"winningTower"] intValue];
            rule.winningResource = [[dict valueForKey:@"winningResource"] intValue];
            rule.price = [[dict valueForKey:@"price"] intValue];

            [_rules addObject:rule];
        }
        
    }
    
    return _rules;
}

@end
