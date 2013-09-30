//
// Created by Jovito Royeca on 9/9/13.
// Copyright (c) 2013 JJJ Software. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "OResourcesUI.h"


@implementation OResourcesUI
{
    float _width;
    float _height;
    ORule *_rule;
}

@synthesize lblQuarries;
@synthesize lblBricks;
@synthesize lblMagics;
@synthesize lblGems;
@synthesize lblDungeons;
@synthesize lblRecruits;

- (void)dealloc
{
    [super dealloc];
    
    [lblQuarries release];
    [lblBricks release];
    [lblMagics release];
    [lblGems release];
    [lblDungeons release];
    [lblRecruits release];
}

-(id) initWithWidth:(float)width height:(float)height rule:(ORule*)rule
{
    if ((self = [super init]))
    {
        _width = width;
        _height = height;
        _rule = rule;

        [self setup];
    }
    return self;
}

-(void) setup
{
    [OMedia initAtlas:@"ui.xml"];
    
    float currentX = 0;
    float currentY = 0;
    float currentWidth = 0;
    float currentHeight = 0;
    
    SPImage *imgBackground = [[SPImage alloc] initWithWidth:_width height:_height];
    SPTexture *texture = [OMedia texture:@"resources" fromAtlas:@"ui.xml"];
    imgBackground.texture = texture;
    [self addChild:imgBackground];
    
    currentX = _width * 0.03;
    currentY = _height * 0.11;
    currentWidth = _width * 0.384;
    currentHeight = currentWidth;
    lblQuarries = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    lblQuarries.x = currentX;
    lblQuarries.y = currentY;
    lblQuarries.color = GOLD_COLOR;
    lblQuarries.fontSize = currentHeight;
    [self addChild:lblQuarries];
    
    currentY += _height/3;
    lblMagics = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    lblMagics.x = currentX;
    lblMagics.y = currentY;
    lblMagics.color = GOLD_COLOR;
    lblMagics.fontSize = currentHeight;
    [self addChild:lblMagics];

    currentY += _height/3;
    lblDungeons = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    lblDungeons.x = currentX;
    lblDungeons.y = currentY;
    lblDungeons.color = GOLD_COLOR;
    lblDungeons.fontSize = currentHeight;
    [self addChild:lblDungeons];

    
    currentY = _height * 0.259;
    currentWidth = _width * 0.6;
    currentHeight = _width * 0.192;
    lblBricks = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    lblBricks.x = currentX;
    lblBricks.y = currentY;
    lblBricks.color = 0x000000;
    lblBricks.fontSize = currentHeight;
    lblBricks.hAlign = SPHAlignLeft;
    [self addChild:lblBricks];
    
    currentY += _height/3;
    lblGems = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    lblGems.x = currentX;
    lblGems.y = currentY;
    lblGems.color = 0x000000;
    lblGems.fontSize = currentHeight;
    lblGems.hAlign = SPHAlignLeft;
    [self addChild:lblGems];

    currentY += _height/3;
    lblRecruits = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    lblRecruits.x = currentX;
    lblRecruits.y = currentY;
    lblRecruits.color = 0x000000;
    lblRecruits.fontSize = currentHeight;
    lblRecruits.hAlign = SPHAlignLeft;
    [self addChild:lblRecruits];
}

-(void) update:(OStats*)stats
{
    lblQuarries.text = [NSString stringWithFormat:@"%d", stats.quarries];
    lblBricks.text = [NSString stringWithFormat:@"%d/%d", stats.bricks, _rule.winningResource];
    
    lblMagics.text = [NSString stringWithFormat:@"%d", stats.magics];
    lblGems.text = [NSString stringWithFormat:@"%d/%d", stats.gems, _rule.winningResource];
    
    lblDungeons.text = [NSString stringWithFormat:@"%d", stats.dungeons];
    lblRecruits.text = [NSString stringWithFormat:@"%d/%d", stats.recruits, _rule.winningResource];
}

@end