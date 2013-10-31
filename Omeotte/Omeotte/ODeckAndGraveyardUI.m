//
//  ODeckAndGraveyardUI.m
//  Omeotte
//
//  Created by Jovito Royeca on 10/31/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "ODeckAndGraveyardUI.h"

@implementation ODeckAndGraveyardUI
{
    float _width;
    float _height;
}

@synthesize topDeck;
@synthesize lblDeck;
@synthesize lblGraveyard;
@synthesize deckCards;
@synthesize graveyardCards;

- (void)dealloc
{
    [topDeck release];
    [lblDeck release];
    [lblGraveyard release];
    [super dealloc];
}

-(id) initWithWidth:(float)width
             height:(float)height
{
    if ((self = [super init]))
    {
        _width = width;
        _height = height;
        deckCards = [[NSMutableArray alloc] init];
        graveyardCards = [[NSMutableArray alloc] init];
        [self setup];
    }
    return self;
}

- (void) setup
{
    float width = Sparrow.stage.width;
//    float height = Sparrow.stage.height;
    float cardWidth  = width/6;
    float cardHeight = (cardWidth*128)/95;
    
    float currentX = 0;
    float currentY = 0;
    float currentWidth = cardWidth;
    float currentHeight = cardHeight;
    topDeck = [[OCardUI alloc] initWithWidth:currentWidth height:currentHeight faceUp:NO];
    topDeck.x = currentX;
    topDeck.y = currentY;
    [self addChild:topDeck];
    
    currentX = 0;
    currentY = _height-20;
    currentHeight = 20;
    lblDeck = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight text:@"Deck"];
    lblDeck.x = currentX;
    lblDeck.y = currentY;
    lblDeck.color = WHITE_COLOR;
    lblDeck.fontName = EXETER_FONT;
    [self addChild:lblDeck];
    
    currentX = (_width/2);
    currentY = _height-20;
    lblGraveyard = [[SPTextField alloc] initWithWidth:currentWidth height:currentHeight text:@"Graveyard"];
    lblGraveyard.x = currentX;
    lblGraveyard.y = currentY;
    lblGraveyard.color = WHITE_COLOR;
    lblGraveyard.fontName = EXETER_FONT;
    [self addChild:lblGraveyard];
}

-(void) addCardToGraveyard:(OCardUI*)card
{
    [graveyardCards addObject:card];
    
    // remove old cards in the graveyard to minimize memory usage
    if (graveyardCards.count >= 4)
    {
        OCardUI *cardUI = [graveyardCards objectAtIndex:0];
        
        [self.parent removeChild:cardUI];
        [graveyardCards removeObject:cardUI];
        [cardUI release];
    }
}

-(void) changePlayer:(OPlayer*)player
{
    [topDeck showBack:player.ai];
//    lblDeck.text = [NSString stringWithFormat:@"Deck %d", player.deck.cardsInLibrary.count];
//    lblGraveyard.text = [NSString stringWithFormat:@"Graveyard %d", player.deck.cardsInGraveyard.count];
}

@end
