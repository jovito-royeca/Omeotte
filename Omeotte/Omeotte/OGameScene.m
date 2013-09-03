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

- (id)init
{
    if ((self = [super init]))
    {
        OMenuScene *menuScene = [[OMenuScene alloc] init];
        [self showScene:menuScene];
    }
    return self;
}

- (void)showScene:(SPSprite *)scene
{
    if ([self containsChild:_currentScene])
    {
        [self removeChild:_currentScene];
    }
    [self addChild:scene];
    _currentScene = scene;
}

@end
