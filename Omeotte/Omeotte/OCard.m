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
@synthesize effects;
@synthesize eval;

NSArray *_cards;

+(NSArray*)allCards
{
    if (!_cards)
    {
        NSMutableArray *_macards = [[NSMutableArray alloc] init];
        NSArray *cards = [NSArray arrayWithObjects:@"quarry", /*@"magic", @"dungeon",*/ nil];
        
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
                Stats *cost = [[[Stats alloc] init] autorelease];
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
            
                NSArray *_effects = [dict valueForKey:@"effects"];
                if (_effects)
                {
                    NSMutableArray *effectsArr = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *x in _effects)
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
                        [effectsArr addObject:[NSValue value:e withObjCType:@encode(struct _Effect)]];
                    }
                    card.effects = effectsArr;
                }
            
                NSDictionary *_eval = [dict valueForKey:@"eval"];
                if (_eval)
                {
                    
//                    card.eval = evalDict;
                }
                
                [_macards addObject:card];
            }
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        _cards=[_macards sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    return _cards;
}

+ (Effect) createEffect:(NSDictionary*)dict
{
    Effect e = create(Effect);
    
    e->field =  [[dict valueForKey:@"field"] intValue];
    e->value = [[dict valueForKey:@"value"] intValue];
    e->target = [[dict valueForKey:@"target"] intValue];
    
    return e;
}

@end
