//
//  SPCardsTest.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/27/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "SPCardsTest.h"

@implementation SPCardsTest
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

//    [_button removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [cards release];
    [SPMedia releaseAllAtlas];
    //    [SPMedia releaseSound];
    
    
}

- (void)setup
{
    _deck = @"arcomage deck.xml";
    
    [SPMedia initAtlas:_deck];
    SPImage *img = [[SPImage alloc] initWithWidth:95 height:128];
    
    [self addChild:img];
    for (OCard *card in [OCard allCards])
    {
        NSLog(@"%@", [card name]);
        
        SPTexture *texture = [SPMedia texture:[card name] fromAtlas:_deck];
        img.texture = texture;
    }
}

@end
