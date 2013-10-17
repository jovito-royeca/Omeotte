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
@synthesize qdBricks;
@synthesize lblMagics;
@synthesize lblGems;
@synthesize qdGems;
@synthesize lblDungeons;
@synthesize lblRecruits;
@synthesize qdRecruits;

- (void)dealloc
{
    [super dealloc];
    
    [lblQuarries release];
    [lblBricks release];
    [qdBricks release];
    [lblMagics release];
    [lblGems release];
    [qdGems release];
    [lblDungeons release];
    [lblRecruits release];
    [qdRecruits release];
}

-(id) initWithWidth:(float)width
             height:(float)height
               rule:(ORule*)rule
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
    NSString *atlas = @"ui.xml";
    [OMedia initAtlas:atlas];
    [SPTextField registerBitmapFontFromFile:EXETER_FILE];
    
    float currentX = 0;
    float currentY = 0;
    float currentWidth = 0;
    float currentHeight = 0;
    
    SPImage *imgBackground = [[SPImage alloc] initWithWidth:_width height:_height];
    SPTexture *texture = [OMedia texture:@"resources" fromAtlas:atlas];
    imgBackground.texture = texture;
    [self addChild:imgBackground];
    
    currentX = _width * 0.03;
    currentY = _height * 0.11;
    currentWidth = _width;
    currentHeight = _width * 0.384;
    lblQuarries = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    lblQuarries.x = currentX;
    lblQuarries.y = currentY;
    lblQuarries.color = GOLD_COLOR;
    lblQuarries.fontSize = currentHeight;
    lblQuarries.fontName = EXETER_FONT;
    lblQuarries.hAlign = SPHAlignLeft;
    [self addChild:lblQuarries];
    
    currentY += _height/3;
    lblMagics = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    lblMagics.x = currentX;
    lblMagics.y = currentY;
    lblMagics.color = GOLD_COLOR;
    lblMagics.fontSize = currentHeight;
    lblMagics.fontName = EXETER_FONT;
    lblMagics.hAlign = SPHAlignLeft;
    [self addChild:lblMagics];

    currentY += _height/3;
    lblDungeons = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    lblDungeons.x = currentX;
    lblDungeons.y = currentY;
    lblDungeons.color = GOLD_COLOR;
    lblDungeons.fontSize = currentHeight;
    lblDungeons.fontName = EXETER_FONT;
    lblDungeons.hAlign = SPHAlignLeft;
    [self addChild:lblDungeons];
    
    currentY = _height * 0.259;
    currentWidth = _width - (_width*0.06);
    currentHeight = _width * 0.192;
    qdBricks = [[SPQuad alloc] initWithWidth:0 height:currentHeight];
    qdBricks.x = currentX;
    qdBricks.y = currentY;
    qdBricks.color = RED_COLOR;
    [self addChild:qdBricks];
    lblBricks = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight text:@"bricks"];
    lblBricks.x = currentX;
    lblBricks.y = currentY;
    lblBricks.color = 0x000000;
    lblBricks.fontSize = currentHeight;
    lblBricks.hAlign = SPHAlignRight;
    lblBricks.fontName = EXETER_FONT;
    [self addChild:lblBricks];
    
    currentY += _height/3;
    qdGems = [[SPQuad alloc] initWithWidth:0 height:currentHeight];
    qdGems.x = currentX;
    qdGems.y = currentY;
    qdGems.color = BLUE_COLOR;
    [self addChild:qdGems];
    lblGems = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight text:@"gems"];
    lblGems.x = currentX;
    lblGems.y = currentY;
    lblGems.color = 0x000000;
    lblGems.fontSize = currentHeight;
    lblGems.hAlign = SPHAlignRight;
    lblGems.fontName = EXETER_FONT;
    [self addChild:lblGems];

    currentY += _height/3;
    qdRecruits = [[SPQuad alloc] initWithWidth:0 height:currentHeight];
    qdRecruits.x = currentX;
    qdRecruits.y = currentY;
    qdRecruits.color = GREEN_COLOR;
    [self addChild:qdRecruits];
    lblRecruits = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight text:@"recruits"];
    lblRecruits.x = currentX;
    lblRecruits.y = currentY;
    lblRecruits.color = 0x000000;
    lblRecruits.fontSize = currentHeight;
    lblRecruits.hAlign = SPHAlignRight;
    lblRecruits.fontName = EXETER_FONT;
    [self addChild:lblRecruits];
}

-(void) update:(OStats*)stats
{
    float baseWidth = _width - (_width*0.06);
    float ratio = 0;
    float width = 0;
    
    lblQuarries.text = [NSString stringWithFormat:@"%d", stats.quarries];
    lblBricks.text = [NSString stringWithFormat:@"%d bricks", stats.bricks];
    ratio = (float) stats.bricks / (float) _rule.winningResource;
    width = baseWidth * ratio;
    [self animateResourceBar:qdBricks width:width];
    
    lblMagics.text = [NSString stringWithFormat:@"%d", stats.magics];
    lblGems.text = [NSString stringWithFormat:@"%d gems", stats.gems];
    ratio = (float) stats.gems / (float) _rule.winningResource;
    width = baseWidth * ratio;
    [self animateResourceBar:qdGems width:width];
    
    lblDungeons.text = [NSString stringWithFormat:@"%d", stats.dungeons];
    lblRecruits.text = [NSString stringWithFormat:@"%d recruits", stats.recruits];
    ratio = (float) stats.recruits / (float) _rule.winningResource;
    width = baseWidth * ratio;
    [self animateResourceBar:qdRecruits width:width];
}

-(void) animateResourceBar:(SPQuad*)bar width:(float)width
{
	SPTween *tween = [SPTween tweenWithTarget:bar time:1.0];

	[tween animateProperty:@"width" targetValue:width];
    
    //	tween.loop = SPLoopTypeReverse;
    
	[Sparrow.juggler addObject:tween];
}

@end