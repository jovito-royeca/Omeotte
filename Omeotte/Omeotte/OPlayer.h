//
//  OPlayer.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OCard.h"
#import "ODeck.h"
#import "Omeotte.h"

@interface OPlayer : NSObject

@property Stats base;
@property(strong,nonatomic) NSMutableArray *cardsInHand;
@property(strong,nonatomic) ODeck *deck;

-(void) drawInitialHand:(int)maxHand;
-(BOOL) shouldDiscard:(int)maxHand;
-(BOOL) canPlayCard:(OCard*)card;
-(void) draw;
-(OCard*) chooseCardToPlay;
-(OCard*) chooseCardToDiscard;
-(void) play:(OCard*)card onTarget:(OPlayer*)target;
-(void) discard:(OCard*)card;

@end
