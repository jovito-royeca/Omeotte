//
//  OCardUI.m
//  Omeotte
//
//  Created by Jovito Royeca on 9/1/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OCardUI.h"

@implementation OCardUI

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

- (id)init
{
    if ((self = [super init]))
    {
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
