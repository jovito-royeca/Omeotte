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

    [cards release];
    [OMedia releaseAllAtlas];
    //    [SPMedia releaseSound];
    
    
}

- (void)setup
{
    _deck = @"arcomage deck.xml";
    
    [OMedia initAtlas:_deck];
    SPImage *img = [[SPImage alloc] initWithWidth:95 height:128];
    
    [self addChild:img];
    for (OCard *card in [OCard allCards])
    {
        NSLog(@"%@", [card name]);
        
        SPTexture *texture = [OMedia texture:[card name] fromAtlas:_deck];
        img.texture = texture;
    }
}

@end
