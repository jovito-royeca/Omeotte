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
    float currentWidth = 0;
    float currentHeight = 0;

    currentWidth  = _width/2;
    currentHeight = _height - 20;
    
    if (_isAI)
    {
        imgWall = [[SPImage alloc] initWithWidth:currentWidth height:currentHeight];
        imgWall.x = currentX;
        imgWall.y = currentY;
        imgWall.texture = [OMedia texture:@"wall" fromAtlas:atlas];
        [self addChild:imgWall];
        lblWall = [[SPTextField alloc] initWithWidth:currentWidth height:15];
        lblWall.color = 0xffffff;
        lblWall.x = currentX;
        lblWall.y = imgWall.height;
        [self addChild:lblWall];
        
        currentX = imgWall.width;
        imgTower = [[SPImage alloc] initWithWidth:currentWidth height:currentHeight];
        imgTower.x = currentX;
        imgTower.y = currentY;
        imgTower.texture = [OMedia texture:@"blue tower" fromAtlas:atlas];
        [self addChild:imgTower];
        lblTower = [[SPTextField alloc] initWithWidth:currentWidth height:15];
        lblTower.color = 0xffffff;
        lblTower.x = currentX;
        lblTower.y = imgTower.height;
        [self addChild:lblTower];
    }
    else
    {
        imgTower = [[SPImage alloc] initWithWidth:currentWidth height:currentHeight];
        imgTower.x = currentX;
        imgTower.y = currentY;
        imgTower.texture = [OMedia texture:@"red tower" fromAtlas:atlas];
        [self addChild:imgTower];
        lblTower = [[SPTextField alloc] initWithWidth:currentWidth height:15];
        lblTower.color = 0xffffff;
        lblTower.x = currentX;
        lblTower.y = imgTower.height;
        [self addChild:lblTower];
        
        currentX = imgTower.width;
        imgWall = [[SPImage alloc] initWithWidth:currentWidth height:currentHeight];
        imgWall.x = currentX;
        imgWall.y = currentY;
        imgWall.texture = [OMedia texture:@"wall" fromAtlas:atlas];
        [self addChild:imgWall];
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
    lblTower.text = [NSString stringWithFormat:@"%d / %d", stats.tower, _rule.winningTower];
    lblWall.text = [NSString stringWithFormat:@"%d", stats.wall];
    [self flatten];
}

@end
