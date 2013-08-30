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
    GamePhase _gamePhase;
}

@synthesize txtPlayer1Name;
@synthesize txtPlayer1Tower;
@synthesize txtPlayer1Wall;
@synthesize txtPlayer1Quarries;
@synthesize txtPlayer1Magics;
@synthesize txtPlayer1Dungeons;
@synthesize txtPlayer2Name;
@synthesize txtPlayer2Tower;
@synthesize txtPlayer2Wall;
@synthesize txtPlayer2Quarries;
@synthesize txtPlayer2Magics;
@synthesize txtPlayer2Dungeons;

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
    
    int stageWidth = Sparrow.stage.width;
    int stageHeight = Sparrow.stage.height;
    int currentX = 0, currentY = 0;
    
    // To do: lay the background
    // ...
    
    // To do: lay the Player stats
    txtPlayer1Name = [[SPTextField alloc] initWithWidth:stageWidth/2 height:15];
    txtPlayer1Name.color = 0xff0000;
    txtPlayer1Name.hAlign = SPHAlignLeft;
    txtPlayer1Name.x = currentX;
    txtPlayer1Name.y = currentY;
    [self addChild:txtPlayer1Name];
    
    currentX = 0;
    currentY = txtPlayer1Name.height+30;
    SPTextField *lblPlayer1Quarries = [[SPTextField alloc] initWithWidth:stageWidth/8 height:15 text:@"Quarries:"];
    lblPlayer1Quarries.color = 0xff0000;
    lblPlayer1Quarries.hAlign = SPHAlignLeft;
    lblPlayer1Quarries.x = currentX;
    lblPlayer1Quarries.y = currentY;
    [self addChild:lblPlayer1Quarries];
    currentX = lblPlayer1Quarries.width;
    txtPlayer1Quarries = [[SPTextField alloc] initWithWidth:(stageWidth/8)*3 height:15];
    txtPlayer1Quarries.color = 0xff0000;
//    txtPlayer1Quarries.hAlign = SPHAlignRight;
    txtPlayer1Quarries.x = currentX;
    txtPlayer1Quarries.y = currentY;
    [self addChild:txtPlayer1Quarries];

    currentX = 0;
    currentY += lblPlayer1Quarries.height;
    SPTextField *lblPlayer1Magics = [[SPTextField alloc] initWithWidth:stageWidth/8 height:15 text:@"Magics:"];
    lblPlayer1Magics.color = 0xff0000;
    lblPlayer1Magics.hAlign = SPHAlignLeft;
    lblPlayer1Magics.x = currentX;
    lblPlayer1Magics.y = currentY;
    [self addChild:lblPlayer1Magics];
    currentX = lblPlayer1Magics.width;
    txtPlayer1Magics = [[SPTextField alloc] initWithWidth:(stageWidth/8)*3 height:15];
    txtPlayer1Magics.color = 0xff0000;
//    txtPlayer1Magics.hAlign = SPHAlignRight;
    txtPlayer1Magics.x = currentX;
    txtPlayer1Magics.y = currentY;
    [self addChild:txtPlayer1Magics];

    currentX = 0;
    currentY += lblPlayer1Magics.height;
    SPTextField *lblPlayer1Dungeons = [[SPTextField alloc] initWithWidth:stageWidth/8 height:15 text:@"Dungeons:"];
    lblPlayer1Dungeons.color = 0xff0000;
    lblPlayer1Dungeons.hAlign = SPHAlignLeft;
    lblPlayer1Dungeons.x = currentX;
    lblPlayer1Dungeons.y = currentY;
    [self addChild:lblPlayer1Dungeons];
    currentX = lblPlayer1Dungeons.width;
    txtPlayer1Dungeons = [[SPTextField alloc] initWithWidth:(stageWidth/8)*3 height:15];
    txtPlayer1Dungeons.color = 0xff0000;
