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
}

@synthesize imgTower;
@synthesize lblTower;
@synthesize imgWall;
@synthesize lblWall;

- (void)dealloc
{
    [super dealloc];
    
    [lblTower release];
    [lblWall release];
}

-(id) initWithWidth:(float)width height:(float)height rule:(ORule*)rule ai:(BOOL)isAI
{
    if ((self = [super init]))
    {
        _width = width;
        _height = height;
        _rule = rule;
        _isAI = isAI;
        
        [self setup];
    }
    return self;
}

-(void) setup
{
    NSString *atlas = @"ui.xml";
    [OMedia initAtlas:atlas];
    
    float currentX = 0;
    float currentY = 0;
    float currentWidth = _width/2;
    float currentHeight = _height-20;
    
    if (_isAI)
    {
        currentWidth = (_width/2)*0.445;
        currentX = ((_width/2) - currentWidth)/2;
        imgWall = [[SXSimpleClippedImage alloc] initWithWidth:currentWidth height:currentHeight];
        imgWall.x = currentX;
        imgWall.y = currentY;
        imgWall.texture = [OMedia texture:@"wall" fromAtlas:atlas];
        [self addChild:imgWall];
        currentX = 0;
        currentWidth = _width/2;
        lblWall = [[SPTextField alloc] initWithWidth:currentWidth height:20];
        lblWall.color = 0xffffff;
        lblWall.x = currentX;
        lblWall.y = imgWall.height;
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
        lblTower = [[SPTextField alloc] initWithWidth:currentWidth height:20];
        lblTower.color = 0xffffff;
        lblTower.x = currentX;
        lblTower.y = imgTower.height;
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
        lblTower = [[SPTextField alloc] initWithWidth:currentWidth height:15];
        lblTower.color = 0xffffff;
        lblTower.x = currentX;
        lblTower.y = imgTower.height;
        [self addChild:lblTower];
        
        currentWidth = (_width/2)*0.445;
        currentX = _width/2 + (((_width/2) - currentWidth)/2);
        imgWall = [[SXSimpleClippedImage alloc] initWithWidth:currentWidth height:currentHeight];
        imgWall.x = currentX;
        imgWall.y = currentY;
        imgWall.texture = [OMedia texture:@"wall" fromAtlas:atlas];
        [self addChild:imgWall];
        currentX = _width/2;
        currentWidth = _width/2;
        lblWall = [[SPTextField alloc] initWithWidth:currentWidth height:15];
        lblWall.color = 0xffffff;
        lblWall.x = currentX;
        lblWall.y = imgTower.height;
        [self addChild:lblWall];
    }
    
    [self flatten];
}

-(void) update:(OStats*)stats
{
    [self unflatten];
    float towerHeight = _height-20;
    float newTowerHeight = (towerHeight * stats.tower)/_rule.winningTower;
    imgTower.y = towerHeight-newTowerHeight;
    [imgTower setClipX:0 Y:0 Width:imgTower.width Height:newTowerHeight];
//    [self animateImage:imgTower];
    lblTower.text = [NSString stringWithFormat:@"%d / %d", stats.tower, _rule.winningTower];
    
    float wallHeight = _height-20;
    float newWallHeight = (wallHeight/100) * stats.wall;
    if (newWallHeight > wallHeight)
    {
        newWallHeight = wallHeight;
    }
    imgWall.y = wallHeight-newWallHeight;
    [imgWall setClipX:0 Y:0 Width:imgWall.width Height:newWallHeight];
//    [self animateImage:imgWall];
    lblWall.text = [NSString stringWithFormat:@"%d", stats.wall];
    [self flatten];
}

-(void) animateImage:(SXSimpleClippedImage*)image
{
	SPTween *tween = [SPTween tweenWithTarget:image time:3.0];
    
	[tween animateProperty:@"x" targetValue:image.originalWidth/2];
	[tween animateProperty:@"y" targetValue:image.originalHeight/2];
    
	[tween animateProperty:@"clipX" targetValue:image.originalWidth/2];
	[tween animateProperty:@"clipY" targetValue:image.originalHeight/2];
    
	[tween animateProperty:@"clipWidth" targetValue:0];
	[tween animateProperty:@"clipHeight" targetValue:0];
    
//	tween.loop = SPLoopTypeReverse;
    
	[Sparrow.juggler addObject:tween];
}

@end
