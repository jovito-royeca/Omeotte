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
    int touchStatus;
    float _width;
    float _height;
}

@synthesize card;
@synthesize lblName;
@synthesize qdCost;
@synthesize lblCost;
@synthesize imgArt;
@synthesize lblText;
@synthesize imgBackground;
@synthesize delegate;

- (void)dealloc
{
    [super dealloc];
    
    [card release];
    [lblName release];
    [qdCost release];
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
    float currentX = 0;
    float currentY = 0;
    float currentWidth = 0;
    float currentHeight = 0;

    imgBackground = [[SPImage alloc] initWithWidth:_width height:_height];
    imgBackground.x = 0;
    imgBackground.y = 0;
    [self addChild:imgBackground];

    currentX = _width * 0.08;
    currentY = _width * 0.08;
    currentWidth = _width * 0.84;
    currentHeight = _width * 0.08;
    lblName = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    lblName.x = currentX;
    lblName.y = currentY;
    lblName.color = 0x000000;
    lblName.fontSize = currentX;
    lblName.hAlign = SPHAlignLeft;
    [self addChild:lblName];

    currentY = _width * 0.16;
    currentHeight = _height * 0.4416;
    imgArt = [[SPImage alloc] init];
    imgArt.x = currentX;
    imgArt.y = currentY;
    imgArt.width = currentWidth;
    imgArt.height = currentHeight;
    [self addChild:imgArt];

    currentWidth = _width * 0.2;
    currentHeight = _width * 0.08;
    currentX = (_width/2)-(currentWidth/2);
    currentY = _height * 0.56;
    qdCost = [[SPQuad alloc] initWithWidth:currentWidth height:currentHeight];
    qdCost.x = currentX;
    qdCost.y = currentY;
    [self addChild:qdCost];
    
    lblCost = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    lblCost.x = currentX;
    lblCost.y = currentY;
    lblCost.fontSize = currentHeight;
    lblCost.color = 0xffffff;
    [self addChild:lblCost];
    
    currentX = _width * 0.08;
    currentY = _width * 0.8746;
    currentWidth = _width * 0.84;
    currentHeight = _height * 0.275;
    lblText = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    lblText.x = currentX;
    lblText.y = currentY;
    lblText.color = 0x000000;
    lblText.fontSize = currentX;
    [self addChild:lblText];

    [self addEventListener:@selector(onCardTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

- (void)onCardTouched:(SPTouchEvent*)event
{
    SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] anyObject];
    
    if (touch && touch.phase == SPTouchPhaseEnded)
    {
        SPPoint *position = [touch locationInSpace:self];
        int arena = Sparrow.stage.height-_height;
        
        if (touchStatus == 0)
        {
            touchStatus++;
        }
        else if (touchStatus >= 1)
        {
            if (position.y < arena)
            {
                touchStatus++;
            }
            else if (position.y > arena)
            {
                touchStatus--;
            }
        }
        
        switch (touchStatus)
        {
            case 2:
            {
                [delegate play:card];
                break;
            }
            case 1:
            {
                [delegate promote:card];
                break;
            }
            case 0:
            {
                [delegate demote:card];
                break;
            }
            case -1:
            {
                [delegate discard:card];
                break;
            }
            default:
                break;
        }
        
        touchStatus = 0;
    }
}

-(void) paintCard:(BOOL) unlocked
{
    static NSString *ui = nil;
    static NSString *cards = nil;
    if (!ui)
    {
        ui = @"ui.xml";
        [OMedia initAtlas:ui];
    }
    if (!cards)
    {
        cards = @"cards.xml";
        [OMedia initAtlas:cards];
    }

    [self unflatten];

    lblName.text = card.name;

    SPTexture *art = [OMedia texture:[[card name] lowercaseString] fromAtlas:cards];
    imgArt.texture = art;

    lblText.text = card.text;

    NSString *szBackground = nil;
    switch (card.type)
    {
        case Quarry:
        {
            szBackground = @"brick card";
            lblCost.text = [NSString stringWithFormat:@"%d", card.cost.bricks];
            qdCost.color = RED_COLOR;
            break;
        }
        case Magic:
        {
            szBackground = @"gem card";
            lblCost.text = [NSString stringWithFormat:@"%d", card.cost.gems];
            qdCost.color = BLUE_COLOR;
            break;
        }
        case Dungeon:
        {
            szBackground = @"recruit card";
            lblCost.text = [NSString stringWithFormat:@"%d", card.cost.recruits];
            qdCost.color = GREEN_COLOR;
            break;
        }
        default:
        {
            lblCost.text = @"0";
        }
    }
    SPTexture *background = [OMedia texture:szBackground fromAtlas:ui];
    imgBackground.texture = background;
    
    self.alpha = unlocked ? 1.0 : 0.2;
    [self flatten];
}

@end
