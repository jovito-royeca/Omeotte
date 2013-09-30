//
//  OBattle.m
//  Omeotte
//
//  Created by Jovito Royeca on 9/2/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OBattleScene.h"

@implementation OBattleScene

@synthesize txtPlayer1Name;
@synthesize player1Resources;
@synthesize txtPlayer1Tower;
@synthesize txtPlayer1Wall;

@synthesize txtPlayer2Name;
@synthesize player2Resources;
@synthesize txtPlayer2Tower;
@synthesize txtPlayer2Wall;

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
    [txtPlayer1Tower release];
    [txtPlayer1Wall release];
    [txtPlayer2Name release];
    [player2Resources release];
    [txtPlayer2Tower release];
    [txtPlayer2Wall release];
    
    //    [SPMedia releaseSound];
}

- (void)setup
{
    hand = [[NSMutableArray alloc] initWithCapacity:6];
    
    int stageWidth = Sparrow.stage.width;
//    int stageHeight = Sparrow.stage.height;
    int currentX = 0, currentY = 0;
    
    // To do: lay the background
    // ...
    
    // To do: lay the Player stats
    txtPlayer1Name = [[SPTextField alloc] initWithWidth:stageWidth/3 height:15];
    txtPlayer1Name.color = 0xff0000;
    txtPlayer1Name.hAlign = SPHAlignLeft;
    txtPlayer1Name.x = currentX;
    txtPlayer1Name.y = currentY;
    [self addChild:txtPlayer1Name];
    
    currentY += txtPlayer1Name.height+10;
    player1Resources = [[OResourcesUI alloc] initWithWidth:78*3/5 height:216*3/5 rule:rule];
    player1Resources.x = currentX;
    player1Resources.y = currentY;
    [self addChild:player1Resources];
    
    currentY += player1Resources.height+10;
    SPTextField *lblPlayer1Tower = [[SPTextField alloc] initWithWidth:stageWidth/6 height:15 text:@"Tower:"];
    lblPlayer1Tower.color = 0xff0000;
    lblPlayer1Tower.hAlign = SPHAlignLeft;
    lblPlayer1Tower.x = currentX;
    lblPlayer1Tower.y = currentY;
    [self addChild:lblPlayer1Tower];
    currentX = lblPlayer1Tower.width;
    txtPlayer1Tower = [[SPTextField alloc] initWithWidth:stageWidth/6 height:15];
    txtPlayer1Tower.color = 0xff0000;
    txtPlayer1Tower.x = currentX;
    txtPlayer1Tower.y = currentY;
    [self addChild:txtPlayer1Tower];
    
    currentX = 0;
    currentY += lblPlayer1Tower.height;
    SPTextField *lblPlayer1Wall = [[SPTextField alloc] initWithWidth:stageWidth/6 height:15 text:@"Wall:"];
    lblPlayer1Wall.color = 0xff0000;
    lblPlayer1Wall.hAlign = SPHAlignLeft;
    lblPlayer1Wall.x = currentX;
    lblPlayer1Wall.y = currentY;
    [self addChild:lblPlayer1Wall];
    currentX = lblPlayer1Wall.width;
    txtPlayer1Wall = [[SPTextField alloc] initWithWidth:stageWidth/6 height:15];
    txtPlayer1Wall.color = 0xff0000;
    txtPlayer1Wall.x = currentX;
    txtPlayer1Wall.y = currentY;
    [self addChild:txtPlayer1Wall];
    
    // Exit
    currentX = txtPlayer1Name.width;
    currentY = 0;
    SPSprite *container = [[SPSprite alloc] init];
    OButtonTextureUI *texture = [[OButtonTextureUI alloc] initWithWidth:stageWidth/3 height:15 cornerRadius:3 strokeWidth:2 strokeColor:0xFFFFFF gloss:NO startColor:0xff0000 endColor:0x0000ff];
    SPButton *btnExit = [SPButton buttonWithUpState:texture text:@"Exit"];
    btnExit.fontColor = 0xffffff;
    btnExit.fontSize = 15;
    btnExit.x = currentX;
    [btnExit addEventListener:@selector(showMenu) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [container addChild:btnExit];
    currentY = 1;
    txtTimer = [[SPTextField alloc] initWithWidth:stageWidth/3 height:20 text:[NSString stringWithFormat:@"%d", GAME_TURN]];
    txtTimer.color = 0xffffff;
    txtTimer.x = currentX;
    txtTimer.y = btnExit.height+10;
    [container addChild:txtTimer];
    [self addChild:container];
    
    // AI
    currentX = txtPlayer1Name.width*2;
    currentY = 0;
    txtPlayer2Name = [[SPTextField alloc] initWithWidth:stageWidth/3 height:15];
    txtPlayer2Name.color = 0x0000ff;
    txtPlayer2Name.hAlign = SPHAlignLeft;
    txtPlayer2Name.x = currentX;
    txtPlayer2Name.y = currentY;
    txtPlayer2Name.hAlign = SPHAlignRight;
    [self addChild:txtPlayer2Name];
    
    player2Resources = [[OResourcesUI alloc] initWithWidth:78*3/5 height:216*3/5 rule:rule];
    currentX = stageWidth-player2Resources.width;
    currentY += txtPlayer2Name.height+10;
    player2Resources.x = currentX;
    player2Resources.y = currentY;
    [self addChild:player2Resources];

    currentX = txtPlayer1Name.width*2;
    currentY += player2Resources.height+10;
    SPTextField *lblPlayer2Tower = [[SPTextField alloc] initWithWidth:stageWidth/6 height:15 text:@"Tower:"];
    lblPlayer2Tower.color = 0x0000ff;
    lblPlayer2Tower.hAlign = SPHAlignLeft;
    lblPlayer2Tower.x = currentX;
    lblPlayer2Tower.y = currentY;
    [self addChild:lblPlayer2Tower];
    currentX = lblPlayer1Tower.width + txtPlayer1Name.width*2;
    txtPlayer2Tower = [[SPTextField alloc] initWithWidth:stageWidth/6 height:15];
    txtPlayer2Tower.color = 0x0000ff;
    txtPlayer2Tower.x = currentX;
    txtPlayer2Tower.y = currentY;
    [self addChild:txtPlayer2Tower];
    
    currentX = txtPlayer1Name.width*2;
    currentY += lblPlayer2Tower.height;
    SPTextField *lblPlayer2Wall = [[SPTextField alloc] initWithWidth:stageWidth/6 height:15 text:@"Wall:"];
    lblPlayer2Wall.color = 0x0000ff;
    lblPlayer2Wall.hAlign = SPHAlignLeft;
    lblPlayer2Wall.x = currentX;
    lblPlayer2Wall.y = currentY;
    [self addChild:lblPlayer2Wall];
    currentX = lblPlayer2Wall.width + txtPlayer1Name.width*2;
    txtPlayer2Wall = [[SPTextField alloc] initWithWidth:stageWidth/6 height:15];
    txtPlayer2Wall.color = 0x0000ff;
    txtPlayer2Wall.x = currentX;
    txtPlayer2Wall.y = currentY;
    [self addChild:txtPlayer2Wall];
    
    // Cards
    CGRect rect = [self cardRect];
    currentX = 0; currentY = 0;
    for (int i=0; i<6; i++)
    {
        OCardUI *card = [[OCardUI alloc] initWithWidth:rect.size.width height:rect.size.height];

        card.x = currentX;
        card.y = Sparrow.stage.height-rect.size.height;
        currentX += rect.size.width;
        [self addChild:card];
        [hand addObject:card];
        card.delegate = self;
    }
    
    // To do: lay the Castles and Walls
    // ...
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
    
    [player1Resources update:player1.base];
    txtPlayer1Tower.text = [NSString stringWithFormat:@"%d", player1.base.tower];
    txtPlayer1Wall.text = [NSString stringWithFormat:@"%d", player1.base.wall];
    
    [player2Resources update:player1.base];
    txtPlayer2Tower.text = [NSString stringWithFormat:@"%d", player2.base.tower];
    txtPlayer2Wall.text = [NSString stringWithFormat:@"%d", player2.base.wall];
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
    NSLog(@"promote...");
}

- (void)play:(OCard*)card
{
    NSLog(@"play...");
    _currentCard = card;
}

- (void)discard:(OCard*)card
{
    NSLog(@"discard...");
    [self discardCard:card];
    [self switchTurn:[self opponentPlayer]];
}

- (void)demote:(OCard*)card
{
    NSLog(@"demote...");
}

@end
