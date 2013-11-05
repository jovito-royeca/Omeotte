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
    SPButton *_btnMenu;
    SPSprite *_spDialog;
    OPlayer *_currentPlayer;
    OCard *_currentCard;
    GamePhase _gamePhase;
    int _turns;
    NSTimer *_timer;
    int elapsedTurnTime;
    OFx *_effects;
//    SPImage *_imgCardBottom;
    SPButton *_btnPlay;
    SPButton *_btnDiscard;
}

@synthesize txtPlayer1Name;
@synthesize txtPlayer1Status;
@synthesize player1Resources;
@synthesize player1Health;

@synthesize txtPlayer2Name;
@synthesize txtPlayer2Status;
@synthesize player2Resources;
@synthesize player2Health;

@synthesize txtTimer;
@synthesize deckAndGraveyard;
@synthesize players;
@synthesize hand;
@synthesize winners;
@synthesize rule;

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
        _effects = [[OFx alloc] init];
        
        [self setup];
        [self initPlayers];
        [self addEventListener:@selector(gameLoop:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    }
    return self;
}

- (void)dealloc
{
    [rule release];
    [players release];
    [hand release];
    [winners release];
    [txtPlayer1Name release];
    [txtPlayer1Status release];
    [player1Resources release];
    [player1Health release];
    [txtPlayer2Name release];
    [txtPlayer2Status release];
    [player2Resources release];
    [player2Health release];
    [txtTimer release];
    [deckAndGraveyard release];
    [_effects release];
    [_btnMenu release];
    [_spDialog release];
    [super dealloc];
}

