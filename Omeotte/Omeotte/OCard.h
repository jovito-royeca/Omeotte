//
//  OCard.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OConstants.h"

typedef union
{
    int bricks;
    int gems;
    int recruits;
} Cost;

@interface OCard : NSObject

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *image;
@property(strong, nonatomic) NSString *text;
@property Cost cost;
@property Stats damage;
@property Stats bonus;
@property BOOL drawCard;
@property BOOL playAgain;

+(NSArray*)allCards;

@end
