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
    SPTexture *_blankTexture;
    GamePhase _gamePhase;
}

@synthesize players;
@synthesize rule;
@synthesize hand;

-(id) init
{
    self = [super init];
    
    if (self)
    {
        // Get a random Rule; Modify this later to pick a Rule
        NSArray *rules = [ORule allRules];
        NSUInteger random = arc4random() % [rules count];
        rule = [rules objectAtIndex:random];
        
        _gamePhase = Upkeep;
        
        [self setup];
        [self initPlayers];
//        [self gameLoop];
        [self addEventListener:@selector(gameLoop:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
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
    
    [OMedia releaseAllAtlas];
    //    [SPMedia releaseSound];
}

- (void)setup
{
    _deck = @"arcomage deck.xml";
    
    [OMedia initAtlas:_deck];
    
    hand = [[NSMutableArray alloc] initWithCapacity:6];
    _blankTexture = [OMedia texture:@"blank" fromAtlas:_deck];
    
    // To do: lay the background
    // ...
    
    // Cards
    CGRect rect = [self cardRect];
    int currentX = 0;
    for (int i=0; i<6; i++)
    {
        SPImage *img = [[SPImage alloc] initWithWidth:rect.size.width height:rect.size.height];
        
        img.texture = _blankTexture;
        img.x = currentX;
        img.y = Sparrow.stage.height-img.height;
        currentX += img.width;
        [self addChild:img];
        [img addEventListener:@selector(onCardTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        [hand addObject:img];
    }
    
    // To do: lay the Player stats
    // ...
    
    // To do: lay the Castles and Walls
    // ...
}

- (void)onCardTouched:(SPTouchEvent*)event
{
    if (_currentPlayer.ai)
    {
        return;
    }

    SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] anyObject];
    SPImage *img = (SPImage*)event.target;
    int index = [hand indexOfObject:img];
    OCard *card = nil;
    
    if (index <= [_currentPlayer.hand count] -1)
    {
        card = [_currentPlayer.hand objectAtIndex:index];
    }
    
    if (card && touch)
    {
        CGRect rect = [self cardRect];
        
        SPPoint *touchPosition = [touch locationInSpace:self];
        BOOL play = touchPosition.y < (Sparrow.stage.height-rect.size.height);
        
        if (play)
        {
            [self playCard:card];
        }
        else
        {
            [self discardCard:card];
        }
    }
}

-(void) initPlayers
{
    OPlayer *player1 = [[OPlayer alloc] init];
    OPlayer *player2 = [[OPlayer alloc] init];
    
    [player1 draw:[rule cardsInHand]];
    [player1.base setStats:rule.base];
    
    [player2 draw:[rule cardsInHand]];
    [player2.base setStats:rule.base];
    
    _currentPlayer = player1;
    player2.ai = YES;
    players = [[NSArray alloc] initWithObjects:player1, player2, nil];
}

-(void) showHand:(OPlayer*)player
{
    if (_currentPlayer.ai)
    {
        for (int i=0; i<hand.count; i++)
        {
            SPImage *img = [hand objectAtIndex:i];
            
            img.texture = _blankTexture;
            img.alpha = 1.0;
        }
    }
    
    else
    {
        for (int i=0; i<hand.count; i++)
        {
            SPImage *img = [hand objectAtIndex:i];
            OCard *card = nil;
        
            if (i <= player.hand.count-1)
            {
                card = [player.hand objectAtIndex:i];
            }
        
            if (card)
            {
                [self displayCard:card inImageHolder:img];
            }
            else
            {
                img.texture = _blankTexture;
                img.alpha = 1.0;
            }
        }
    }
}

-(void) addCardsToHand:(NSArray*)cards
{
    for (OCard* card in cards)
    {
        for (SPImage *img in hand)
        {
            if (img.texture == _blankTexture)
            {
                [self displayCard:card inImageHolder:img];
            }
        }
    }
}

-(void) playCard:(OCard*) card
{
    if ([_currentPlayer canPlayCard:card])
    {
        NSLog(@"Playing... %@", [card name]);
        [_currentPlayer play:card onTarget:[self opponentPlayer]];
        [_currentPlayer discard:card];
        [self showHand:_currentPlayer];
        
        if (card.playAgain)
            _gamePhase = Upkeep;
        else
            _gamePhase = Discard;
    }
}

-(void) discardCard:(OCard*) card
{
    NSLog(@"Discarding... %@", [card name]);
    [_currentPlayer discard:card];
    _gamePhase = Discard;
}

-(void) displayCard:(OCard*) card inImageHolder:(SPImage*)img
{
    SPTexture *texture = [OMedia texture:[card name] fromAtlas:_deck];

    img.texture = texture;
    img.alpha = [_currentPlayer canPlayCard:card] ? 1.0 : 0.4;
}

-(OPlayer*) opponentPlayer
{
    int i = [players indexOfObject:_currentPlayer];
    int count = [players count];
    return (i == count-1) ? [players objectAtIndex:i-1] : [players objectAtIndex:i+1];
}

-(CGRect) cardRect
{
    int stageWidth = Sparrow.stage.width;
//    int stageHeight = Sparrow.stage.height;
    int cardWidth = stageWidth/6;
    int cardHeight = (cardWidth*128)/95;
    
    return CGRectMake(0, 0, cardWidth, cardHeight);
}

-(void) gameLoop:(SPEnterFrameEvent*)event
{
    OPlayer *opponent = [self opponentPlayer];
    
    switch (_gamePhase)
    {
        case Upkeep:
        {
            [self showHand:_currentPlayer];
            [_currentPlayer upkeep];
            _gamePhase = Draw;
            break;
        }
        case Draw:
        {
            int cardsToDraw = rule.cardsInHand - [_currentPlayer.hand count];
            if (cardsToDraw > 0)
            {
                [self addCardsToHand:[_currentPlayer draw:cardsToDraw]];
            }
            _gamePhase = Main;
            break;
        }
        case Main:
        {
            if (_currentPlayer.ai)
            {
                OCard *card = [_currentPlayer chooseCardToPlay];
                
                [self playCard:card];
            }
            break;
        }
        case Victory:
        {
            if (_currentPlayer.base.tower == 0 || opponent.base.tower == 0)
            {
                NSLog(@"Game Over");
            }
            break;
        }
        case Discard:
        {
            if (_currentPlayer.ai)
            {
                if ([_currentPlayer shouldDiscard:rule.cardsInHand])
                {
                    OCard *card = [_currentPlayer chooseCardToDiscard];
                    
                    [self discardCard:card];
                }
            }
            _gamePhase = Upkeep;
            _currentPlayer = opponent;
        }
    }
}

@end
