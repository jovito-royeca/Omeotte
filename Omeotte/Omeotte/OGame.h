//
//  Game.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPSprite.h"

#import "OCard.h"
#import "OPlayer.h"
#import "ORule.h"
#import "SPMedia.h"


@interface OGame : SPSprite

@property (strong, nonatomic) NSArray *players;
@property (strong, nonatomic) ORule* rule;
@property (strong, nonatomic) NSMutableArray *hand;

//-(id) initWithRule:(ORule*)rule;

@end
