//
// Created by Jovito Royeca on 9/9/13.
// Copyright (c) 2013 JJJ Software. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Sparrow.h"

#import "OMedia.h"
#import "OPlayer.h"
#import "Omeotte.h"

@interface OResourcesUI : SPSprite

@property(strong,nonatomic) SPTextField *lblQuarries;
@property(strong,nonatomic) SPTextField *lblBricks;

@property(strong,nonatomic) SPTextField *lblMagic;
@property(strong,nonatomic) SPTextField *lblGems;

@property(strong,nonatomic) SPTextField *lblDungeons;
@property(strong,nonatomic) SPTextField *lblRecruits;

-(id) initWithWidth:(float)width height:(float)height;
-(void) update:(OStats)stats;

@end