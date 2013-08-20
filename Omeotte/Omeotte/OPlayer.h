//
//  OPlayer.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OCard.h"
#import "OConstants.h"
#import "ODeck.h"

@interface OPlayer : NSObject

@property int bricks;
@property int gems;
@property int recruits;

@property int mines;
@property int magics;
@property int dungeons;

@property int tower;
@property int wall;

@property(strong,nonatomic) NSMutableArray *cardsInHand;
@property(strong,nonatomic) ODeck *deck;

-(BOOL) canPlayCard:(OCard*)card;
-(BOOL) canDrawCard;
-(void) play:(OCard*)card onTarget:(OPlayer*)target;

@end
