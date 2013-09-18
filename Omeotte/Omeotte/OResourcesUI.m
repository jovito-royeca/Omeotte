//
// Created by Jovito Royeca on 9/9/13.
// Copyright (c) 2013 JJJ Software. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "OResourcesUI.h"


@implementation OResourcesUI
{
    int _width;
    int _height;
}

@synthesize lblQuarries;
@synthesize lblBricks;
@synthesize lblMagic;
@synthesize lblGems;
@synthesize lblDungeons;
@synthesize lblRecruits;

- (void)dealloc
{
    [super dealloc];
    
    [lblQuarries release];
    [lblBricks release];
    [lblMagic release];
    [lblGems release];
    [lblDungeons release];
    [lblRecruits release];
}

-(id) initWithWidth:(float)width height:(float)height
{
    if ((self = [super init]))
    {
        _width = width;
        _height = height;
        [self setup];
    }
    return self;
}

-(void) setup
{
    [OMedia initAtlas:@"ui.xml"];
    
    float width = _width;
    float height = _height;
//    int currentX = 0;
//    int currentY = 0;
//    float currentWidth = 0;
//    float currentHeight = 0;
    
    SPImage *imgBackground = [[SPImage alloc] initWithWidth:width height:height];
    SPTexture *texture = [OMedia texture:@"resources" fromAtlas:@"ui.xml"];
    imgBackground.texture = texture;
    
    [self addChild:imgBackground];
}

-(void) update:(OStats*)stats
{
    
}

@end