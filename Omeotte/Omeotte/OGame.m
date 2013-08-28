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
    [player1.base setStats:_rule.base];
    
    [player2 drawInitialHand:[_rule cardsInHand]];
    [player2.base setStats:_rule.base];
    
    _players = [[NSArray alloc] initWithObjects:player1, player2, nil];
}

-(void) gameLoop
{
    BOOL gameOver = NO;
    
    do
    {
        int i = 0, count = [_players count];
        
        for (i=0; i<count; i++)
        {
            OPlayer *current = [_players objectAtIndex:i];
            OPlayer *target = (i == count-1) ? [_players objectAtIndex:i-1] : [_players objectAtIndex:i+1];
            OCard *card = [current chooseCardToPlay];
            
            [current draw];
            [current startTurn];
            if ([current canPlayCard:card])
            {
                [current play:card onTarget:target];
            }
            
            if (current.base.tower == 0 || target.base.tower == 0)
            {
                gameOver = YES;
            }
        }
    }
    while (!gameOver);
}

@end
