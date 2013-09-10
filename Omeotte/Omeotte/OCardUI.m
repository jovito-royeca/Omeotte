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

-(void)setCard:(OCard *)card_
{
    if (card != card_)
    {
        [card release];
        card = [card_ retain];

        [self paintCard];
    }
}
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
    int width = _width-10;
    int height = _height-10;
    int currentX = 5;
    int currentY = 5;
    int currentWidth = 0;
    int currentHeight = 0;
    int fontSize = height / 10;

    frmBackground = [[SPQuad alloc] initWithWidth:width height:height];
    frmBackground.x = 0;
    frmBackground.y = 0;
    [self addChild:frmBackground];

    currentWidth = (width * 4) / 5;
    currentHeight = height / 10;
    lblName = [[SPTextField alloc] init];
    lblName.x = currentX;
    lblName.y = currentY;
    lblName.width = currentWidth;
    lblName.height = currentHeight;
    lblName.color = 0xffffff;
    lblName.fontSize = fontSize;
    lblName.hAlign = SPHAlignLeft;
    lblName.border = YES;
    [self addChild:lblName];

    currentX = lblName.width;
    currentWidth = width / 5;
    lblCost = [[SPTextField alloc] init];
    lblCost.x = currentX;
    lblCost.y = currentY;
    lblCost.width = currentWidth;
    lblCost.height = currentHeight;
    lblCost.color = 0xffffff;
    lblCost.fontSize = fontSize;
    lblCost.hAlign = SPHAlignRight;
    lblCost.border = YES;
    [self addChild:lblCost];

    currentX = 5;
    currentY = lblName.height+5;
    currentWidth = (width * 4) / 5;
    currentHeight = (height * 2) / 5;
    imgArt = [[SPImage alloc] init];
    imgArt.x = currentX;
    imgArt.y = currentY;
    imgArt.width = currentWidth;
    imgArt.height = currentHeight;
    [self addChild:imgArt];

    currentX = 5;
    currentY = imgArt.height+5;
    currentHeight = height / 2;
    lblText = [[SPTextField alloc] init];
    lblText.x = currentX;
    lblText.y = currentY;
    lblText.width = currentWidth;
    lblText.height = currentHeight;
    lblText.color = 0xffffff;
    lblText.fontSize = fontSize;
    lblText.border = YES;
    [self addChild:lblText];
}

-(void) paintCard
{
//    static NSString *deck = nil;
//    if (!deck)
//    {
//        deck = @"deck.xml";
//        [OMedia initAtlas:deck];
//    }

    [self unflatten];

    lblName.text = card.name;

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

//    if( [@"Some String" caseInsensitiveCompare:@"some string"] == NSOrderedSame )
//    {
//
//    }

//    SPTexture *texture = [OMedia texture:[card name] fromAtlas:deck];
//    imgArt.texture = texture;

    lblText.text = card.text;

    [self flatten];
}

@end
