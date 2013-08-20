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

            base->tower = [[dict valueForKey:@"startingTower"] integerValue];
            base->wall = [[dict valueForKey:@"startingWall"] integerValue];
            base->bricks = [[dict valueForKey:@"startingBricks"] integerValue];
            base->gems = [[dict valueForKey:@"startingGems"] integerValue];
            base->recruits = [[dict valueForKey:@"startingRecruits"] integerValue];
            base->quarries = [[dict valueForKey:@"startingQuarries"] integerValue];
            base->magics = [[dict valueForKey:@"startingMagics"] integerValue];
            base->dungeons = [[dict valueForKey:@"startingDungeons"] integerValue];
            rule.base = base;
            
            rule.cardsInHand = [[dict valueForKey:@"cardsInHand"] integerValue];
            rule.winningTower = [[dict valueForKey:@"winningTower"] integerValue];
            rule.winningResource = [[dict valueForKey:@"winningResource"] integerValue];
            rule.price = [[dict valueForKey:@"price"] integerValue];

            [_rules addObject:rule];
        }
        
    }
    
    return _rules;
}

@end
