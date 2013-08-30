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
    int stageWidth = Sparrow.stage.width;
    int stageHeight = Sparrow.stage.height;
    int cardWidth = stageWidth/6;
    int cardHeight = (cardWidth*128)/95;
    int currentX = 0;
    for (int i=0; i<6; i++)
    {
        SPImage *img = [[SPImage alloc] initWithWidth:cardWidth height:cardHeight];
        
        img.texture = _blankTexture;
        img.x = currentX;
        img.y = stageHeight-img.height;
        currentX += img.width;
        [self addChild:img];
        [img addEventListener:@selector(onCardTouched:) atObject:self
                      forType:SP_EVENT_TYPE_TOUCH];
        
        [hand addObject:img];
    }
    
    // To do: lay the Player stats
    // ...
    
    // To do: lay the Castles and Walls
    // ...
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
    OCard *card = [[_currentPlayer hand] objectAtIndex:index];
    
    if (card && touch)
    {
        SPPoint *touchPosition = [touch locationInSpace:self];
        BOOL play = touchPosition.y < (stageHeight-cardHeight);
        
        if (play)
        {
            if ([_currentPlayer canPlayCard:card])
            {
                NSLog(@"Playing... %@", [card name]);
                [_currentPlayer play:card onTarget:[self opponentPlayer]];
                [_currentPlayer discard:card];
                
                img.texture = _blankTexture;
                [hand removeObject:card];
            }
            
            if (!card.playAgain)
                _gamePhase = Victory;
        }
        else
        {
            NSLog(@"Discarding... %@", [card name]);
            [_currentPlayer discard:card];
            _gamePhase = Upkeep;
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
    for (int i=0; i<player.hand.count; i++)
    {
        SPImage *img = [hand objectAtIndex:i];
        OCard *card = [player.hand objectAtIndex:i];
        
        if (card)
        {
            SPTexture *texture = [OMedia texture:[card name] fromAtlas:_deck];
        
            img.texture = texture;
            img.alpha = [player canPlayCard:card] ? 1.0 : 0.5;
        }
        else
        {
            img.texture = _blankTexture;
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
                SPTexture *texture = [OMedia texture:[card name] fromAtlas:_deck];
                
                img.texture = texture;
                img.alpha = [_currentPlayer canPlayCard:card] ? 1.0 : 0.5;
            }
        }
    }
}

-(OPlayer*) opponentPlayer
{
    int i = [players indexOfObject:_currentPlayer];
    int count = [players count];
    return (i == count-1) ? [players objectAtIndex:i-1] : [players objectAtIndex:i+1];
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
                
                if (card && [_currentPlayer canPlayCard:card])
                {
                    [_currentPlayer play:card onTarget:opponent];
                }
                
                if (!card.playAgain)
                    _gamePhase = Victory;
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
            if ([_currentPlayer shouldDiscard:rule.cardsInHand])
            {
//                [_currentPlayer discard];
            }
            _gamePhase = Upkeep;
            _currentPlayer = opponent;
        }
    }
}

@end
