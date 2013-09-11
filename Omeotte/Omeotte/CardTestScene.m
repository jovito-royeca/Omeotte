//
//  SPCardsTest.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/27/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "CardTestScene.h"

@implementation CardTestScene
{
    NSString *_deck;
}

@synthesize cards;

- (id)init
{
    if ((self = [super init]))
    {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];

    [cards release];
    [OMedia releaseAllAtlas];
    //    [SPMedia releaseSound];
    
    
}

- (void)setup
{
    _deck = @"deck.xml";
    
    [OMedia initAtlas:_deck];
    OCardUI *cardUI = [[OCardUI alloc] initWithWidth:98 height:125];
    
    [self addChild:cardUI];
    for (OCard *card in [OCard allCards])
    {
        NSLog(@"%@", [card name]);
        
        [cardUI setCard:card];
        [cardUI paintCard:YES];
    }
}

@end
