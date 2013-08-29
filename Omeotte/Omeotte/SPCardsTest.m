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
    
    cards = [[NSMutableArray alloc] initWithCapacity:6];
    
//    // Test Coords
//    SPImage *swiss = [[SPImage alloc] initWithContentsOfFile:@"swiss.gif"];
//    [swiss addEventListenerForType:SP_EVENT_TYPE_TOUCH block:^(SPTouchEvent *event)
//    {
//        SPTouch *touch = [[event.touches allObjects] objectAtIndex:0];
//        SPPoint *localTouchPosition = [touch locationInSpace:self];
//        swiss.x = localTouchPosition.x;
//        swiss.y = localTouchPosition.y;
//        
//         NSLog(@"x=%f, y=%f", swiss.x, swiss.y);
//    }];
//    [self addChild:swiss];
}

@end
