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
    SPJuggler *_juggler;
    float _startY;
    float _endY;
}

@synthesize card;
@synthesize lblName;
@synthesize qdCost;
@synthesize lblCost;
@synthesize imgArt;
@synthesize lblText;
@synthesize imgBackground;
@synthesize imgTower;
@synthesize qdBorder;
@synthesize qdBackground;
@synthesize imgLocked;
@synthesize lblDiscarded;
@synthesize delegate;
@synthesize selected;
@synthesize cardStatus;

- (void)dealloc
{
    [lblName release];
    [qdCost release];
    [lblCost release];
    [imgArt release];
    [lblText release];
    [imgBackground release];
    [imgTower release];
    [qdBorder release];
    [qdBackground release];
    [imgLocked release];
    [lblDiscarded release];
    [_juggler release];
    [super dealloc];
}

-(id) initWithWidth:(float)width height:(float)height faceUp:(BOOL)faceUp
{
    if ((self = [super init]))
    {
        _width = width;
        _height = height;

        if (faceUp)
        {
            [self setupFace];
        }
        else
        {
            [self setupBack];
        }
    }
    return self;
}

-(void) setupFace
{
    // cleanup first
    [self removeAllChildren];
    [self removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TOUCH];
    
    float currentX = 0;
    float currentY = 0;
    float currentWidth = 0;
    float currentHeight = 0;

    imgBackground = [[SPImage alloc] initWithWidth:_width height:_height];
    imgBackground.x = currentX;
    imgBackground.y = currentY;
    [self addChild:imgBackground];
    
    currentX = _width * 0.08;
    currentY = _width * 0.06;
    currentWidth = _width * 0.84;
    currentHeight = _width * 0.10;
    lblName = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    lblName.x = currentX;
    lblName.y = currentY;
    lblName.color = BLACK_COLOR;
    lblName.fontSize = currentHeight;
    lblName.hAlign = SPHAlignLeft;
    lblName.fontName = CALLIGRAPHICA_FONT;
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
    lblCost.fontName = EXETER_FONT;
    [self addChild:lblCost];
    
    currentX = _width * 0.08;
    currentY = _width * 0.8746;
    currentWidth = _width * 0.84;
    currentHeight = _height * 0.275;
    lblText = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight];
    lblText.x = currentX;
    lblText.y = currentY;
    lblText.color = BLACK_COLOR;
    lblText.fontSize = currentX;
    lblText.fontName = EXETER_FONT;
//    lblText.vAlign = SPVAlignTop;
    [self addChild:lblText];

    [self addEventListener:@selector(onCardTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

-(void) setupBack
{
    // cleanup first
    [self removeAllChildren];
    [self removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TOUCH];
    
    float currentWidth  = _width;
    float currentHeight = _height;
    float currentX      = 0;
    float currentY      = 0;
    
    qdBorder = [[SPQuad alloc] initWithWidth:currentWidth height:currentHeight];
    qdBorder.x = currentX;
    qdBorder.y = currentY;
    qdBorder.color = BLACK_COLOR;
    [self addChild:qdBorder];
    
    currentWidth = _width-10;
    currentHeight = _height-10;
    qdBackground = [[SPQuad alloc] initWithWidth:currentWidth height:currentHeight];
    qdBackground.x = 5;
    qdBackground.y = 5;
    qdBackground.color = WHITE_COLOR;
    [self addChild:qdBackground];
    
    currentWidth = (_width-10)*0.369;
    currentHeight = _height-10;
    currentX = (_width-currentWidth)/2;
    imgTower = [[SPImage alloc] initWithWidth:currentWidth height:currentHeight];
    imgTower.x = currentX;
    imgTower.y = 5;
    [self addChild:imgTower];
}

- (void)onCardTouched:(SPTouchEvent*)event
{
    if (cardStatus != InHand || !delegate)
    {
        return;
    }

//    SPTouch *endTouch;
//    
//    for (SPTouch *touch in [[event touchesWithTarget:self] allObjects])
//    {
//        if (touch.phase == SPTouchPhaseBegan)
//        {
//            _startY = [touch locationInSpace:self].y;
//        }
//        else if (touch.phase == SPTouchPhaseEnded)
//        {
//            endTouch = touch;
//            _endY = [touch locationInSpace:self].y;
//        }
//    }
//    
//    if (endTouch != nil)
//    {
//        float swipeLength = 30;
//        BOOL bDemote = NO;
//        
//        NSLog(@"%@: startY=%f, endY=%f", self.card.name, _startY, _endY);
//        if (_startY-_endY >= swipeLength)
//        {
//            [delegate play:self];
//        }
//        else if (_endY-_startY >= swipeLength)
//        {
//            [delegate discard:self];
//        }
//        else
//        {
//            selected = !selected;
//            
//            if (selected)
//            {
//                [delegate promote:self];
//            }
//            else
//            {
//                [delegate demote:self];
//            }
//        }
//    }

    SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] anyObject];
    if (touch && touch.phase == SPTouchPhaseEnded)
    {
        if (selected)
        {
            [delegate demote:self];
        }
        else
        {
            [delegate promote:self];
        }
        selected = !selected;
    }
}

-(void) showFace:(BOOL)locked
{
    [self setupFace];
    
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

    lblText.text = [card canonicalText];

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
    
    if (locked)
    {
        imgLocked = [[SPImage alloc] initWithWidth:_width height:_height/2];
        imgLocked.x = 0;
        imgLocked.y = 0;
        imgLocked.texture = [[SPTexture alloc] initWithContentsOfFile:@"chain and lock.png"];
        [self addChild:imgLocked];
    }
    else
    {
        [self removeChild:imgLocked];
    }

    [self flatten];
}

-(void) showBack:(BOOL)opponent
{
    [self setupBack];
    
    [self unflatten];
    
    static NSString *ui = nil;
    if (!ui)
    {
        ui = @"ui.xml";
        [OMedia initAtlas:ui];
    }
    
    NSString *szTower = opponent ? @"blue tower" : @"red tower";
    SPTexture *tower = [OMedia texture:szTower fromAtlas:ui];
    imgTower.texture = tower;

    [self flatten];
}

-(void) showDiscarded
{
    [self unflatten];
    lblDiscarded = [[SPTextField alloc] initWithWidth:_width height:20 text:@"DISCARDED"];
    lblDiscarded.x = 0;
    lblDiscarded.y = _width * 0.16;
    lblDiscarded.color = WHITE_COLOR;
    lblDiscarded.fontName = CALLIGRAPHICA_FONT;
    lblDiscarded.fontSize = 20;
    [self addChild:lblDiscarded];
    [self flatten];
}

@end
