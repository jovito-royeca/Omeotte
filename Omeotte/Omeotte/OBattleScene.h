//
//  OBattle.h
//  Omeotte
//
//  Created by Jovito Royeca on 9/2/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "Sparrow.h"

#import "OButtonTextureUI.h"
#import "OCardUI.h"
#import "OMedia.h"
#import "OMeotte.h"
#import "OMenuScene.h"
#import "OResourcesUI.h"

#define        GAME_TURN      30 // seconds

typedef enum
{
    Upkeep = 0,
    Draw,
    Main,
    Victory
//    Discard
} GamePhase;

@interface OBattleScene : SPSprite <OCardUIDelegate>
{
    OPlayer *_currentPlayer;
    OCard *_currentCard;
    GamePhase _gamePhase;
    NSTimer *_timer;
    int elapsedTurnTime;
}

@property (strong, nonatomic) SPTextField *txtPlayer1Name;
@property (strong, nonatomic) OResourcesUI *player1Resources;
@property (strong, nonatomic) SPTextField *txtPlayer1Tower;
@property (strong, nonatomic) SPTextField *txtPlayer1Wall;

@property (strong, nonatomic) SPTextField *txtPlayer2Name;
@property (strong, nonatomic) OResourcesUI *player2Resources;
@property (strong, nonatomic) SPTextField *txtPlayer2Tower;
@property (strong, nonatomic) SPTextField *txtPlayer2Wall;

@property (strong, nonatomic) SPTextField *txtTimer;
@property (strong, nonatomic) NSArray *players;
@property (strong, nonatomic) NSMutableArray *winners;
@property (nonatomic) ORule rule;
@property (strong, nonatomic) NSMutableArray *hand;

//-(id) initWithRule:(ORule*)rule;

-(void) initPlayers;
-(void) showHand;

@end
