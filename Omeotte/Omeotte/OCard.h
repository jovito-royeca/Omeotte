//
//  OCard.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OConstants.h"

enum {
    OQuarry = 0,
    OMagic,
    ODungeon
};
typedef NSUInteger OCardType;

@interface OCard : NSObject

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *image;
@property int cost;
@property(strong, nonatomic) NSString *text;
@property(nonatomic) OCardType type;
@property BOOL playAgain;
@property Stats currentPlayer;
@property Stats opponent;

+(NSArray*)allCards;

@end
