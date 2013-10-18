//
//  OHealthUI.m
//  Omeotte
//
//  Created by Jovito Royeca on 10/1/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OHealthUI.h"

@implementation OHealthUI
{
    float _width;
    float _height;
    ORule *_rule;
    BOOL _isAI;
    SPJuggler *_juggler;
}

@synthesize imgTower;
@synthesize lblTower;
@synthesize imgWall;
@synthesize lblWall;

- (void)dealloc
{
    [super dealloc];
    
    [imgTower release];
    [lblTower release];
    [imgWall release];
    [lblWall release];
    [_juggler release];
}

-(id) initWithWidth:(float)width
             height:(float)height
               rule:(ORule*)rule
                 ai:(BOOL)isAI
{
    if ((self = [super init]))
    {
        _width = width;
        _height = height;
        _rule = rule;
        _isAI = isAI;
        _juggler = [[SPJuggler alloc] init];

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
    float currentWidth = _width/2;
    float currentHeight = _height-TOWER_LABEL_HEIGHT;
    
    if (_isAI)
    {
        currentWidth = (_width/2)*0.445;
        currentX = (_width/2) - currentWidth;
        imgWall = [[SXSimpleClippedImage alloc] initWithWidth:currentWidth height:currentHeight];
        imgWall.x = currentX;
        imgWall.y = currentY;
        imgWall.texture = [OMedia texture:@"wall" fromAtlas:atlas];
        [self addChild:imgWall];
        lblWall = [[SPTextField alloc] initWithWidth:currentWidth height:TOWER_LABEL_HEIGHT];
        lblWall.color = WHITE_COLOR;
        lblWall.x = currentX;
        lblWall.y = imgWall.height;
        lblWall.fontName = EXETER_FONT;
        [self addChild:lblWall];
        
        currentWidth = (_width/2)*0.542;
        currentX = _width/2 + (((_width/2) - currentWidth)/2);
        imgTower = [[SXSimpleClippedImage alloc] initWithWidth:currentWidth height:currentHeight];
        imgTower.x = currentX;
        imgTower.y = currentY;
        imgTower.texture = [OMedia texture:@"blue tower" fromAtlas:atlas];
        [self addChild:imgTower];
        currentX = _width/2;
        currentWidth = _width/2;
        lblTower = [[SPTextField alloc] initWithWidth:currentWidth height:TOWER_LABEL_HEIGHT];
        lblTower.color = WHITE_COLOR;
        lblTower.x = currentX;
        lblTower.y = imgTower.height;
        lblTower.fontName = EXETER_FONT;
        [self addChild:lblTower];
    }
    else
    {
        currentWidth = (_width/2)*0.542;
        currentX = ((_width/2) - currentWidth)/2;
        imgTower = [[SXSimpleClippedImage alloc] initWithWidth:currentWidth height:currentHeight];
        imgTower.x = currentX;
        imgTower.y = currentY;
        imgTower.texture = [OMedia texture:@"red tower" fromAtlas:atlas];
        [self addChild:imgTower];
        currentX = 0;
        currentWidth = _width/2;
        lblTower = [[SPTextField alloc] initWithWidth:currentWidth height:TOWER_LABEL_HEIGHT];
        lblTower.color = WHITE_COLOR;
        lblTower.x = currentX;
        lblTower.y = imgTower.height;
        lblTower.fontName = EXETER_FONT;
        [self addChild:lblTower];
        
        currentWidth = (_width/2)*0.445;
        currentX = _width/2;
        imgWall = [[SXSimpleClippedImage alloc] initWithWidth:currentWidth height:currentHeight];
        imgWall.x = currentX;
        imgWall.y = currentY;
        imgWall.texture = [OMedia texture:@"wall" fromAtlas:atlas];
        [self addChild:imgWall];
        currentX = _width/2;
        lblWall = [[SPTextField alloc] initWithWidth:currentWidth height:TOWER_LABEL_HEIGHT];
        lblWall.color = WHITE_COLOR;
        lblWall.x = currentX;
        lblWall.y = imgTower.height;
        lblWall.fontName = EXETER_FONT;
        [self addChild:lblWall];
    }
}

-(void) update:(OStats*)stats
{
    float totalTowerHeight   = _height-TOWER_LABEL_HEIGHT;
    float towerRoofHeight    = TOWER_ROOF_PIXELS*0.524;
    float stemTowerHeight    = totalTowerHeight - towerRoofHeight;
    float newTowerHeight     = stemTowerHeight * ((float)stats.tower/(float)_rule.winningTower);
    [self animateImage:imgTower
                     x:imgTower.x
                     y:totalTowerHeight-(towerRoofHeight+newTowerHeight)
                 clipX:0
                 clipY:0
             clipWidth:imgTower.width
            clipHeight:towerRoofHeight+newTowerHeight];
    lblTower.text = [NSString stringWithFormat:@"%d / %d", stats.tower, _rule.winningTower];

    float totalWallHeight   = _height-TOWER_LABEL_HEIGHT;
    float wallRoofHeight    = WALL_ROOF_PIXELS*0.639;
    float stemWallHeight    = totalWallHeight - wallRoofHeight;
    float newWallHeight     = (stemWallHeight/100) * stats.wall;
    if (newWallHeight > stemWallHeight)
    {
        newWallHeight = stemWallHeight;
    }
    [self animateImage:imgWall
                     x:imgWall.x
                     y:totalWallHeight-(wallRoofHeight+newWallHeight)
                 clipX:0
                 clipY:0
             clipWidth:imgWall.width
            clipHeight:wallRoofHeight+newWallHeight];
    lblWall.text = [NSString stringWithFormat:@"%d", stats.wall];
}

-(void) animateImage:(SXSimpleClippedImage*)image
                   x:(float)x
                   y:(float)y
               clipX:(float)clipX
               clipY:(float)clipY
           clipWidth:(float)clipWidth
          clipHeight:(float)clipHeight
{
	SPTween *tween = [SPTween tweenWithTarget:image time:2.0];
    
	[tween animateProperty:@"x" targetValue:x];
	[tween animateProperty:@"y" targetValue:y];
    
	[tween animateProperty:@"clipX" targetValue:clipX];
	[tween animateProperty:@"clipY" targetValue:clipY];
    
	[tween animateProperty:@"clipWidth" targetValue:clipWidth];
	[tween animateProperty:@"clipHeight" targetValue:clipHeight];
    
	[_juggler addObject:tween];
}

-(void) advanceTime:(double)seconds
{
    [_juggler advanceTime:seconds];
}

@end
