//
//  OBattle.h
//  Omeotte
//
//  Created by Jovito Royeca on 9/2/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "Sparrow.h"

#import "OButtonTextureUI.h"
#import "OCard.h"
#import "OCardUI.h"
#import "OEffects.h"
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
    Victory
//    Discard
} GamePhase;

@interface OBattleScene : SPSprite <OCardUIDelegate, OPlayerDelegate>

@property (strong, nonatomic) SPTextField *txtPlayer1Name;
@property (strong, nonatomic) SPTextField *txtPlayer1Status;
@property (strong, nonatomic) OResourcesUI *player1Resources;
@property (strong, nonatomic) OHealthUI *player1Health;

@property (strong, nonatomic) SPTextField *txtPlayer2Name;
@property (strong, nonatomic) SPTextField *txtPlayer2Status;
@property (strong, nonatomic) OResourcesUI *player2Resources;
@property (strong, nonatomic) OHealthUI *player2Health;

@property (strong, nonatomic) SPTextField *txtTimer;
@property (strong, nonatomic) NSArray *players;
@property (strong, nonatomic) NSMutableArray *hand;
@property (strong, nonatomic) NSMutableArray *graveyard;
@property (strong, nonatomic) NSMutableArray *winners;
@property (strong, nonatomic) ORule* rule;

//-(id) initWithRule:(ORule*)rule;

-(void) initPlayers;
-(void) showHand;
-(void) putCardToGraveyard:(OCard*)card;

@end
