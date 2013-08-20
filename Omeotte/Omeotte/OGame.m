//
//  Game.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OGame.h"

@implementation OGame
{
    NSArray *_players;
    OPlayer *_currentPlayer;
    ORule* _rule;
}

-(id) initWithRule:(ORule*)rule
{
    self = [super init];
    
    if (self)
    {
        _rule = rule;
    }
    return self;
}

-(void) initPlayers
{
    OPlayer *player1 = [[OPlayer alloc] init];
    OPlayer *player2 = [[OPlayer alloc] init];
    
    [player1 drawInitialHand:[_rule cardsInHand]];
    [player2 drawInitialHand:[_rule cardsInHand]];
    
    _players = [[NSArray alloc] initWithObjects:player1, player2, nil];
    _currentPlayer = player1;
}

-(void) gameLoop
{
    BOOL over = NO;
    
    do
    {
        for (OPlayer *p in _players)
        {
//            [p play:<#(OCard *)#> onTarget:<#(OPlayer *)#>]
        }
    }
    while (!over);
}

@end
