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
    int _width;
    int _height;
}

@synthesize card;
@synthesize lblName;
@synthesize lblCost;
@synthesize imgArt;
@synthesize lblText;
@synthesize frmBackground;

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
    int width = _width;
    int height = _height;
    int currentX = 0;
    int currentY = 0;
    int currentWidth = 0;
    int currentHeight = 0;

    frmBackground = [[SPQuad alloc] initWithWidth:width height:height];
    frmBackground.x = 0;
    frmBackground.y = 0;
    [self addChild:frmBackground];

    currentWidth = width;
    currentHeight = height / 10;
    lblName = [[SPTextField alloc] init];
    lblName.x = currentX;
    lblName.y = currentY;
    lblName.width = currentWidth;
    lblName.height = currentHeight;
    lblName.color = 0x000000;
    lblName.fontSize = height / 12;
    lblName.hAlign = SPHAlignLeft;
    lblName.border = YES;
    [self addChild:lblName];

    currentX = 0;
    currentY = lblName.height;
    currentWidth = width;
    currentHeight = (height * 2) / 5;
    imgArt = [[SPImage alloc] init];
    imgArt.x = currentX;
    imgArt.y = currentY;
    imgArt.width = currentWidth;
    imgArt.height = currentHeight;
    [self addChild:imgArt];

    currentX = 0;
    currentY = lblName.height+imgArt.height;
    currentWidth = width;
    currentHeight = height - (lblName.height+imgArt.height);
    lblText = [[SPTextField alloc] init];
    lblText.x = currentX;
    lblText.y = currentY;
    lblText.width = currentWidth;
    lblText.height = currentHeight;
    lblText.color = 0x000000;
    lblText.fontSize = height/14;
    lblText.border = YES;
    [self addChild:lblText];
    
    currentX = (width * 4) /5;
    currentY = lblText.height-(height/10);
    currentWidth = width / 5;
    currentHeight = height / 10;
    lblCost = [[SPTextField alloc] init];
    lblCost.x = currentX;
    lblCost.y = currentY;
    lblCost.width = currentWidth;
    lblCost.height = currentHeight;
    lblCost.color = 0xffffff;
    lblCost.fontSize = height / 10;
    lblCost.border = YES;
    [lblText addChild:lblCost];
}

-(void) paintCard:(BOOL) unlocked
{
    static NSString *deck = nil;
    if (!deck)
    {
        deck = @"deck.xml";
        [OMedia initAtlas:deck];
    }

    [self unflatten];

    lblName.text = card.name;

    SPTexture *texture = [OMedia texture:[[card name] lowercaseString] fromAtlas:deck];
    imgArt.texture = texture;

    lblText.text = card.text;

    if (card.cost.bricks > 0)
    {
        lblCost.text = [NSString stringWithFormat:@"%d", card.cost.bricks];
        frmBackground.color = 0xff0000;
    }
    else if (card.cost.gems > 0)
    {
        lblCost.text = [NSString stringWithFormat:@"%d", card.cost.gems];
        frmBackground.color = 0x0000ff;
    }
    else if (card.cost.recruits > 0)
    {
        lblCost.text = [NSString stringWithFormat:@"%d", card.cost.recruits];
        frmBackground.color = 0x00ff00;
    }

    self.alpha = unlocked ? 1.0 : 0.2;
    [self flatten];
}

@end
