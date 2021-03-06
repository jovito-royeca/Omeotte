//
// Created by Jovito Royeca on 9/9/13.
// Copyright (c) 2013 JJJ Software. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Sparrow.h"

#import "OMedia.h"
#import "Omeotte.h"
#import "OPlayer.h"
#import "ORule.h"
#import "OStats.h"

#define RESOURCES_WIDTH_PIXELS  78
#define RESOURCES_HEIGHT_PIXELS 216

@interface OResourcesUI : SPSprite

@property(strong,nonatomic) SPTextField *lblQuarries;
@property(strong,nonatomic) SPTextField *lblBricks;
@property(strong,nonatomic) SPQuad *qdBricks;

@property(strong,nonatomic) SPTextField *lblMagics;
@property(strong,nonatomic) SPTextField *lblGems;
@property(strong,nonatomic) SPQuad *qdGems;

@property(strong,nonatomic) SPTextField *lblDungeons;
@property(strong,nonatomic) SPTextField *lblRecruits;
@property(strong,nonatomic) SPQuad *qdRecruits;

-(id) initWithWidth:(float)width
             height:(float)height
               rule:(ORule*)rule;

-(void) update:(OStats*)stats;
-(void) animateResourceBar:(SPQuad*)bar width:(float)width;
-(void) advanceTime:(double)seconds;

@end