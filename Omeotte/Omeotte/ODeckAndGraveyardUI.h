//
//  ODeckAndGraveyardUI.h
//  Omeotte
//
//  Created by Jovito Royeca on 10/31/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sparrow.h"

#import "OCardUI.h"
#import "OPlayer.h"

@interface ODeckAndGraveyardUI : SPSprite

@property(strong,nonatomic) OCardUI *topDeck;
@property(strong,nonatomic) SPTextField *lblDeck;
@property(strong,nonatomic) SPTextField *lblGraveyard;
@property(strong,nonatomic) NSMutableArray *deckCards;
@property(strong,nonatomic) NSMutableArray *graveyardCards;

-(id) initWithWidth:(float)width
             height:(float)height;

-(void) addCardToGraveyard:(OCardUI*)card;
-(void) changePlayer:(OPlayer*)player;

@end
