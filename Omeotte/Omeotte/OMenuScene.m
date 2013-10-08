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
    int stageHeight = Sparrow.stage.height;
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
    
    
    SPButton *btnSinglePlayer = [SPButton buttonWithUpState:texture text:@"Single Player"];
    currentX = (self.width-btnSinglePlayer.width)/2;
    currentY = title.y+title.height+20;
    btnSinglePlayer.fontColor = 0xffffff;
    btnSinglePlayer.fontSize = 30;
    btnSinglePlayer.x = currentX;
    btnSinglePlayer.y = currentY;
    btnSinglePlayer.fontName = EXETER_FONT;
    [btnSinglePlayer addEventListenerForType:SP_EVENT_TYPE_TRIGGERED block:^(id event)
     {
         OBattleScene *scene = [[OBattleScene alloc] init];
         OGameScene* game = (OGameScene*)self.root;
         
         [game showScene:scene];
     }];
    [self addChild:btnSinglePlayer];
    
    SPButton *btnMultiPlayer = [SPButton buttonWithUpState:texture text:@"Multi Player"];
    currentX = (self.width-btnMultiPlayer.width)/2;
    currentY = btnSinglePlayer.y+btnMultiPlayer.height+10;
    btnMultiPlayer.fontColor = 0xffffff;
    btnMultiPlayer.fontSize = 30;
    btnMultiPlayer.x = currentX;
    btnMultiPlayer.y = currentY;
    btnMultiPlayer.fontName = EXETER_FONT;
    [btnMultiPlayer addEventListenerForType:SP_EVENT_TYPE_TRIGGERED block:^(id event)
     {
         NSLog(@"Multi Player not yet implemented.");
     }];
    [self addChild:btnMultiPlayer];
    
    SPButton *btnDeckBuilder = [SPButton buttonWithUpState:texture text:@"Deck Builder"];
    currentX = (self.width-btnDeckBuilder.width)/2;
    currentY = btnMultiPlayer.y+btnDeckBuilder.height+10;
    btnDeckBuilder.fontColor = 0xffffff;
    btnDeckBuilder.fontSize = 30;
    btnDeckBuilder.x = currentX;
    btnDeckBuilder.y = currentY;
    btnDeckBuilder.fontName = EXETER_FONT;
    [btnDeckBuilder addEventListenerForType:SP_EVENT_TYPE_TRIGGERED block:^(id event)
     {
         NSLog(@"Deck Builder not yet implemented.");
     }];
    [self addChild:btnDeckBuilder];
    
    SPButton *btnCardBrowser = [SPButton buttonWithUpState:texture text:@"Card Browser"];
    currentX = (self.width-btnCardBrowser.width)/2;
    currentY = btnDeckBuilder.y+btnCardBrowser.height+10;
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
}


@end
