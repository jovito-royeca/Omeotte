//
//  OBattle.h
//  Omeotte
//
//  Created by Jovito Royeca on 9/2/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sparrow.h"

#import "OBackgroundMusicScene.h"
#import "OButtonTextureUI.h"
#import "OCard.h"
#import "OCardUI.h"
#import "ODeckAndGraveyardUI.h"
#import "OFx.h"
#import "OGame.h"
#import "OHealthUI.h"
#import "OMedia.h"
#import "OMenuScene.h"
#import "OPlayer.h"
#import "OResourcesUI.h"
#import "ORule.h"

typedef enum
{
    Upkeep = 0,
    Draw,
    Main,
    GameOver,
    Pause
//    Discard
} GamePhase;

@interface OBattleScene : SPSprite <OCardUIDelegate, OPlayerAnimationDelegate, OBackgroundMusicScene>

@property (strong, nonatomic) SPTextField *txtPlayer1Name;
@property (strong, nonatomic) SPTextField *txtPlayer1Status;
@property (strong, nonatomic) OResourcesUI *player1Resources;
@property (strong, nonatomic) OHealthUI *player1Health;

@property (strong, nonatomic) SPTextField *txtPlayer2Name;
@property (strong, nonatomic) SPTextField *txtPlayer2Status;
@property (strong, nonatomic) OResourcesUI *player2Resources;
@property (strong, nonatomic) OHealthUI *player2Health;

@property (strong, nonatomic) SPTextField *txtTimer;
@property (strong, nonatomic) ODeckAndGraveyardUI *deckAndGraveyard;
@property (strong, nonatomic) NSArray *players;
@property (strong, nonatomic) NSMutableDictionary *hand;
@property (strong, nonatomic) NSMutableArray *winners;
@property (strong, nonatomic) ORule* rule;

//-(id) initWithRule:(ORule*)rule;

-(void) initPlayers;

@end
