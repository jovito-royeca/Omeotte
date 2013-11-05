//
//  OMenu.m
//  Omeotte
//
//  Created by Jovito Royeca on 9/2/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OMenuScene.h"

@implementation OMenuScene

- (id)init
{
    if ((self = [super init]))
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [OMedia initAtlas:@"ui.xml"];
    
    float _width = Sparrow.stage.width;
    float _height = Sparrow.stage.height;
    
    float currentX = 0;
    float currentY = 0;
    float currentWidth = _width;
    float currentHeight = 50;
    SPTextField *title = [SPTextField textFieldWithWidth:_width
                                                  height:currentHeight
                                                    text:GAME_TITLE
                                                fontName:CALLIGRAPHICA_FONT
                                                fontSize:50
                                                   color:RED_COLOR];

    [self addChild:title];
    
    
    // the towers...
    currentX = 0;
    currentY = currentHeight;
    currentWidth = (_width/4)*0.542;
    currentHeight = _height-currentHeight;
    SPImage *redTower = [[SPImage alloc] initWithWidth:currentWidth height:currentHeight];
    redTower.texture = [OMedia texture:@"red tower" fromAtlas:@"ui.xml"];
    redTower.x = currentX;
    redTower.y = currentY;
    [self addChild:redTower];
    
    currentX = (_width*3/4)+((_width/4)-currentWidth);
    SPImage *blueTower = [[SPImage alloc] initWithWidth:currentWidth height:currentHeight];
    blueTower.texture = [OMedia texture:@"blue tower" fromAtlas:@"ui.xml"];
    blueTower.x = currentX;
    blueTower.y = currentY;
    [self addChild:blueTower];
    //
    
    currentX = _width/4;
    currentY = 70;
    currentWidth = _width/2;
    currentHeight = 50;
    OButtonTextureUI *texture = [[OButtonTextureUI alloc] initWithWidth:currentWidth
                                                                 height:currentHeight
                                                           cornerRadius:10
                                                            strokeWidth:2
                                                            strokeColor:WHITE_COLOR
                                                                  gloss:NO
                                                             startColor:RED_COLOR
                                                               endColor:BLUE_COLOR];

    
    SPButton *btnCampaign = [SPButton buttonWithUpState:texture text:@"Campaign"];
    btnCampaign.fontColor = WHITE_COLOR;
    btnCampaign.fontSize = 30;
    btnCampaign.x = currentX;
    btnCampaign.y = currentY;
    btnCampaign.fontName = EXETER_FONT;
    [btnCampaign addEventListenerForType:SP_EVENT_TYPE_TRIGGERED block:^(id event)
     {
         OBattleScene *scene = [[OBattleScene alloc] init];
         OGameScene* game = (OGameScene*)self.root;
         
         [game showScene:scene];
     }];
    [self addChild:btnCampaign];

    currentY += currentHeight+10;
    SPButton *btnMultiPlayer = [SPButton buttonWithUpState:texture text:@"Multi Player"];
    btnMultiPlayer.fontColor = WHITE_COLOR;
    btnMultiPlayer.fontSize = 30;
    btnMultiPlayer.x = currentX;
    btnMultiPlayer.y = currentY;
    btnMultiPlayer.fontName = EXETER_FONT;
    [btnMultiPlayer addEventListenerForType:SP_EVENT_TYPE_TRIGGERED block:^(id event)
     {
         UIAlertView *alertMessage =  [[UIAlertView alloc] initWithTitle:@"Message"
                                                                 message:@"Multi Player not yet implemented."
                                                                delegate:nil
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"OK", nil];
         [alertMessage show];
     }];
    [self addChild:btnMultiPlayer];
    
    currentY += currentHeight+10;
    SPButton *btnCardBrowser = [SPButton buttonWithUpState:texture text:@"Card Browser"];
    btnCardBrowser.fontColor = WHITE_COLOR;
    btnCardBrowser.fontSize = 30;
    btnCardBrowser.x = currentX;
    btnCardBrowser.y = currentY;
    btnCardBrowser.fontName = EXETER_FONT;
    [btnCardBrowser addEventListenerForType:SP_EVENT_TYPE_TRIGGERED block:^(id event)
     {
         CardTestScene *scene = [[CardTestScene alloc] init];
         OGameScene* game = (OGameScene*)self.root;
         
         [game showScene:scene];
     }];
    [self addChild:btnCardBrowser];
    
    currentY += currentHeight+10;
    SPButton *btnSettings = [SPButton buttonWithUpState:texture text:@"Settings"];
    btnSettings.fontColor = WHITE_COLOR;
    btnSettings.fontSize = 30;
    btnSettings.x = currentX;
    btnSettings.y = currentY;
    btnSettings.fontName = EXETER_FONT;
    [btnSettings addEventListenerForType:SP_EVENT_TYPE_TRIGGERED block:^(id event)
     {
         UIAlertView *alertMessage =  [[UIAlertView alloc] initWithTitle:@"Message"
                                                                 message:@"Settings not yet implemented."
                                                                delegate:nil
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"OK", nil];
         [alertMessage show];
     }];
    [self addChild:btnSettings];

#ifdef GAME_SOUNDS_ON
    SPSoundChannel *channel = [OMedia sound:@"maintheme.caf"];
    channel.loop = YES;
    [channel play];
#endif
}


@end
