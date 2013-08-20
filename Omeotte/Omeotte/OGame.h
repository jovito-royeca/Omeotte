//
//  Game.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OCard.h"
#import "OPlayer.h"
#import "ORule.h"

@interface OGame : NSObject

-(id) initWithRule:(ORule*)rule;

@end
