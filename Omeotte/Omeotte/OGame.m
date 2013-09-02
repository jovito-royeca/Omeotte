//
//  Game.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OGame.h"
#import "OBattle.h"

@implementation OGame

- (id)init
{
    if ((self = [super init]))
    {
        OMenu *menuScene = [[OMenu alloc] init];
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
