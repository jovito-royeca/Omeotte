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
#import "OStats.h"

@protocol OPlayerAnimationDelegate;

@interface OPlayer : NSObject

@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) OStats *base;
@property(strong,nonatomic) NSMutableArray *hand;
@property(strong,nonatomic) ODeck *deck;
@property(nonatomic) BOOL ai;

@property(nonatomic, assign) id<OPlayerAnimationDelegate> delegate;

-(BOOL) shouldDiscard:(int)maxHand;
-(BOOL) canPlayCard:(OCard*)card;
-(NSArray*) draw:(int)num;
-(void) upkeep;
-(OCard*) chooseCardToPlay;
-(OCard*) chooseCardToDiscard;
-(void) play:(OCard*)card onTarget:(OPlayer*)target;
-(void) discard:(OCard*)card;

@end

@protocol OPlayerAnimationDelegate<NSObject>
-(void) animateStatChanged:(StatField)field
         fieldValue:(int)fieldValue
           modValue:(int)modValue
             player:(OPlayer*)player;

-(void) animateDrawCard:(OCard*)card;
-(void) animateShowHand;
-(void) animatePutCardToGraveyard:(OCard*)card discarded:(BOOL)discarded;
@end