//
//  Game.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"

#import "OBattle.h"
#import "OMenu.h"

@interface OGame : SPSprite
{
    SPSprite *_currentScene;
}

- (void)showScene:(SPSprite *)scene;

@end
