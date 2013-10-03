//
//  OBattle.m
//  Omeotte
//
//  Created by Jovito Royeca on 9/2/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OBattleScene.h"

@implementation OBattleScene
{
    OPlayer *_currentPlayer;
    OCard *_currentCard;
    GamePhase _gamePhase;
    NSTimer *_timer;
    int elapsedTurnTime;
}

@synthesize txtPlayer1Name;
@synthesize player1Resources;
@synthesize player1Health;

@synthesize txtPlayer2Name;
@synthesize player2Resources;
@synthesize player2Health;

@synthesize txtTimer;
@synthesize players;
@synthesize winners;
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
        [self addEventListener:@selector(gameLoop:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    
    for (OCardUI *card in hand)
    {
        [card removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TOUCH];
    }
    [hand release];
    [rule release];
    [players release];
    [winners release];
    [txtPlayer1Name release];
    [player1Resources release];
    [player1Health release];
    [txtPlayer2Name release];
    [player2Resources release];
    [player2Health release];
    
    //    [SPMedia releaseSound];
}

- (void)setup
{
    hand = [[NSMutableArray alloc] initWithCapacity:6];
    
    float _width = Sparrow.stage.width;
    float _height = Sparrow.stage.height;
    float currentX = 0;
    float currentY = 0;
    float currentWidth = 0;
    float currentHeight = 0;
    float cardWidth  = _width/6;
    float cardHeight = (cardWidth*128)/95;
    CGRect cardRect  = CGRectMake(0, 0, cardWidth, cardHeight);
    
    // Background
    SPImage *background = [[SPImage alloc] initWithContentsOfFile:@"background.png"];
    background.width = _width;
    background.height = _height - cardHeight;
    [self addChild:background];
    
    // Player1 Name
    currentWidth = _width*2/5;
    currentHeight = 15;
    txtPlayer1Name = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    txtPlayer1Name.color = 0xff0000;
    txtPlayer1Name.hAlign = SPHAlignLeft;
    txtPlayer1Name.x = currentX;
    txtPlayer1Name.y = currentY;
    [self addChild:txtPlayer1Name];
    
    // Player1 Stats
    currentY += txtPlayer1Name.height+10;
    currentWidth  = RESOURCES_WIDTH_PIXELS*3/5;
    currentHeight = RESOURCES_HEIGHT_PIXELS*3/5;
    player1Resources = [[OResourcesUI alloc] initWithWidth:currentWidth height:currentHeight rule:rule];
    player1Resources.x = currentX;
    player1Resources.y = currentY;
    [self addChild:player1Resources];
    currentX += player1Resources.width;
    currentWidth = (_width*2/5)-currentWidth;
    currentHeight = _height - cardHeight - 40;
    player1Health = [[OHealthUI alloc] initWithWidth:currentWidth height:currentHeight rule:rule  ai:NO];
    player1Health.x = currentX;
    player1Health.y = currentY;
    [self addChild:player1Health];
    
    // Menu and Timer
    currentX = txtPlayer1Name.width;
    currentY = 0;
    currentWidth = _width/5;
    currentHeight = 15;
    SPSprite *container = [[SPSprite alloc] init];
    OButtonTextureUI *texture = [[OButtonTextureUI alloc] initWithWidth:currentWidth
                                                                 height:currentHeight
                                                           cornerRadius:3
                                                            strokeWidth:2
                                                            strokeColor:0xFFFFFF
                                                                  gloss:NO
                                                             startColor:0xff0000
                                                               endColor:0x0000ff];
    SPButton *btnMenu = [SPButton buttonWithUpState:texture text:@"Menu"];
    btnMenu.fontColor = 0xffffff;
    btnMenu.fontSize = 15;
    btnMenu.x = currentX;
    [btnMenu addEventListener:@selector(showMenu) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [container addChild:btnMenu];
    currentY = 1;
    currentHeight = 20;
    txtTimer = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight text:[NSString stringWithFormat:@"%d", GAME_TURN]];
    txtTimer.color = 0xffffff;
    txtTimer.x = currentX;
    txtTimer.y = btnMenu.height+10;
    [container addChild:txtTimer];
    [self addChild:container];
    
    // AI name
    currentX = txtPlayer1Name.width+btnMenu.width;
    currentY = 0;
    currentWidth = _width*2/5;
    currentHeight = 15;
    txtPlayer2Name = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    txtPlayer2Name.color = 0x0000ff;
    txtPlayer2Name.hAlign = SPHAlignLeft;
    txtPlayer2Name.x = currentX;
    txtPlayer2Name.y = currentY;
    txtPlayer2Name.hAlign = SPHAlignRight;
    [self addChild:txtPlayer2Name];
    
    // AI stats
    currentWidth  = RESOURCES_WIDTH_PIXELS*3/5;
    currentHeight = RESOURCES_HEIGHT_PIXELS*3/5;
    currentX = _width-currentWidth;
    currentY += txtPlayer2Name.height+10;
    player2Resources = [[OResourcesUI alloc] initWithWidth:currentWidth height:currentHeight rule:rule];
    player2Resources.x = currentX;
    player2Resources.y = currentY;
    [self addChild:player2Resources];
    currentX = txtPlayer1Name.width+btnMenu.width;
    currentWidth  = (_width*2/5)-currentWidth;
    currentHeight = _height - cardHeight - 40;
    player2Health = [[OHealthUI alloc] initWithWidth:currentWidth height:currentHeight rule:rule ai:YES];
    player2Health.x = currentX;
    player2Health.y = currentY;
    [self addChild:player2Health];
    
    // Cards
    currentX = 0;
    currentY = 0;
    for (int i=0; i<6; i++)
    {
        OCardUI *card = [[OCardUI alloc] initWithWidth:cardRect.size.width height:cardRect.size.height];

        card.x = currentX;
        card.y = Sparrow.stage.height-cardRect.size.height;
        currentX += cardRect.size.width;
        [self addChild:card];
        [hand addObject:card];
        card.delegate = self;
    }
}

-(void) initPlayers
{
    OPlayer *player1 = [[OPlayer alloc] init];
    OPlayer *player2 = [[OPlayer alloc] init];

    [player1 draw:[rule cardsInHand]];
    [player1.base setStats:rule.base];
    player1.name = @"Player 1";
    // to compensate during first Upkeep...
    player1.base.bricks -= rule.base.bricks;
    player1.base.gems -= rule.base.gems;
    player1.base.recruits -= rule.base.recruits;

    [player2 draw:[rule cardsInHand]];
    [player2.base setStats:rule.base];
    player2.name = @"A.I.";
    // to compensate during first Upkeep...
    player2.base.bricks -= rule.base.bricks;
    player2.base.gems -= rule.base.gems;
    player2.base.recruits -= rule.base.recruits;

    _currentPlayer = player1;
    player2.ai = YES;
    players = [[NSArray alloc] initWithObjects:player1, player2, nil];
    
    txtPlayer1Name.text = player1.name;
    txtPlayer2Name.text = player2.name;
}

-(void) gameLoop:(SPEnterFrameEvent*)event
{
    switch (_gamePhase)
    {
        case Upkeep:
        {
            [self upkeepPhase];
            break;
        }
        case Draw:
        {
            [self drawPhase];
            break;
        }
        case Main:
        {
            [self mainPhase];
            break;
        }
        case Victory:
        {
            [self victoryPhase];
            break;
        }
    }
}

-(void) showHand
{
    for (int j=0; j<_currentPlayer.hand.count; j++)
    {
        OCardUI *cardUI = [hand objectAtIndex:j];
        OCard *card = [_currentPlayer.hand objectAtIndex:j];
        
        cardUI.card = card;
        [cardUI paintCard:[_currentPlayer canPlayCard:card]];
    }
}

-(void) playCard:(OCard*) card
{
    if ([_currentPlayer canPlayCard:card])
    {
        [_currentPlayer play:card onTarget:[self opponentPlayer]];
    }
}

-(void) discardCard:(OCard*) card
{
    [_currentPlayer discard:card];
    NSLog(@"%@ discarded: %@", _currentPlayer.name, card.name);
}

-(OPlayer*) opponentPlayer
{
    int i = [players indexOfObject:_currentPlayer];
    int count = [players count];
    return (i == count-1) ? [players objectAtIndex:i-1] : [players objectAtIndex:i+1];
}

-(void) updateStats
{
    OPlayer *player1 = [players objectAtIndex:0];
    OPlayer *player2 = [players objectAtIndex:1];
    
    [player1Resources update:player1.base];
    [player1Health update:player1.base];
    
    [player2Resources update:player2.base];
    [player2Health update:player2.base];
}

-(void) checkWinner
{
    if (!winners)
    {
        winners = [[NSMutableArray alloc] initWithCapacity:2];
    }
    [winners removeAllObjects];
    
    OPlayer *opponentPlayer = [self opponentPlayer];
    
    if (_currentPlayer.base.tower > 0 && opponentPlayer.base.tower <= 0)
    {
        [winners addObject:_currentPlayer];
    }
    else if (opponentPlayer.base.tower > 0 &&  _currentPlayer.base.tower <= 0)
    {
        [winners addObject:opponentPlayer];
    }
    else
    {
        if (_currentPlayer.base.tower >= rule.winningTower ||
            _currentPlayer.base.bricks >= rule.winningResource ||
            _currentPlayer.base.gems >= rule.winningResource ||
            _currentPlayer.base.recruits >= rule.winningResource)
        {
            [winners addObject:_currentPlayer];
        }
        
        if (opponentPlayer.base.tower >= rule.winningTower ||
            opponentPlayer.base.bricks >= rule.winningResource ||
            opponentPlayer.base.gems >= rule.winningResource ||
            opponentPlayer.base.recruits >= rule.winningResource)
        {
            [winners addObject:opponentPlayer];
        }
    }
    
    if (winners.count > 0)
    {
        _gamePhase = Victory;
    }
}

-(void) showMenu
{
    OMenuScene *menu = [[OMenuScene alloc] init];
    OGameScene* game = (OGameScene*)self.root;
    
    [game showScene:menu];
}

- (void)timerTick:(NSTimer *)timer
{
    elapsedTurnTime--;
    txtTimer.text = [NSString stringWithFormat:@"%@%d", (elapsedTurnTime < 10 ? @"0" : @""), elapsedTurnTime];
}

-(void) switchTurn:(OPlayer*)activePlayer
{
    _gamePhase = Upkeep;
    _currentPlayer = activePlayer;
    _currentCard = nil;
    [_timer invalidate];
    _timer = nil;
}

-(void) upkeepPhase
{
    [_currentPlayer upkeep];
    [self updateStats];
    [self showHand];
    _gamePhase = Draw;
}

-(void) drawPhase
{
    int cardsToDraw = rule.cardsInHand - [_currentPlayer.hand count];
    
    if (cardsToDraw > 0)
    {
        [_currentPlayer draw:cardsToDraw];
        [self showHand];
    }
    _gamePhase = Main;
}

-(void) mainPhase
{
    OPlayer *opponentPlayer = [self opponentPlayer];

    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(timerTick:)
                                                userInfo:nil
                                                 repeats:YES];
        elapsedTurnTime = GAME_TURN;
    }

    if (_currentPlayer.ai)
    {
        _currentCard = [_currentPlayer chooseCardToPlay];
    }
    
    if (_currentCard)
    {
        [self playCard:_currentCard];
        [self showHand];
        [self updateStats];
        [self checkWinner];

        if (_gamePhase != Victory)
        {
            [self switchTurn:_currentCard.playAgain ? _currentPlayer : opponentPlayer];
        }
    }
    else
    {
        if (_currentPlayer.ai)
        {
            _currentCard = [_currentPlayer chooseCardToDiscard];

            if (_currentCard)
            {
                [self discardCard:_currentCard];
            }

            [self switchTurn:opponentPlayer];
        }
    }

    if (elapsedTurnTime <= 0)
    {
        [self switchTurn:opponentPlayer];
    }
}

-(void) victoryPhase
{
    NSString *message = nil;
    
    switch (winners.count)
    {
        case 1:
        {
            if ([winners containsObject:_currentPlayer])
            {
                message = @"Victory";
            }
            else if ([winners containsObject:[self opponentPlayer]])
            {
                message = @"Defeat";
            }
            break;
        }
        case 2:
        {
            message = @"Draw";
            break;
        }
        default:
            break;
    }
    
    if (message)
    {
        UIAlertView *alertMessage =  [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
        [alertMessage show];
        [self showMenu];
    }
}

#pragma mark - OCardUIDelegate
- (void)promote:(OCard*)card
{
    NSLog(@"promote... %@", card.name);
}

- (void)play:(OCard*)card
{
    NSLog(@"play... %@", card.name);
    _currentCard = card;
}

- (void)discard:(OCard*)card
{
    NSLog(@"discard... %@", card.name);
    [self discardCard:card];
    [self switchTurn:[self opponentPlayer]];
}

- (void)demote:(OCard*)card
{
    NSLog(@"demote... %@", card.name);
}

@end