- (void)setup
{
    float _width = Sparrow.stage.width;
    float _height = Sparrow.stage.height;
    float currentX = 0;
    float currentY = 0;
    float currentWidth = 0;
    float currentHeight = 0;
    float cardWidth  = _width/6;
    float cardHeight = (cardWidth*128)/95;
    
    // Background
    SPImage *background = [[SPImage alloc] initWithContentsOfFile:@"background.png"];
    background.width = _width;
    background.height = _height - cardHeight - 40;
    background.blendMode = SPBlendModeNone;
    [self addChild:background];
    
    SPImage *scroll = [[SPImage alloc] initWithContentsOfFile:@"scroll.png"];
    scroll.width = _width;
    scroll.height = cardHeight + 40;
    scroll.y = _height - cardHeight - 40;
    scroll.blendMode = SPBlendModeNone;
    [self addChild:scroll];
    
    // Player1 Name
    currentWidth = (_width*2/5)*0.30;
    currentHeight = 15;
    txtPlayer1Name = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    txtPlayer1Name.color = RED_COLOR;
    txtPlayer1Name.hAlign = SPHAlignLeft;
    txtPlayer1Name.x = currentX;
    txtPlayer1Name.y = currentY;
    txtPlayer1Name.fontName = EXETER_FONT;
    [self addChild:txtPlayer1Name];
    currentWidth = (_width*2/5)*0.70;
    txtPlayer1Status = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    txtPlayer1Status.color = WHITE_COLOR;
    txtPlayer1Status.hAlign = SPHAlignLeft;
    txtPlayer1Status.x = txtPlayer1Name.width;
    txtPlayer1Status.y = currentY;
    txtPlayer1Status.fontName = EXETER_FONT;
    [self addChild:txtPlayer1Status];
    
    // Menu and Timer
    currentX = _width*2/5;
    currentWidth = _width/5;
    currentHeight = 15;
    SPSprite *container = [[SPSprite alloc] init];
    OButtonTextureUI *texture = [[OButtonTextureUI alloc] initWithWidth:currentWidth
                                                                 height:currentHeight
                                                           cornerRadius:3
                                                            strokeWidth:2
                                                            strokeColor:WHITE_COLOR
                                                                  gloss:NO
                                                             startColor:RED_COLOR
                                                               endColor:BLUE_COLOR];
    _btnMenu = [SPButton buttonWithUpState:texture text:@"Menu"];
    _btnMenu.fontColor = WHITE_COLOR;
    _btnMenu.fontSize = 15;
    _btnMenu.x = currentX;
    _btnMenu.fontName = EXETER_FONT;
    [_btnMenu addEventListener:@selector(showMenu) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [container addChild:_btnMenu];
    currentY = 1;
    currentHeight = 20;
    txtTimer = [[SPTextField alloc] initWithWidth:currentWidth
                                           height:currentHeight
                                             text:[NSString stringWithFormat:@"%d", GAME_TURN]];
    txtTimer.x = currentX;
    txtTimer.y = _btnMenu.height+10;
    txtTimer.color = WHITE_COLOR;
    txtTimer.fontName = EXETER_FONT;
    txtTimer.fontSize = currentHeight;
    [container addChild:txtTimer];
    [self addChild:container];
    
    // AI name
    currentX = _width*3/5;
    currentY = 0;
    currentWidth = (_width*2/5)*0.70;
    currentHeight = 15;
    txtPlayer2Status = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    txtPlayer2Status.color = WHITE_COLOR;
    txtPlayer2Status.hAlign = SPHAlignRight;
    txtPlayer2Status.x = currentX;
    txtPlayer2Status.y = currentY;
    txtPlayer2Status.fontName = EXETER_FONT;
    [self addChild:txtPlayer2Status];
    currentX = (_width*3/5)+txtPlayer2Status.width;
    currentWidth = (_width*2/5)*0.30;
    txtPlayer2Name = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    txtPlayer2Name.color = BLUE_COLOR;
    txtPlayer2Name.hAlign = SPHAlignLeft;
    txtPlayer2Name.x = currentX;
    txtPlayer2Name.y = currentY;
    txtPlayer2Name.hAlign = SPHAlignRight;
    txtPlayer2Name.fontName = EXETER_FONT;
    [self addChild:txtPlayer2Name];
    
    // Player1 Stats
    currentX = 0;
    currentY = txtPlayer1Name.height+10;
    currentWidth  = RESOURCES_WIDTH_PIXELS*3/5;
    currentHeight = RESOURCES_HEIGHT_PIXELS*3/5;
    player1Resources = [[OResourcesUI alloc] initWithWidth:currentWidth height:currentHeight rule:rule];
    player1Resources.x = currentX;
    player1Resources.y = currentY;
    [self addChild:player1Resources];
    currentX += player1Resources.width;
    currentWidth = (_width*1.5/5)-currentWidth;
    currentHeight = _height - cardHeight - 40;
    player1Health = [[OHealthUI alloc] initWithWidth:currentWidth height:currentHeight rule:rule  ai:NO];
    player1Health.x = currentX;
    player1Health.y = currentY;
    [self addChild:player1Health];

    // deck and graveyard
    currentX = (_width*1.5/5);
    currentY = _btnMenu.height+10+txtTimer.height;
    currentWidth = (_width*2/5);
    currentHeight = (((Sparrow.stage.width/6)*128)/95)+20;
    deckAndGraveyard = [[ODeckAndGraveyardUI alloc] initWithWidth:currentWidth height:currentHeight];
    deckAndGraveyard.x = currentX;
    deckAndGraveyard.y = currentY;
    [self addChild:deckAndGraveyard];
    //
    
    // AI stats
    currentWidth  = RESOURCES_WIDTH_PIXELS*3/5;
    currentHeight = RESOURCES_HEIGHT_PIXELS*3/5;
    currentX = _width-currentWidth;
    currentY = txtPlayer2Name.height+10;
    player2Resources = [[OResourcesUI alloc] initWithWidth:currentWidth height:currentHeight rule:rule];
    player2Resources.x = currentX;
    player2Resources.y = currentY;
    [self addChild:player2Resources];
    currentX = _width*3.5/5;
    currentWidth  = (_width*1.5/5)-currentWidth;
    currentHeight = _height - cardHeight - 40;
    player2Health = [[OHealthUI alloc] initWithWidth:currentWidth height:currentHeight rule:rule ai:YES];
    player2Health.x = currentX;
    player2Health.y = currentY;
    [self addChild:player2Health];
}

-(void) initPlayers
{
    OPlayer *player1 = [[OPlayer alloc] init];
    OPlayer *player2 = [[OPlayer alloc] init];

//    [player1 draw:[rule cardsInHand]];
    player1.name = @"Player 1";
    player1.base.tower    = rule.base.tower;
    player1.base.wall     = rule.base.tower;
    player1.base.quarries = rule.base.quarries;
    player1.base.magics   = rule.base.magics;
    player1.base.dungeons = rule.base.dungeons;
    player1.delegate = self;

//    [player2 draw:[rule cardsInHand]];
    player2.name = @"A.I.";
    player2.base.tower    = rule.base.tower;
    player2.base.wall     = rule.base.tower;
    player2.base.quarries = rule.base.quarries;
    player2.base.magics   = rule.base.magics;
    player2.base.dungeons = rule.base.dungeons;
    player2.delegate = self;

    _currentPlayer = player1;
    player2.ai = YES;
    players = [[NSArray alloc] initWithObjects:player1, player2, nil];
    
    txtPlayer1Name.text = player1.name;
    txtPlayer2Name.text = player2.name;
    
    hand = [[NSMutableDictionary alloc] init];
    for (int i=0; i<MAX_CARDS_IN_HAND; i++)
    {
        [hand setObject:[NSNull null] forKey:[NSString stringWithFormat:@"%d", i]];
    }
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
        case GameOver:
        {
            [self gameOverPhase];
            break;
        }
        case Pause:
        {
            break;
        }
    }
    
    // animate
    if (_gamePhase != Pause || _gamePhase != GameOver)
    {
        [_effects advanceTime:event.passedTime];
        [player1Resources advanceTime:event.passedTime];
        [player1Health advanceTime:event.passedTime];
        [player2Resources advanceTime:event.passedTime];
        [player2Health advanceTime:event.passedTime];
    }
}

