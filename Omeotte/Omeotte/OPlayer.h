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

@protocol OPlayerDelegate;

@interface OPlayer : NSObject

@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) OStats *base;
@property(strong,nonatomic) NSMutableArray *hand;
@property(strong,nonatomic) ODeck *deck;
@property(nonatomic) BOOL ai;

@property(nonatomic, assign) id<OPlayerDelegate> delegate;

-(BOOL) shouldDiscard:(int)maxHand;
-(BOOL) canPlayCard:(OCard*)card;
-(NSArray*) draw:(int)num;
-(void) upkeep;
-(OCard*) chooseCardToPlay;
-(OCard*) chooseCardToDiscard;
-(void) play:(OCard*)card onTarget:(OPlayer*)target;
-(void) discard:(OCard*)card;

@end

@protocol OPlayerDelegate<NSObject>
-(void) statChanged:(StatField)field
         fieldValue:(int)fieldValue
           modValue:(int)modValue
             player:(OPlayer*)player;

-(void) putCardToGraveyard:(OCard*)card discarded:(BOOL)discarded;
-(void) showHand;
@end