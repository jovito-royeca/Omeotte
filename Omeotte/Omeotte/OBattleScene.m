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
    OCardUI *_lastPlayedCard;
    GamePhase _gamePhase;
    NSTimer *_timer;
    int elapsedTurnTime;
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
@synthesize players;
@synthesize hand;
@synthesize graveyard;
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
    
    //    [SPMedia releaseSound];
}

- (void)setup
{
    [SPTextField registerBitmapFontFromFile:EXETER_FILE];
    
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
    background.height = _height - cardHeight -40;
    [self addChild:background];
    
    // Base
//    SPQuad *base = [[SPQuad alloc] initWithWidth:_width height:20];
//    base.x = 0;
//    base.y = _height-cardHeight-40;
//    base.color = GREEN_COLOR;
//    [self addChild:base];
    
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
    txtPlayer1Status.color = 0xffffff;
    txtPlayer1Status.hAlign = SPHAlignLeft;
    txtPlayer1Status.x = txtPlayer1Name.width;
    txtPlayer1Status.y = currentY;
    txtPlayer1Status.fontName = EXETER_FONT;
    [self addChild:txtPlayer1Status];
    
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
    currentX = _width*2/5;
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
    btnMenu.fontName = EXETER_FONT;
    [btnMenu addEventListener:@selector(showMenu) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [container addChild:btnMenu];
    currentY = 1;
    currentHeight = 20;
    txtTimer = [[SPTextField alloc] initWithWidth:currentWidth
                                           height:currentHeight
                                             text:[NSString stringWithFormat:@"%d", GAME_TURN]];
    txtTimer.color = 0xffffff;
    txtTimer.x = currentX;
    txtTimer.y = btnMenu.height+10;
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
    txtPlayer2Status.color = 0xffffff;
    txtPlayer2Status.hAlign = SPHAlignRight;
    txtPlayer2Status.x = currentX;
    txtPlayer2Status.y = currentY;
    txtPlayer2Status.fontName = EXETER_FONT;
    [self addChild:txtPlayer2Status];
    currentX = (_width*3/5)+txtPlayer2Status.width;
    currentY = 0;
    currentWidth = (_width*2/5)*0.30;
    txtPlayer2Name = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    txtPlayer2Name.color = BLUE_COLOR;
    txtPlayer2Name.hAlign = SPHAlignLeft;
    txtPlayer2Name.x = currentX;
    txtPlayer2Name.y = currentY;
    txtPlayer2Name.hAlign = SPHAlignRight;
    txtPlayer2Name.fontName = EXETER_FONT;
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
    currentX = _width*3/5;
    currentWidth  = (_width*2/5)-currentWidth;
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

    [player1 draw:[rule cardsInHand]];
    [player1.base setStats:rule.base];
    player1.name = @"Player 1";
    // to compensate during first Upkeep...
    player1.base.bricks -= rule.base.bricks;
    player1.base.gems -= rule.base.gems;
    player1.base.recruits -= rule.base.recruits;
    player1.delegate = self;

    [player2 draw:[rule cardsInHand]];
    [player2.base setStats:rule.base];
    player2.name = @"A.I.";
    // to compensate during first Upkeep...
    player2.base.bricks -= rule.base.bricks;
    player2.base.gems -= rule.base.gems;
    player2.base.recruits -= rule.base.recruits;
    player2.delegate = self;

    _currentPlayer = player1;
    player2.ai = YES;
    players = [[NSArray alloc] initWithObjects:player1, player2, nil];
    
    txtPlayer1Name.text = player1.name;
    txtPlayer2Name.text = player2.name;
    
    hand = [[NSMutableArray alloc] init];
    graveyard = [[NSMutableArray alloc] init];
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
    // remove previous hand
    for (OCardUI *cardUI in hand)
    {
        [self removeChild:cardUI];
    }
    [hand removeAllObjects];
    
    // show current hand
    float currentX = 0;
    float currentWidth = Sparrow.stage.width/6;
    for (OCard *card in _currentPlayer.hand)
    {
        OCardUI *cardUI = [self createCardUI:card];
        
        cardUI.x = currentX;
        cardUI.y = Sparrow.stage.height-cardUI.height;
        if (_currentPlayer.ai)
        {
            [cardUI showBack:_currentPlayer.ai];
        }
        else
        {
            [cardUI showFace:![_currentPlayer canPlayCard:card]];
        }
        [self addChild:cardUI];
        [hand addObject:cardUI];

        currentX += currentWidth;
    }
}

-(void) playCard:(OCard*) card
{
    if ([_currentPlayer canPlayCard:card])
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
    txtTimer.color = elapsedTurnTime <= 5 ? RED_COLOR : 0xffffff;
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
    int cardsToDraw = MAX_CARDS_IN_HAND - [_currentPlayer.hand count];
    
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
            if ([winners containsObject:players[0]])
            {
                message = @"Victory";
            }
            else if ([winners containsObject:players[1]])
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

#pragma mark - OCardUIDelegate
- (void)promote:(OCardUI*)cardUI
{
    NSLog(@"promote... %@", cardUI.card.name);
    
    for (OCardUI *cardUI in hand)
    {
        [self demote:cardUI];
    }
    
    SPTween *tween = [SPTween tweenWithTarget:cardUI time:0.5];
	[tween animateProperty:@"y" targetValue:cardUI.y-20];
	[Sparrow.juggler addObject:tween];
}

- (void)play:(OCardUI*)cardUI
{
    NSLog(@"play... %@", cardUI.card.name);
    _currentCard = cardUI.card;
}

- (void)discard:(OCardUI*)cardUI
{
    NSLog(@"discard... %@", cardUI.card.name);
    [self discardCard:cardUI.card];
    [self switchTurn:[self opponentPlayer]];
}

- (void)demote:(OCardUI*)cardUI
{
    float cardWidth  = Sparrow.stage.width/6;
    float cardHeight = (cardWidth*128)/95;
    float y = Sparrow.stage.height-cardHeight;
    
    if (cardUI.y < y)
    {
        NSLog(@"demote... %@", cardUI.card.name);
        cardUI.touchStatus = 0;
        
        SPTween *tween = [SPTween tweenWithTarget:cardUI time:0.5];
    
        [tween animateProperty:@"y" targetValue:y];
    
        [Sparrow.juggler addObject:tween];
    }
}

#pragma mark - OPlayerDelegate
-(void) statChanged:(StatField)field
         fieldValue:(int)fieldValue
           modValue:(int)modValue
             player:(OPlayer*)player
{
    OResourcesUI *resourcesUI;
    OHealthUI *healthUI;
    float x = 0;
    
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
                (Sparrow.stage.width*3/5) + healthUI.lblTower.x :
                resourcesUI.width;
            break;
        }
        case Wall:
        {
            x = (player == players[1]) ?
                (Sparrow.stage.width*3/5) + healthUI.lblWall.x :
                resourcesUI.width + healthUI.lblWall.x;
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
            [OEffects applyEffectsOnStatField:healthUI.lblTower
                                     modValue:modValue
                                      message:@"Tower"
                                            xOffset:x
                                    parent:self];
            break;
        }
        case Wall:
        {
            [OEffects applyEffectsOnStatField:healthUI.lblWall
                                     modValue:modValue
                                      message:@"Wall"
                                            xOffset:x
                                       parent:self];
            break;
        }
        case Bricks:
        {
            [OEffects applyEffectsOnStatField:resourcesUI.lblBricks
                                     modValue:modValue
                                      message:@"bricks"
                                            xOffset:x
                                       parent:self];
            break;
        }
        case Gems:
        {
            [OEffects applyEffectsOnStatField:resourcesUI.lblGems
                                     modValue:modValue
                                      message:@"gems"
                                            xOffset:x
                                       parent:self];
            break;
        }
        case Recruits:
        {
            [OEffects applyEffectsOnStatField:resourcesUI.lblRecruits
                                     modValue:modValue
                                      message:@"recruits"
                                            xOffset:x
                                       parent:self];
            break;
        }
        case Quarries:
        {
            [OEffects applyEffectsOnStatField:resourcesUI.lblQuarries
                                     modValue:modValue
                                      message:@"Quarries"
                                            xOffset:x
                                       parent:self];
            break;
        }
        case Magics:
        {
            [OEffects applyEffectsOnStatField:resourcesUI.lblMagics
                                     modValue:modValue
                                      message:@"Magics"
                                            xOffset:x
                                       parent:self];
            break;
        }
        case Dungeons:
        {
            [OEffects applyEffectsOnStatField:resourcesUI.lblDungeons
                                     modValue:modValue
                                      message:@"Dungeons"
                                            xOffset:x
                                       parent:self];
            break;
        }
        default:
        {
            break;
        }
    }
}

-(void) putCardToGraveyard:(OCard*)card
{
    for (OCardUI *cardUI in hand)
    {
        if (cardUI.card == card)
        {
            [hand removeObject:cardUI];
            [cardUI showFace:NO];
            
            SPTween *tween = [SPTween tweenWithTarget:cardUI time:2.0];
            int centerX = (txtTimer.width-cardUI.width)/2;
            
            [tween animateProperty:@"x" targetValue:txtTimer.x+centerX];
            [tween animateProperty:@"y" targetValue:txtTimer.y+txtTimer.height];
            [Sparrow.juggler addObject:tween];
            
            [graveyard addObject:cardUI];
            
            break;
        }
    }
    
    // remove old cards in the graveyard to minimize memory usage
    if (graveyard.count >= 4)
    {
        OCardUI *cardUI = [graveyard objectAtIndex:0];
        
        [self removeChild:cardUI];
        [graveyard removeObject:cardUI];
    }
}

@end