-(void) playCard:(OCard*) card
{
    [_currentPlayer play:card onTarget:[self opponentPlayer]];
        
    NSString *status = [NSString stringWithFormat:@"Played %@.", card.name];
    if (_currentPlayer.ai)
    {
        txtPlayer2Status.text = status;
    }
    else
    {
        txtPlayer1Status.text = status;
    }
}

-(void) discardCard:(OCard*) card
{
    [_currentPlayer discard:card];
    
    NSString *status = [NSString stringWithFormat:@"Discarded %@.", card.name];
    if (_currentPlayer.ai)
    {
        txtPlayer2Status.text = status;
    }
    else
    {
        txtPlayer1Status.text = status;
    }
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
        _gamePhase = GameOver;
        _currentCard = nil;
        [_timer invalidate];
        _timer = nil;
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
    if (_gamePhase != Pause || _gamePhase != GameOver)
    {
        elapsedTurnTime--;
        txtTimer.color = elapsedTurnTime <= 5 ? RED_COLOR : WHITE_COLOR;
        txtTimer.text = [NSString stringWithFormat:@"%@%d", (elapsedTurnTime < 10 ? @"0" : @""), elapsedTurnTime];
    }
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
    [deckAndGraveyard changePlayer:_currentPlayer];
    [_currentPlayer upkeep];
    [self updateStats];
    _gamePhase = Draw;
    
    if (_currentPlayer.ai)
    {
        txtPlayer1Name.text = [NSString stringWithFormat:@"%@", [self opponentPlayer].name];
        txtPlayer2Name.text = [NSString stringWithFormat:@"** %@", _currentPlayer.name];
    }
    else
    {
        txtPlayer1Name.text = [NSString stringWithFormat:@"%@ **", _currentPlayer.name];
        txtPlayer2Name.text = [NSString stringWithFormat:@"%@", [self opponentPlayer].name];
    }
}

-(void) drawPhase
{
    int cardsToDraw = _turns == 0 ?
        rule.cardsInHand : MAX_CARDS_IN_HAND - [_currentPlayer.hand count];
    
    if (cardsToDraw > 0)
    {
        [_currentPlayer draw:cardsToDraw];
    }
    _gamePhase = Main;
}