//    txtPlayer1Dungeons.hAlign = SPHAlignRight;
    txtPlayer1Dungeons.x = currentX;
    txtPlayer1Dungeons.y = currentY;
    [self addChild:txtPlayer1Dungeons];

    currentX = 0;
    currentY += lblPlayer1Dungeons.height+30;
    SPTextField *lblPlayer1Tower = [[SPTextField alloc] initWithWidth:stageWidth/8 height:15 text:@"Tower:"];
    lblPlayer1Tower.color = 0xff0000;
    lblPlayer1Tower.hAlign = SPHAlignLeft;
    lblPlayer1Tower.x = currentX;
    lblPlayer1Tower.y = currentY;
    [self addChild:lblPlayer1Tower];
    currentX = lblPlayer1Tower.width;
    txtPlayer1Tower = [[SPTextField alloc] initWithWidth:(stageWidth/8)*3 height:15];
    txtPlayer1Tower.color = 0xff0000;
//    txtPlayer1Tower.hAlign = SPHAlignRight;
    txtPlayer1Tower.x = currentX;
    txtPlayer1Tower.y = currentY;
    [self addChild:txtPlayer1Tower];
    
    currentX = 0;
    currentY += lblPlayer1Tower.height;
    SPTextField *lblPlayer1Wall = [[SPTextField alloc] initWithWidth:stageWidth/8 height:15 text:@"Wall:"];
    lblPlayer1Wall.color = 0xff0000;
    lblPlayer1Wall.hAlign = SPHAlignLeft;
    lblPlayer1Wall.x = currentX;
    lblPlayer1Wall.y = currentY;
    [self addChild:lblPlayer1Wall];
    currentX = lblPlayer1Wall.width;
    txtPlayer1Wall = [[SPTextField alloc] initWithWidth:(stageWidth/8)*3 height:15];
    txtPlayer1Wall.color = 0xff0000;
//    txtPlayer1Wall.hAlign = SPHAlignRight;
    txtPlayer1Wall.x = currentX;
    txtPlayer1Wall.y = currentY;
    [self addChild:txtPlayer1Wall];
    
    // AI
    currentX = txtPlayer1Name.width;
    currentY = 0;
    txtPlayer2Name = [[SPTextField alloc] initWithWidth:stageWidth/2 height:15];
    txtPlayer2Name.color = 0x0000ff;
    txtPlayer2Name.hAlign = SPHAlignLeft;
    txtPlayer2Name.x = currentX;
    txtPlayer2Name.y = currentY;
    [self addChild:txtPlayer2Name];
    
    currentX = txtPlayer1Name.width;
    currentY = txtPlayer2Name.height+30;
    SPTextField *lblPlayer2Quarries = [[SPTextField alloc] initWithWidth:stageWidth/8 height:15 text:@"Quarries:"];
    lblPlayer2Quarries.color = 0x0000ff;
    lblPlayer2Quarries.hAlign = SPHAlignLeft;
    lblPlayer2Quarries.x = currentX;
    lblPlayer2Quarries.y = currentY;
    [self addChild:lblPlayer2Quarries];
    currentX = lblPlayer2Quarries.width + stageWidth/2;
    txtPlayer2Quarries = [[SPTextField alloc] initWithWidth:(stageWidth/8)*3 height:15];
    txtPlayer2Quarries.color = 0x0000ff;
//    txtPlayer2Quarries.hAlign = SPHAlignRight;
    txtPlayer2Quarries.x = currentX;
    txtPlayer2Quarries.y = currentY;
    [self addChild:txtPlayer2Quarries];
    
    currentX = txtPlayer1Name.width;
    currentY += lblPlayer2Quarries.height;
    SPTextField *lblPlayer2Magics = [[SPTextField alloc] initWithWidth:stageWidth/8 height:15 text:@"Magics:"];
    lblPlayer2Magics.color = 0x0000ff;
    lblPlayer2Magics.hAlign = SPHAlignLeft;
    lblPlayer2Magics.x = currentX;
    lblPlayer2Magics.y = currentY;
    [self addChild:lblPlayer2Magics];
    currentX = lblPlayer2Magics.width + stageWidth/2;
    txtPlayer2Magics = [[SPTextField alloc] initWithWidth:(stageWidth/8)*3 height:15];
    txtPlayer2Magics.color = 0x0000ff;
