//
//  OCard.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import  <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

#import "Stats.h"

enum
{
    Quarry = 0,
    Magic,
    Dungeon,
    Mixed
};
typedef int CardType;

@interface OCard : NSObject

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) Stats *cost;
@property(strong, nonatomic) NSString *text;
@property(nonatomic) BOOL playAgain;
@property(nonatomic) CardType type;
@property(strong,nonatomic) NSArray *effects;
@property(nonatomic) Eval eval;

+(NSArray*)allCards;

@end
