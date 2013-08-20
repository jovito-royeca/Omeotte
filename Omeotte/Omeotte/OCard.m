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
@synthesize image;
@synthesize cost;
@synthesize text;
@synthesize type;
@synthesize playAgain;
@synthesize currentPlayer;
@synthesize opponent;

NSMutableArray *_cards;

+(NSArray*)allCards
{
    if (!_cards)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cards" ofType:@"plist"];
        NSMutableArray *ma = [NSMutableArray arrayWithContentsOfFile:filePath];
        _cards = [[NSMutableArray alloc] initWithCapacity:[ma count]];
        
        for (NSDictionary *dict in ma)
        {
            OCard *card = [[OCard alloc] init];
            Stats cp = create_stats;
            Stats op = create_stats;
            
            card.name = [dict valueForKey:@"name"];
            card.image = [dict valueForKey:@"image"];
            card.cost = [[dict valueForKey:@"cost"] integerValue];
            card.text = [dict valueForKey:@"text"];
            card.type = [[dict valueForKey:@"type"] integerValue];
            card.playAgain = [[dict valueForKey:@"playAgain"] boolValue];
            
            cp->tower = [[dict valueForKey:@"currentTower"] integerValue];
            cp->wall = [[dict valueForKey:@"currentWall"] integerValue];
            cp->bricks = [[dict valueForKey:@"currentBricks"] integerValue];
            cp->gems = [[dict valueForKey:@"currentGems"] integerValue];
            cp->recruits = [[dict valueForKey:@"currentRecruits"] integerValue];
            cp->quarries = [[dict valueForKey:@"currentQuarries"] integerValue];
            cp->magics = [[dict valueForKey:@"currentMagics"] integerValue];
            cp->dungeons = [[dict valueForKey:@"currentDungeons"] integerValue];
            card.currentPlayer = cp;

            op->tower = [[dict valueForKey:@"opponentTower"] integerValue];
            op->wall = [[dict valueForKey:@"opponentWall"] integerValue];
            op->bricks = [[dict valueForKey:@"opponentBricks"] integerValue];
            op->gems = [[dict valueForKey:@"opponentGems"] integerValue];
            op->recruits = [[dict valueForKey:@"opponentRecruits"] integerValue];
            op->quarries = [[dict valueForKey:@"opponentQuarries"] integerValue];
            op->magics = [[dict valueForKey:@"opponentMagics"] integerValue];
            op->dungeons = [[dict valueForKey:@"opponentDungeons"] integerValue];
            card.opponent = op;
            
            [_cards addObject:card];
        }
    }
    
    return _cards;
}

@end
