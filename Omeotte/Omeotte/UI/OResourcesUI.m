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
    SPJuggler *_juggler;
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
    [lblQuarries release];
    [lblBricks release];
    [qdBricks release];
    [lblMagics release];
    [lblGems release];
    [qdGems release];
    [lblDungeons release];
    [lblRecruits release];
    [qdRecruits release];
    [_juggler release];
    [super dealloc];
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
        _juggler = [[SPJuggler alloc] init];

        [self setup];
    }
    return self;
}

-(void) setup
{
    self.touchable = NO;

    NSString *atlas = @"ui.xml";
    [OMedia initAtlas:atlas];
    
    float currentX = 0;
    float currentY = 0;
    float currentWidth = 0;
    float currentHeight = 0;
    
    SPImage *imgBackground = [[SPImage alloc] initWithWidth:_width height:_height];
    SPTexture *texture = [OMedia texture:@"resources" fromAtlas:atlas];
    imgBackground.texture = texture;
    [self addChild:imgBackground];
    
//    resource factory legends
    currentX = _width * 0.03;
    currentY = 0;
    currentWidth = _width;
    currentHeight = _width * 0.192;
    SPTextField *lblQuarriesLegend = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight text:[OStats statName:Quarries]];
    lblQuarriesLegend.x = currentX;
    lblQuarriesLegend.y = currentY;
    lblQuarriesLegend.color = WHITE_COLOR;
    lblQuarriesLegend.fontSize = currentHeight;
    lblQuarriesLegend.fontName = EXETER_FONT;
    lblQuarriesLegend.hAlign = SPHAlignLeft;
    [self addChild:lblQuarriesLegend];
    
    currentY += _height/3;
    SPTextField *lblMagicsLegend = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight text:[OStats statName:Magics]];
    lblMagicsLegend.x = currentX;
    lblMagicsLegend.y = currentY;
    lblMagicsLegend.color = WHITE_COLOR;
    lblMagicsLegend.fontSize = currentHeight;
    lblMagicsLegend.fontName = EXETER_FONT;
    lblMagicsLegend.hAlign = SPHAlignLeft;
    [self addChild:lblMagicsLegend];
    
    currentY += _height/3;
    SPTextField *lblDungeonsLegend = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight text:[OStats statName:Dungeons]];
    lblDungeonsLegend.x = currentX;
    lblDungeonsLegend.y = currentY;
    lblDungeonsLegend.color = WHITE_COLOR;
    lblDungeonsLegend.fontSize = currentHeight;
    lblDungeonsLegend.fontName = EXETER_FONT;
    lblDungeonsLegend.hAlign = SPHAlignLeft;
    [self addChild:lblDungeonsLegend];
    
//    resource factory values
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
    
//    resource values
    currentY = _height * 0.259;
    currentWidth = _width - (_width*0.06);
    currentHeight = _width * 0.192;
    qdBricks = [[SPQuad alloc] initWithWidth:0 height:currentHeight];
    qdBricks.x = currentX;
    qdBricks.y = currentY;
    qdBricks.color = RED_COLOR;
    [self addChild:qdBricks];
    lblBricks = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight text:[OStats statName:Bricks]];
    lblBricks.x = currentX;
    lblBricks.y = currentY;
    lblBricks.color = BLACK_COLOR;
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
    lblGems = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight text:[OStats statName:Gems]];
    lblGems.x = currentX;
    lblGems.y = currentY;
    lblGems.color = BLACK_COLOR;
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
    lblRecruits = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight text:[OStats statName:Recruits]];
    lblRecruits.x = currentX;
    lblRecruits.y = currentY;
    lblRecruits.color = BLACK_COLOR;
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
    
    [self unflatten];
    
    lblQuarries.text = [NSString stringWithFormat:@"+%d", stats.quarries];
    lblBricks.text = [NSString stringWithFormat:@"%d %@", stats.bricks, [OStats statName:Bricks]];
    ratio = (float) stats.bricks / (float) _rule.winningResource;
    width = baseWidth * ratio;
    [self animateResourceBar:qdBricks width:width];
    
    lblMagics.text = [NSString stringWithFormat:@"+%d", stats.magics];
    lblGems.text = [NSString stringWithFormat:@"%d %@", stats.gems, [OStats statName:Gems]];
    ratio = (float) stats.gems / (float) _rule.winningResource;
    width = baseWidth * ratio;
    [self animateResourceBar:qdGems width:width];
    
    lblDungeons.text = [NSString stringWithFormat:@"+%d", stats.dungeons];
    lblRecruits.text = [NSString stringWithFormat:@"%d %@", stats.recruits, [OStats statName:Recruits]];
    ratio = (float) stats.recruits / (float) _rule.winningResource;
    width = baseWidth * ratio;
    [self animateResourceBar:qdRecruits width:width];

    [self flatten];
}

-(void) animateResourceBar:(SPQuad*)bar width:(float)width
{
	SPTween *tween = [SPTween tweenWithTarget:bar time:1.0];

	[tween animateProperty:@"width" targetValue:width];
	[_juggler addObject:tween];
}

-(void) advanceTime:(double)seconds
{
    [_juggler advanceTime:seconds];
}

@end