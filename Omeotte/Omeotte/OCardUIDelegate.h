//
//  OCardUIDelegate.h
//  Deck of Omeotte
//
//  Created by Jovito Royeca on 9/11/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OCard.h"

@protocol OCardUIDelegate <NSObject>

- (void)promote:(OCard*)card;
- (void)play:(OCard*)card;
- (void)discard:(OCard*)card;
- (void)demote:(OCard*)card;

@end