-(void) mainPhase
{
    OPlayer *opponentPlayer = [self opponentPlayer];
//    BOOL turnTaken = NO;
    
    if (!_timer)
    {
        elapsedTurnTime = GAME_TURN;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(timerTick:)
                                                userInfo:nil
                                                 repeats:YES];
    }

    if (_currentPlayer.ai)
    {
        _currentCard = [_currentPlayer chooseCardToPlay];
    }
    
    if (_currentCard)
    {
        if ([_currentPlayer canPlayCard:_currentCard])
        {
            [self playCard:_currentCard];
            [self updateStats];
            [self checkWinner];
            
            if (_gamePhase != GameOver)
            {
                if ([_currentCard hasSpecialPower:CardDraw])
                {
                    int cardsToDraw = MAX_CARDS_IN_HAND - [_currentPlayer.hand count];
                    
                    if (cardsToDraw > 0)
                    {
                        [_currentPlayer draw:cardsToDraw];
                    }
                    [self animateShowHand];
                }
                
                if ([_currentCard hasSpecialPower:CardDiscard])
                {
                    if (_currentPlayer.ai)
                    {
                        _currentCard = [_currentPlayer chooseCardToDiscard];
                        
                        if (_currentCard)
                        {
                            [self discardCard:_currentCard];
                        }
                    }
                    else
                    {
                        // handle discard here...
                    }
                }

                if ([_currentCard hasSpecialPower:CardPlayAnother])
                {
                    _currentCard = nil;
                    [_timer invalidate];
                    _timer = nil;
                    _turns++;
                    [self animateShowHand];
                    return;
                }
                
                _turns++;
                [self switchTurn:opponentPlayer];
            }
        }
        else
        {
            [self animateShowHand];
            _currentCard = nil;
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

            _turns++;
            [self switchTurn:opponentPlayer];
        }
    }

    if (elapsedTurnTime <= 0)
    {
        _turns++;
        [self switchTurn:opponentPlayer];
    }
}

