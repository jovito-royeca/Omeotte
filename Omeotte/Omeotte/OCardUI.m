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
@synthesize imgBackground;
@synthesize delegate;

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
    float width = _width;
    float height = _height;
    int currentX = 0;
    int currentY = 0;
    float currentWidth = 0;
    float currentHeight = 0;

    imgBackground = [[SPImage alloc] initWithWidth:width height:height];
    imgBackground.x = 0;
    imgBackground.y = 0;
    [self addChild:imgBackground];

    currentX = width * 0.08;
    currentY = width * 0.08;
    currentWidth = width * 0.84;
    currentHeight = width * 0.08;
    lblName = [[SPTextField alloc] init];
    lblName.x = currentX;
    lblName.y = currentY;
    lblName.width = currentWidth;
    lblName.height = currentHeight;
    lblName.color = 0x000000;
    lblName.fontSize = currentX;
    lblName.hAlign = SPHAlignLeft;
    [self addChild:lblName];

    currentY = width * 0.16;
    currentHeight = height * 0.4416;
    imgArt = [[SPImage alloc] init];
    imgArt.x = currentX;
    imgArt.y = currentY;
    imgArt.width = currentWidth;
    imgArt.height = currentHeight;
    [self addChild:imgArt];

    currentY = width * 0.8746;
    currentHeight = height * 0.275;
    lblText = [[SPTextField alloc] init];
    lblText.x = currentX;
    lblText.y = currentY;
    lblText.width = currentWidth;
    lblText.height = currentHeight;
    lblText.color = 0x000000;
    lblText.fontSize = currentX;
    [self addChild:lblText];

    currentX = width * /*0.866; //*/0.8;
    currentY = height * /*0.904; //*/0.856;
    currentWidth = width * 0.133;
    currentHeight = width * 0.133;
    lblCost = [[SPTextField alloc] init];
    lblCost.x = currentX;
    lblCost.y = currentY;
    lblCost.width = currentWidth;
    lblCost.height = currentHeight;
    lblCost.color = 0xffffff;
    lblCost.fontSize = currentWidth;
    [self addChild:lblCost];
//    SHPolygon *circle = [[SHPolygon alloc] initWithRadius:currentWidth/2 numEdges:360];
//    circle.x = currentX;
//    circle.y= currentY;
//    [self addChild:circle];
    
    [self addEventListener:@selector(onCardTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

- (void)onCardTouched:(SPTouchEvent*)event
{
    SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] anyObject];
    
    if (touch && touch.phase == SPTouchPhaseEnded)
    {
        SPPoint *position = [touch locationInSpace:self];
        int arena = Sparrow.stage.height-_height;
        
        if (position.y < arena)
        {
            touchStatus++;
        }
        else if (position.y > arena)
        {
            touchStatus--;
        }
//        else if (position.y == arena)
//        {
//            
//        }
        
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
            lblCost.color = 0xff0000;
            break;
        }
        case Magic:
        {
            szBackground = @"gem card";
            lblCost.text = [NSString stringWithFormat:@"%d", card.cost.gems];
            lblCost.color = 0x0000ff;
            break;
        }
        case Dungeon:
        {
            szBackground = @"recruit card";
            lblCost.text = [NSString stringWithFormat:@"%d", card.cost.recruits];
            lblCost.color = 0x00ff00;
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
