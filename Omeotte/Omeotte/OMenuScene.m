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
    int stageWidth = Sparrow.stage.width;
//    int stageHeight = Sparrow.stage.height;
    int currentX = 0;
    int currentY = 0;

    OButtonTextureUI *texture = [[OButtonTextureUI alloc] initWithWidth:200
                                                                 height:50
                                                           cornerRadius:10
                                                            strokeWidth:2
                                                            strokeColor:0xffffff
                                                                  gloss:NO
                                                             startColor:0x0000ff
                                                               endColor:0x0000ff];

    [SPTextField registerBitmapFontFromFile:CALLIGRAPHICA_FILE];
    [SPTextField registerBitmapFontFromFile:EXETER_FILE];
    
    SPTextField *title = [SPTextField textFieldWithWidth:stageWidth
                                                  height:50
                                                    text:GAME_TITLE
                                                fontName:CALLIGRAPHICA_FONT
                                                fontSize:50
                                                   color:0xff0000];

    [self addChild:title];
    
    
    SPButton *btnCampaign = [SPButton buttonWithUpState:texture text:@"Campaign"];
    currentX = (self.width-btnCampaign.width)/2;
    currentY = title.y+title.height+20;
    btnCampaign.fontColor = 0xffffff;
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
    
    SPButton *btnMultiPlayer = [SPButton buttonWithUpState:texture text:@"Multi Player"];
    currentX = (self.width-btnMultiPlayer.width)/2;
    currentY = btnCampaign.y+btnMultiPlayer.height+10;
    btnMultiPlayer.fontColor = 0xffffff;
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
    
    SPButton *btnCardBrowser = [SPButton buttonWithUpState:texture text:@"Card Browser"];
    currentX = (self.width-btnCardBrowser.width)/2;
    currentY = btnMultiPlayer.y+btnCardBrowser.height+10;
    btnCardBrowser.fontColor = 0xffffff;
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
    
    SPButton *btnSettings = [SPButton buttonWithUpState:texture text:@"Settings"];
    currentX = (self.width-btnSettings.width)/2;
    currentY = btnCardBrowser.y+btnSettings.height+10;
    btnSettings.fontColor = 0xffffff;
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
}


@end
