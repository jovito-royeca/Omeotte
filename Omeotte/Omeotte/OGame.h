//
//  Game.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"

#import "OBackgroundMusicScene.h"
#import "OBattleScene.h"
#import "OMenuScene.h"

@interface OGame : SPSprite

- (void)showScene:(SPSprite<OBackgroundMusicScene> *)scene;

@end


