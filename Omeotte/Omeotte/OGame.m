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
    OPlayer *_currentPlayer;
    NSString *_deck;
}

@synthesize hand;

-(id) init
{
    self = [super init];
    
    if (self)
    {
        NSArray *rules = [ORule allRules];
        NSUInteger random = arc4random() % [rules count];
        self.rule = [rules objectAtIndex:random];
        
        [self setup];
        [self initPlayers];
//        [self gameLoop];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    
    for (SPImage *img in hand)
    {
        [img removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TOUCH];
    }
    [hand release];
    
    [SPMedia releaseAllAtlas];
    //    [SPMedia releaseSound];
}

- (void)setup
{
    _deck = @"arcomage deck.xml";
    
    [SPMedia initAtlas:_deck];
    
    hand = [[NSMutableArray alloc] initWithCapacity:6];
    
    // Lay the Cards
    int stageWidth = Sparrow.stage.width;
    int stageHeight = Sparrow.stage.height;
    int cardWidth = stageWidth/6;
    int cardHeight = (cardWidth*128)/95;
    int currentX = 0;
    for (int i=0; i<6; i++)
    {
        SPImage *img = [[SPImage alloc] initWithWidth:cardWidth height:cardHeight];
        SPTexture *texture = [SPMedia texture:@"blank" fromAtlas:_deck];
        
        img.texture = texture;
        img.x = currentX;
        img.y = stageHeight-img.height;
        currentX += img.width;
        [self addChild:img];
        [img addEventListener:@selector(onCardTouched:) atObject:self
                      forType:SP_EVENT_TYPE_TOUCH];
        
        [hand addObject:img];
    }
}

- (void)onCardTouched:(SPTouchEvent*)event
{
    int stageWidth = Sparrow.stage.width;
    int stageHeight = Sparrow.stage.height;
    int cardWidth = stageWidth/6;
    int cardHeight = (cardWidth*128)/95;
    
    SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] anyObject];
    SPImage *img = (SPImage*)event.target;
    int index = [hand indexOfObject:img];
    OCard *card = [[_currentPlayer cardsInHand] objectAtIndex:index];
    
    if (touch)
    {
        SPPoint *touchPosition = [touch locationInSpace:self];
        BOOL play = touchPosition.y < (stageHeight-cardHeight);
        
        NSLog(@"Touch position ended (%f, %f)", touchPosition.x, touchPosition.y);
        
        if (play)
        {
            NSLog(@"Playing... %@", [card name]);
        }
        else
        {
            NSLog(@"Discarding... %@", [card name]);
        }
        
        OCard *newCard = [_currentPlayer draw];
        SPTexture *texture = [SPMedia texture:[newCard name] fromAtlas:_deck];
        img.texture = texture;
    }
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

-(void) showHand:(OPlayer*)player
{
    for (int i=0; i<player.cardsInHand.count; i++)
    {
        SPImage *img = [hand objectAtIndex:i];
        OCard *card = [player.cardsInHand objectAtIndex:i];
        SPTexture *texture = [SPMedia texture:[card name] fromAtlas:_deck];
        img.texture = texture;
    }
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
