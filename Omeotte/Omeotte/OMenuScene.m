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
    
    SPTextField *title = [SPTextField textFieldWithWidth:stageWidth height:50 text:GAME_TITLE fontName:@"Helvetica" fontSize:50 color:0xFFFFFF];
    [self addChild:title];
    
    OButtonTextureUI *texture = [[OButtonTextureUI alloc] initWithWidth:200 height:50 cornerRadius:10 strokeWidth:2 strokeColor:0xFFFFFF gloss:NO startColor:0x0000FF endColor:0x0000FF];
    SPButton *playButton = [SPButton buttonWithUpState:texture text:@"Play"];
    playButton.fontColor = 0xFFFFFF;
    playButton.fontSize = 30;
    playButton.x = (self.width-playButton.width)/2;
    playButton.y = title.y+title.height+20;
    [playButton addEventListener:@selector(playButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:playButton];
}

-(void) playButtonTriggered:(SPEvent *)event
{
    OBattleScene *battle = [[OBattleScene alloc] init];
    OGameScene* game = (OGameScene*)self.root;
    
    [game showScene:battle];
}

@end
