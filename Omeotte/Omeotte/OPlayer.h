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
#import "Stats.h"

@interface OPlayer : NSObject

@property(strong,nonatomic) Stats *base;
@property(strong,nonatomic) NSMutableArray *hand;
@property(strong,nonatomic) ODeck *deck;
@property(nonatomic) BOOL ai;

//-(void) drawInitialHand:(int)maxHand;
-(BOOL) shouldDiscard:(int)maxHand;
-(BOOL) canPlayCard:(OCard*)card;
-(NSArray*) draw:(int)num;
-(void) upkeep;
-(OCard*) chooseCardToPlay;
-(void) play:(OCard*)card onTarget:(OPlayer*)target;
-(void) discard:(OCard*)card;

@end
