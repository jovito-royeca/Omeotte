//
//  Game.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OGame.h"
#import "OBattleScene.h"

@implementation OGame
{
    SPSprite<OBackgroundMusicScene> *_currentScene;
    float _screenWidth;
    float _screenHeight;
    float _offsetY;
}

- (id)init
{
    if ((self = [super init]))
    {
        _screenWidth = Sparrow.stage.width;
        _screenHeight = Sparrow.stage.height;
        _offsetY = (Sparrow.stage.height - 480) / 2;
        
        [SPTextField registerBitmapFontFromFile:CALLIGRAPHICA_FILE];
        [SPTextField registerBitmapFontFromFile:EXETER_FILE];

        OMenuScene *menuScene = [[OMenuScene alloc] init];
        [self showScene:menuScene];
    }
    return self;
}

- (void)dealloc
{
    [OMedia releaseAllAtlas];
    [_currentScene release];
    [super dealloc];
}

- (void)showScene:(SPSprite<OBackgroundMusicScene> *)scene
{
    if ([self containsChild:_currentScene])
    {
        [_currentScene stopMusic];
        [self removeChild:_currentScene];
        _currentScene = nil;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self addChild:scene];
    _currentScene = scene;
    [_currentScene loopMusic];
}

@end
