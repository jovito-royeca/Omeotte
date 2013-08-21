//
//  ODeck.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OCard.h"

#include "Omeotte.h"

@interface ODeck : NSObject

@property(readonly) NSMutableArray *cardsInLibrary;
@property(readonly) NSMutableArray *cardsInGraveyard;

-(void)shuffle;
-(OCard*)drawOnTop;
-(OCard*)drawRandom;
-(void)discard:(OCard*)card;

@end
