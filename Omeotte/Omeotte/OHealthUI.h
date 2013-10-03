//
//  OHealthUI.h
//  Omeotte
//
//  Created by Jovito Royeca on 10/1/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sparrow.h"
#import "SXSimpleClippedImage.h"

#import "OMedia.h"
#import "Omeotte.h"
#import "ORule.h"
#import "OStats.h"

#define TOWER_WIDTH_PIXELS   68
#define TOWER_HEIGHT_PIXELS  290
#define TOWER_ROOF_PIXELS    94

#define WALL_WIDTH_PIXELS    45
#define WALL_HEIGHT_PIXELS   238
#define WALL_ROOF_PIXELS     38

@interface OHealthUI : SPSprite

@property(strong,nonatomic) SXSimpleClippedImage *imgTower;
@property(strong,nonatomic) SPTextField *lblTower;
@property(strong,nonatomic) SXSimpleClippedImage *imgWall;
@property(strong,nonatomic) SPTextField *lblWall;

-(id) initWithWidth:(float)width height:(float)height rule:(ORule*)rule ai:(BOOL)isAI;
-(void) update:(OStats*)stats;
-(void) animateImage:(SXSimpleClippedImage*)image;

@end
