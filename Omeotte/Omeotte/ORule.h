//
//  ORules.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/20/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "Omeotte.h"

@interface ORule : NSObject

@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *location;
@property(nonatomic) OStats base;
@property int cardsInHand;
@property int winningTower;
@property int winningResource;
@property int price;

+(NSArray*)allRules;

@end
