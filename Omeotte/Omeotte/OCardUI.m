//
//  OCardUI.m
//  Omeotte
//
//  Created by Jovito Royeca on 9/1/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OCardUI.h"

@implementation OCardUI
{
    float _width;
    float _height;
}

@synthesize card;
@synthesize lblName;
@synthesize lblCost;
@synthesize imgArt;
@synthesize lblText;

- (void)dealloc
{
    [super dealloc];
    
    [card release];
    [lblName release];
    [lblCost release];
    [imgArt release];
    [lblText release];
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
    lblName = [[SPTextField alloc] init];
    [self addChild:lblName];
    
    lblCost = [[SPTextField alloc] init];
    [self addChild:lblCost];
    
    imgArt = [[SPImage alloc] init];
    [self addChild:imgArt];
    
    lblText = [[SPTextField alloc] init];
    [self addChild:lblText];
    
    [self flatten];
}

@end
