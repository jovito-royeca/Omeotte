//
//  Game.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OGameScene.h"
#import "OBattleScene.h"

@implementation OGameScene
{
    float _offsetY;
}

- (id)init
{
    if ((self = [super init]))
    {
        _screenWidth = Sparrow.stage.width;
        _screenHeight = Sparrow.stage.height;
        _offsetY = (Sparrow.stage.height - 480) / 2;
        
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

- (void)showScene:(SPSprite *)scene
{
    if ([self containsChild:_currentScene])
    {
        [self removeChild:_currentScene];
        [OMedia releaseAllSounds];
        [_currentScene release];
        _currentScene = nil;
    }
    
    [self addChild:scene];
    _currentScene = scene;
}

@end