//    txtPlayer2Magics.hAlign = SPHAlignRight;
    txtPlayer2Magics.x = currentX;
    txtPlayer2Magics.y = currentY;
    [self addChild:txtPlayer2Magics];
    
    currentX = txtPlayer1Name.width;
    currentY += lblPlayer2Magics.height;
    SPTextField *lblPlayer2Dungeons = [[SPTextField alloc] initWithWidth:stageWidth/8 height:15 text:@"Dungeons:"];
    lblPlayer2Dungeons.color = 0x0000ff;
    lblPlayer2Dungeons.hAlign = SPHAlignLeft;
    lblPlayer2Dungeons.x = currentX;
    lblPlayer2Dungeons.y = currentY;
    [self addChild:lblPlayer2Dungeons];
    currentX = lblPlayer2Dungeons.width + stageWidth/2;
    txtPlayer2Dungeons = [[SPTextField alloc] initWithWidth:(stageWidth/8)*3 height:15];
    txtPlayer2Dungeons.color = 0x0000ff;
//    txtPlayer2Dungeons.hAlign = SPHAlignRight;
    txtPlayer2Dungeons.x = currentX;
    txtPlayer2Dungeons.y = currentY;
    [self addChild:txtPlayer2Dungeons];
    
    currentX = txtPlayer1Name.width;
    currentY += lblPlayer2Dungeons.height+30;
    SPTextField *lblPlayer2Tower = [[SPTextField alloc] initWithWidth:stageWidth/8 height:15 text:@"Tower:"];
    lblPlayer2Tower.color = 0x0000ff;
    lblPlayer2Tower.hAlign = SPHAlignLeft;
    lblPlayer2Tower.x = currentX;
    lblPlayer2Tower.y = currentY;
    [self addChild:lblPlayer2Tower];
    currentX = lblPlayer1Tower.width + stageWidth/2;
    txtPlayer2Tower = [[SPTextField alloc] initWithWidth:(stageWidth/8)*3 height:15];
    txtPlayer2Tower.color = 0x0000ff;
//    txtPlayer2Tower.hAlign = SPHAlignRight;
    txtPlayer2Tower.x = currentX;
    txtPlayer2Tower.y = currentY;
    [self addChild:txtPlayer2Tower];
    
    currentX = txtPlayer1Name.width;
    currentY += lblPlayer2Tower.height;
    SPTextField *lblPlayer2Wall = [[SPTextField alloc] initWithWidth:stageWidth/8 height:15 text:@"Wall:"];
    lblPlayer2Wall.color = 0x0000ff;
    lblPlayer2Wall.hAlign = SPHAlignLeft;
    lblPlayer2Wall.x = currentX;
    lblPlayer2Wall.y = currentY;
    [self addChild:lblPlayer2Wall];
    currentX = lblPlayer2Wall.width + stageWidth/2;
    txtPlayer2Wall = [[SPTextField alloc] initWithWidth:(stageWidth/8)*3 height:15];
    txtPlayer2Wall.color = 0x0000ff;