-(void) gameOverPhase
{
    if (!_spDialog)
    {
        NSString *szMessage = nil;
        NSString *szBackground = nil;
        SoundType stSound = -1;
    
        switch (winners.count)
        {
            case 1:
            {
                if ([winners containsObject:players[0]])
                {
                    szMessage = @"Victory";
                    szBackground = @"winner.png";
                    stSound = VictorySound;
                }
                else if ([winners containsObject:players[1]])
                {
                    szMessage = @"Defeat";
                    szBackground = @"looser.png";
                    stSound = DefeatSound;
                }
                break;
            }
            case 2:
            {
                szMessage = @"Draw";
                szBackground = @"draw.png";
                break;
            }
        }
    
        float _width = 352/2;
        float _height = 128/2;
    
        _spDialog = [[SPSprite alloc] init];
        _spDialog.width = _width;
        _spDialog.height = _height;
        _spDialog.x = (Sparrow.stage.width-_width)/2;
        _spDialog.y = (Sparrow.stage.height-_height)/2;
        SPImage *background = [[SPImage alloc] initWithContentsOfFile:szBackground];
        background.width = _width;
        background.height = _height;
        background.blendMode = SPBlendModeNone;
        [_spDialog addChild:background];
        SPTextField *txtMessage = [[SPTextField alloc] initWithWidth:_width height:_height text:szMessage];
        txtMessage.fontName = CALLIGRAPHICA_FONT;
        txtMessage.fontSize = _height/2;
        txtMessage.color = WHITE_COLOR;
        [_spDialog addChild:txtMessage];
        [_spDialog addEventListener:@selector(showMenu) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    
        for (NSString *key in [hand allKeys])
        {
            if ([hand objectForKey:key] != [NSNull null])
            {
                OCardUI *cardUI = [hand objectForKey:key];
                [cardUI removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TOUCH];
            }
        }
        [_btnMenu removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    
        [self addChild:_spDialog];
        [_effects playSound:stSound loop:YES];
    }
}

#pragma mark - OCardUIDelegate
- (void)promote:(OCardUI*)cardUI
{
    if (!_currentPlayer.ai)
    {
//        NSLog(@"promote... %@", cardUI.card.name);
        
        // demote other cards in hand
        for (NSString *key in [hand allKeys])
        {
            OCardUI *x = [hand objectForKey:key];
            
            if (x != (id)[NSNull null])
            {
                if (x == cardUI)
                {
                    continue;
                }
                else
                {
                    [self demote:x];
                }
            }
        }
        
        NSMutableDictionary *props = [[NSMutableDictionary alloc] init];
        [props setObject:[NSNumber numberWithFloat:cardUI.x] forKey:@"x"];
        [props setObject:[NSNumber numberWithFloat:cardUI.y-20] forKey:@"y"];
        [props setObject:[NSNumber numberWithFloat:cardUI.width] forKey:@"width"];
        [props setObject:[NSNumber numberWithFloat:cardUI.height] forKey:@"height"];

        [_effects animate:cardUI withPropeties:props time:0.2 callback:^
        {
            float cardWidth  = Sparrow.stage.width/6;
            float cardHeight = (cardWidth*128)/95;
            
            OButtonTextureUI *texture = [[OButtonTextureUI alloc] initWithWidth:cardWidth/2
                                                                         height:20
                                                                   cornerRadius:3
                                                                    strokeWidth:2
                                                                    strokeColor:WHITE_COLOR
                                                                          gloss:NO
                                                                     startColor:RED_COLOR
                                                                       endColor:BLUE_COLOR];
            if (!_btnDiscard)
            {
                _btnDiscard = [SPButton buttonWithUpState:texture text:@"Discard"];
                _btnDiscard.x = cardUI.x;
                _btnDiscard.y = cardUI.y+cardHeight;
                _btnDiscard.fontColor = WHITE_COLOR;
                _btnDiscard.fontSize = 10;
                _btnDiscard.fontName = EXETER_FONT;
                [_btnDiscard addEventListenerForType:SP_EVENT_TYPE_TRIGGERED block:^(SPEvent *event)
                 {
                     [self discard:cardUI];
                 }];
                [self addChild:_btnDiscard];
            }
            
            if (!_btnPlay)
            {
                _btnPlay = [SPButton buttonWithUpState:texture text:@"Play"];
                _btnPlay.x = cardUI.x+cardWidth/2;
                _btnPlay.y = cardUI.y+cardHeight;
                _btnPlay.fontColor = WHITE_COLOR;
                _btnPlay.fontSize = 10;
                _btnPlay.fontName = EXETER_FONT;
                [_btnPlay addEventListenerForType:SP_EVENT_TYPE_TRIGGERED block:^(SPEvent *event)
                 {
                     [self play:cardUI];
                 }];
                [self addChild:_btnPlay];
            }
        }];
    }
}

- (void)play:(OCardUI*)cardUI
{
    cardUI.cardStatus = InStack;
    
    if (!_currentPlayer.ai)
    {
//        NSLog(@"play... %@", cardUI.card.name);
        _currentCard = cardUI.card;
    }
}

- (void)discard:(OCardUI*)cardUI
{
    if (!_currentPlayer.ai)
    {
        if ([cardUI.card hasSpecialPower:CardUndiscardable])
        {
            NSLog(@"Card undiscardable... %@", cardUI.card.name);
        }
        else
        {
//            NSLog(@"discard... %@", cardUI.card.name);
            [self discardCard:cardUI.card];
            [self switchTurn:[self opponentPlayer]];
        }
    }
}

- (void)demote:(OCardUI*)cardUI
{
    if (!_currentPlayer.ai)
    {
        float cardWidth  = Sparrow.stage.width/6;
        float cardHeight = (cardWidth*128)/95;
        float y = Sparrow.stage.height-cardHeight;
        
//        if (cardUI.y < y)
//        {
//            NSLog(@"demote... %@", cardUI.card.name);
            NSMutableDictionary *props = [[NSMutableDictionary alloc] init];
            [props setObject:[NSNumber numberWithFloat:cardUI.x] forKey:@"x"];
            [props setObject:[NSNumber numberWithFloat:y] forKey:@"y"];
            [props setObject:[NSNumber numberWithFloat:cardUI.width] forKey:@"width"];
            [props setObject:[NSNumber numberWithFloat:cardUI.height] forKey:@"height"];
            
            [_effects animate:cardUI withPropeties:props time:0.2 callback:^
            {
                cardUI.selected = NO;
                cardUI.cardStatus = InHand;
                [self removeCardBottom];
            }];
//        }
    }
}

#pragma mark - OPlayeAnimationrDelegate
-(void) animateStatChanged:(StatField)field
         fieldValue:(int)fieldValue
           modValue:(int)modValue
             player:(OPlayer*)player
{
    OResourcesUI *resourcesUI;
    OHealthUI *healthUI;
    float x = 0;
    float width35 = (Sparrow.stage.width*3.5/5);
    
    if (player == players[0])
    {
        resourcesUI = player1Resources;
        healthUI = player1Health;
        
    }
    else if (player == players[1])
    {
        resourcesUI = player2Resources;
        healthUI = player2Health;
    }
    
    switch (field)
    {
        case Tower:
        {
            x = (player == players[1]) ?
                width35 + healthUI.lblTower.x : resourcesUI.width;
            break;
        }
        case Wall:
        {
            x = (player == players[1]) ?
                width35 + healthUI.lblWall.x : resourcesUI.width + healthUI.lblWall.x;
            break;
        }
        
        case Bricks:
        case Gems:
        case Recruits:
        case Quarries:
        case Magics:
        case Dungeons:
        {
            x = (player == players[1]) ?
                Sparrow.stage.width-(RESOURCES_WIDTH_PIXELS*3/5) :
                0;
            break;
        }
        default:
        {
            break;
        }
    }

    switch (field)
    {
        case Tower:
        {
            [_effects applyFloatingTextOnStatField:healthUI.lblTower
                                             field:Tower
                                          modValue:modValue
                                           xOffset:x
                                           yOffset:healthUI.lblTower.y
                                            parent:self];
            if (modValue < 0)
            {
                [_effects setFireOnStructure:healthUI.imgTower
                                     xOffset:x+healthUI.towerCenterX
                                     yOffset:healthUI.y+healthUI.towerCenterY
                                      parent:self];
                [_effects playSound:TowerDownSound loop:NO];
            }
            else
            {
                [_effects playSound:TowerUpSound loop:NO];
            }
            break;
        }
        case Wall:
        {
            int result = fieldValue+modValue;
            
            if (result > 0)
            {
                [_effects applyFloatingTextOnStatField:healthUI.lblWall
                                                 field:Wall
                                              modValue:modValue
                                               xOffset:x
                                               yOffset:healthUI.lblWall.y
                                                parent:self];
                if (modValue < 0)
                {
                    [_effects setFireOnStructure:healthUI.imgWall
                                         xOffset:x+healthUI.wallCenterX
                                         yOffset:healthUI.y+healthUI.wallCenterY
                                          parent:self];
                    [_effects playSound:WallDownSound loop:NO];
                }
                else
                {
                    [_effects playSound:WallUpSound loop:NO];
                }
            }
            
            // wall can't take more damage; apply extra damage to Tower
            else if (result < 0)
            {
                x = (player == players[1]) ?
                    width35 + healthUI.lblTower.x : resourcesUI.width;
                
                [_effects applyFloatingTextOnStatField:healthUI.lblTower
                                                 field:Tower
                                              modValue:result
                                               xOffset:x
                                               yOffset:healthUI.lblTower.y
                                                parent:self];

                [_effects setFireOnStructure:healthUI.imgTower
                                     xOffset:x+healthUI.towerCenterX
                                     yOffset:healthUI.y+healthUI.towerCenterY
                                      parent:self];
            }
            
            break;
        }
        case Bricks:
        {
            [_effects applyFloatingTextOnStatField:resourcesUI.lblBricks
                                             field:Bricks
                                          modValue:modValue
                                           xOffset:x
                                           yOffset:resourcesUI.lblBricks.y
                                            parent:self];
            [_effects playSound:modValue<0 ? ResourcesDownSound : ResourcesUpSound  loop:NO];
            break;
        }
        case Gems:
        {
            [_effects applyFloatingTextOnStatField:resourcesUI.lblGems
                                             field:Gems
                                          modValue:modValue
                                           xOffset:x
                                           yOffset:resourcesUI.lblGems.y
                                            parent:self];
            [_effects playSound:modValue<0 ? ResourcesDownSound : ResourcesUpSound loop:NO];
            break;
        }
        case Recruits:
        {
            [_effects applyFloatingTextOnStatField:resourcesUI.lblRecruits
                                             field:Recruits
                                          modValue:modValue
                                           xOffset:x
                                           yOffset:resourcesUI.lblRecruits.y
                                            parent:self];
            [_effects playSound:modValue<0 ? ResourcesDownSound : ResourcesUpSound loop:NO];
            break;
        }
        case Quarries:
        {
            [_effects applyFloatingTextOnStatField:resourcesUI.lblQuarries
                                             field:Quarries
                                          modValue:modValue
                                           xOffset:x
                                           yOffset:resourcesUI.lblQuarries.y
                                            parent:self];
            [_effects playSound:modValue<0 ? ResourceFacilityDownSound : ResourceFacilityUpSound loop:NO];
            break;
        }
        case Magics:
        {
            [_effects applyFloatingTextOnStatField:resourcesUI.lblMagics
                                             field:Magics
                                          modValue:modValue
                                           xOffset:x
                                           yOffset:resourcesUI.lblMagics.y
                                            parent:self];
            [_effects playSound:modValue<0 ? ResourceFacilityDownSound : ResourceFacilityUpSound loop:NO];
            break;
        }
        case Dungeons:
        {
            [_effects applyFloatingTextOnStatField:resourcesUI.lblDungeons
                                             field:Dungeons
                                          modValue:modValue
                                           xOffset:x
                                           yOffset:resourcesUI.lblDungeons.y
                                            parent:self];
            [_effects playSound:modValue<0 ? ResourceFacilityDownSound : ResourceFacilityUpSound loop:NO];
            break;
        }
        default:
        {
            break;
        }
    }
}

-(void) animateDrawCard:(OCard*)card
{
    if (_currentPlayer.ai)
    {
        return;
    }

    float width = Sparrow.stage.width;
    float height = Sparrow.stage.height;
    
    float cardWidth  = width/6;
    float cardHeight = (cardWidth*128)/95;
    float cardY = height-cardHeight;
    
    float deckX = width*1.5/5;
    float deckY = 45;
    
    deckAndGraveyard.lblDeck.text = [NSString stringWithFormat:@"Deck %d", _currentPlayer.deck.cardsInLibrary.count];
    
    NSArray *sortedKeys = [[hand allKeys] sortedArrayUsingSelector: @selector(compare:)];
    OCardUI *cardUI = nil;
    for (NSString *key in sortedKeys)
    {
        if ([hand objectForKey:key] == [NSNull null])
        {
            cardUI = [self createCardUI:card];
            int index = [key integerValue];
            
            cardUI.x = deckX;
            cardUI.y = deckY;
            [cardUI showBack:NO];
            cardUI.cardStatus = InDeck;
            [self addChild:cardUI];
            [hand setObject:cardUI forKey:key];
            
            NSMutableDictionary *props = [[NSMutableDictionary alloc] init];
            [props setObject:[NSNumber numberWithFloat:index*cardWidth] forKey:@"x"];
            [props setObject:[NSNumber numberWithFloat:cardY] forKey:@"y"];
            [props setObject:[NSNumber numberWithFloat:cardWidth] forKey:@"width"];
            [props setObject:[NSNumber numberWithFloat:cardHeight] forKey:@"height"];
            
            [_effects animate:cardUI withPropeties:props time:1.0 callback:^
            {
                 cardUI.cardStatus = InHand;
                [cardUI showFace:![_currentPlayer canPlayCard:card]];
            }];
            if (_turns > 0)
            {
                [_effects playSound:DrawSound loop:NO];
            }

            break;
        }
    }
}

-(void) animateShowHand
{
    if (_currentPlayer.ai)
    {
        return;
    }

    float width = Sparrow.stage.width;
    float height = Sparrow.stage.height;
    
    float cardWidth  = width/6;
    float cardHeight = (cardWidth*128)/95;
    float cardY = height-cardHeight;
    OCardUI *cardUI = nil;
    
    for (NSString *key in [hand allKeys])
    {
        int index = [key integerValue];
        
        if ([hand objectForKey:key] != [NSNull null])
        {
            cardUI = [hand objectForKey:key];
            
            [cardUI showFace:![_currentPlayer canPlayCard:cardUI.card]];
            NSMutableDictionary *props = [[NSMutableDictionary alloc] init];
            [props setObject:[NSNumber numberWithFloat:index*cardWidth] forKey:@"x"];
            [props setObject:[NSNumber numberWithFloat:cardY] forKey:@"y"];
            [props setObject:[NSNumber numberWithFloat:cardWidth] forKey:@"width"];
            [props setObject:[NSNumber numberWithFloat:cardHeight] forKey:@"height"];
            
            [_effects animate:cardUI withPropeties:props time:0.2 callback:^
            {
                cardUI.selected = NO;
                cardUI.cardStatus = InHand;
                [self removeCardBottom];
            }];
        }
        else
        {
//            OCard *card = [_currentPlayer.hand objectAtIndex:index];
//            cardUI = [self createCardUI:card];
//            
//            cardUI.x = index*cardWidth;
//            cardUI.y = cardY;
//            [cardUI showFace:![_currentPlayer canPlayCard:card]];
//            cardUI.selected = NO;
//            cardUI.cardStatus = InHand;
//            [self addChild:cardUI];
//            [hand setObject:cardUI forKey:key];
        }
    }
}

-(void) animatePutCardToGraveyard:(OCard*)card discarded:(BOOL)discarded
{
    float width = Sparrow.stage.width;
    float cardWidth  = width/6;
    float cardHeight = (cardWidth*128)/95;
    
    float currentX = width*1.5/5 + ((width*2/5)/2);
    float currentY = 45;
    
    if (_currentPlayer.ai)
    {
        OCardUI *cardUI = [self createCardUI:card];
        
        cardUI.x = Sparrow.stage.width - (RESOURCES_WIDTH_PIXELS*3/5) - cardWidth;
        cardUI.y = currentY;
        [cardUI showFace:NO];
        if (discarded)
        {
            [cardUI showDiscarded];
            [_effects playSound:DiscardSound loop:NO];
        }
        [self addChild:cardUI];
        
        NSMutableDictionary *props = [[NSMutableDictionary alloc] init];
        [props setObject:[NSNumber numberWithFloat:currentX] forKey:@"x"];
        [props setObject:[NSNumber numberWithFloat:currentY] forKey:@"y"];
        [props setObject:[NSNumber numberWithFloat:cardWidth] forKey:@"width"];
        [props setObject:[NSNumber numberWithFloat:cardHeight] forKey:@"height"];
        
        [_effects animate:cardUI withPropeties:props time:2.0 callback:^
        {
            cardUI.cardStatus = InGraveyard;
            [self removeChild:cardUI];
            [deckAndGraveyard addCardToGraveyard:cardUI];
             
        }];
    }
    else
    {
        for (NSString *key in [hand allKeys])
        {
            if ([hand objectForKey:key] != [NSNull null])
            {
                OCardUI *cardUI = [hand objectForKey:key];
        
                if (cardUI.card == card)
                {
                    [self removeCardBottom];
                    [cardUI showFace:NO];
                    if (discarded)
                    {
                        [cardUI showDiscarded];
                        [_effects playSound:DiscardSound loop:NO];
                    }
                    [hand setObject:[NSNull null] forKey:key];
                
                    NSMutableDictionary *props = [[NSMutableDictionary alloc] init];
                    [props setObject:[NSNumber numberWithFloat:currentX] forKey:@"x"];
                    [props setObject:[NSNumber numberWithFloat:currentY] forKey:@"y"];
                    [props setObject:[NSNumber numberWithFloat:cardWidth] forKey:@"width"];
                    [props setObject:[NSNumber numberWithFloat:cardHeight] forKey:@"height"];
                
                    [_effects animate:cardUI withPropeties:props time:2.0 callback:^
                    {
                        cardUI.cardStatus = InGraveyard;
                        [deckAndGraveyard addCardToGraveyard:cardUI];
                    }];
                
                    break;
                }
            }
        }
    }
}

-(OCardUI*) createCardUI:(OCard*)card
{
    float cardWidth  = Sparrow.stage.width/6;
    float cardHeight = (cardWidth*128)/95;
    CGRect cardRect  = CGRectMake(0, 0, cardWidth, cardHeight);
    OCardUI *cardUI  = [[OCardUI alloc] initWithWidth:cardRect.size.width
                                               height:cardRect.size.height
                                               faceUp:_currentPlayer.ai];
    
    cardUI.delegate = self;
    cardUI.card = card;
    return cardUI;
}

-(void) removeCardBottom
{
    [self removeChild:_btnDiscard];
    [self removeChild:_btnPlay];
    
    _btnDiscard = nil;
    _btnPlay = nil;
}

@end
