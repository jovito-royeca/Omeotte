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
    BOOL _faceUp;
}

@synthesize card;
@synthesize lblName;
@synthesize qdCost;
@synthesize lblCost;
@synthesize imgArt;
@synthesize lblText;
@synthesize imgBackground;
@synthesize touchStatus;
@synthesize imgTower;
@synthesize qdBorder;
@synthesize qdBackground;
@synthesize imgLocked;
@synthesize lblDiscarded;
@synthesize delegate;
@synthesize cardStatus;

- (void)dealloc
{
//    [card release];
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
//    [delegate release];
    [_juggler release];
    [super dealloc];
}

-(id) initWithWidth:(float)width height:(float)height faceUp:(BOOL)faceUp
{
    if ((self = [super init]))
    {
        _width = width;
        _height = height;
        _juggler = [[SPJuggler alloc] init];
        _faceUp = faceUp;

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
    
    [SPTextField registerBitmapFontFromFile:CALLIGRAPHICA_FILE];
    [SPTextField registerBitmapFontFromFile:EXETER_FILE];
    
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
    lblText.vAlign = SPVAlignTop;
    [self addChild:lblText];

    [self addEventListener:@selector(onCardTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

-(void) setupBack
{
    // cleanup first
    [self removeAllChildren];
    
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
        touchStatus = 0;
        return;
    }

    SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] anyObject];
    
    if (touch && touch.phase == SPTouchPhaseEnded)
    {
        SPPoint *position = [touch locationInSpace:self];
        
        if (touchStatus == 0)
        {
            [delegate promote:self];
            touchStatus++;
        }
        else if (touchStatus >= 1)
        {
            if (position.y < self.height)
            {
                touchStatus++;
            }
            else if (position.y >= self.height)
            {
                touchStatus--;
            }
            else
            {
                touchStatus--;
            }
            
            switch (touchStatus)
            {
                case 2:
                {
                    [delegate play:self];
                    break;
                }
                case 0:
                {
                    [delegate discard:self];
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
    }
}

-(void) showFace:(BOOL)locked
{
    if (_faceUp)
    {
        [self removeEventListenersAtObject:self forType:SPEventTypeTriggered];
    }
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
    
    if (locked)
    {
        imgLocked = [[SPImage alloc] initWithWidth:_width height:_height/2];
        imgLocked.x = 0;
        imgLocked.y = 0;
        imgLocked.texture = [[SPTexture alloc] initWithContentsOfFile:@"chain and lock.png"];
        [self addChild:imgLocked];
//        [imgArt setAlpha:0.3];
    }
    else
    {
        [self removeChild:imgLocked];
//        [imgArt setAlpha:1.0];
    }

    [self flatten];
    
    _faceUp = YES;
}

-(void) showBack:(BOOL)opponent
{
    if (_faceUp)
    {
        [self removeEventListenersAtObject:self forType:SPEventTypeTriggered];
    }
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
    
    _faceUp = NO;
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

-(void) advanceTime:(double)seconds
{
    [_juggler advanceTime:seconds];
}

-(void) setupAnimation:(float)x
                     y:(float)y
                 width:(float)width
                height:(float)height
                  time:(float)time
{
    SPTween *tween = [SPTween tweenWithTarget:self time:time];
    [tween animateProperty:@"x" targetValue:x];
	[tween animateProperty:@"y" targetValue:y];
    [tween animateProperty:@"width" targetValue:width];
	[tween animateProperty:@"height" targetValue:height];
	[_juggler addObject:tween];
}

@end