//    txtPlayer2Wall.hAlign = SPHAlignRight;
    txtPlayer2Wall.x = currentX;
    txtPlayer2Wall.y = currentY;
    [self addChild:txtPlayer2Wall];
    
    // Cards
    CGRect rect = [self cardRect];
    currentX = 0; currentY = 0;
    for (int i=0; i<6; i++)
    {
        SPImage *img = [[SPImage alloc] initWithWidth:rect.size.width height:rect.size.height];
        
        img.texture = [OMedia texture:@"blank" fromAtlas:_deck];
        img.x = currentX;
        img.y = Sparrow.stage.height-img.height;
        currentX += img.width;
        [self addChild:img];
        [img addEventListener:@selector(onCardTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        [hand addObject:img];
    }
    
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
            [self updateStats];
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
    player1.name = @"Player 1";
    
    [player2 draw:[rule cardsInHand]];
    [player2.base setStats:rule.base];
    player2.name = @"A.I.";
    
    _currentPlayer = player1;
    player2.ai = YES;
    players = [[NSArray alloc] initWithObjects:player1, player2, nil];
    
    txtPlayer1Name.text = player1.name;
    txtPlayer2Name.text = player2.name;
}

-(void) showHand
{
    for (int j=0; j<_currentPlayer.hand.count; j++)
    {
        SPImage *img = [hand objectAtIndex:j];
        OCard *card = [_currentPlayer.hand objectAtIndex:j];
        
        [self displayCard:card inImageHolder:img];
    }
    
    for (int i=_currentPlayer.hand.count; i<hand.count; i++)
    {
        SPImage *img = [hand objectAtIndex:i];
        
        img.texture = [OMedia texture:@"blank" fromAtlas:_deck];
        img.alpha = 1.0;
    }
}

-(void) playCard:(OCard*) card
{
    if ([_currentPlayer canPlayCard:card])
    {
        NSLog(@"%@ playing... %@", _currentPlayer.name, [card name]);
        [_currentPlayer play:card onTarget:[self opponentPlayer]];
        [_currentPlayer discard:card];
        [self showHand];
        
        if (card.playAgain)
            _gamePhase = Upkeep;
        else
            _gamePhase = Discard;
    }
}

-(void) discardCard:(OCard*) card
{
    NSLog(@"%@ discarding... %@", _currentPlayer.name, [card name]);
    [_currentPlayer discard:card];
    _gamePhase = Discard;
}

-(void) displayCard:(OCard*) card inImageHolder:(SPImage*)img
{
    SPTexture *texture = [OMedia texture:[card name] fromAtlas:_deck];

    img.texture = texture;
    img.alpha = [_currentPlayer canPlayCard:card] ? 1.0 : 0.2;
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

-(void) updateStats
{
    OPlayer *player1 = [players objectAtIndex:0];
    OPlayer *player2 = [players objectAtIndex:1];
    
    txtPlayer1Tower.text = [NSString stringWithFormat:@"%d", player1.base.tower];
    txtPlayer1Wall.text = [NSString stringWithFormat:@"%d", player1.base.wall];
    txtPlayer1Quarries.text = [NSString stringWithFormat:@"%d/%d", player1.base.bricks, player1.base.quarries];
    txtPlayer1Magics.text = [NSString stringWithFormat:@"%d/%d", player1.base.gems, player1.base.magics];
    txtPlayer1Dungeons.text = [NSString stringWithFormat:@"%d/%d", player1.base.recruits, player1.base.dungeons];
    
    txtPlayer2Tower.text = [NSString stringWithFormat:@"%d", player2.base.tower];
    txtPlayer2Wall.text = [NSString stringWithFormat:@"%d", player2.base.wall];
    txtPlayer2Quarries.text = [NSString stringWithFormat:@"%d/%d", player2.base.bricks, player2.base.quarries];
    txtPlayer2Magics.text = [NSString stringWithFormat:@"%d/%d", player2.base.gems, player2.base.magics];
    txtPlayer2Dungeons.text = [NSString stringWithFormat:@"%d/%d", player2.base.recruits, player2.base.dungeons];
}

-(void) gameLoop:(SPEnterFrameEvent*)event
{
    OPlayer *opponent = [self opponentPlayer];
    
    switch (_gamePhase)
    {
        case Upkeep:
        {
            [_currentPlayer upkeep];
            [self updateStats];
            [self showHand];
            _gamePhase = Draw;
            break;
        }
        case Draw:
        {
            int cardsToDraw = rule.cardsInHand - [_currentPlayer.hand count];
            if (cardsToDraw > 0)
            {
                [_currentPlayer draw:cardsToDraw];
                [self showHand];
            }
            _gamePhase = Main;
            break;
        }
        case Main:
        {
            if (_currentPlayer.ai)
            {
                OCard *card = [_currentPlayer chooseCardToPlay];
                
                if (card)
                {
                    [self playCard:card];
                    [self updateStats];
                }
            }
            break;
        }
        case Victory:
        {
            NSMutableArray *winners = [[NSMutableArray alloc] initWithCapacity:2];
            
            for (OPlayer *p in players)
            {
                if (p.base.bricks == rule.base.bricks ||
                    p.base.gems == rule.base.gems ||
                    p.base.recruits == rule.base.recruits)
                {
                    [winners addObject:p];
                }
            }
            
            if (winners.count > 0)
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
