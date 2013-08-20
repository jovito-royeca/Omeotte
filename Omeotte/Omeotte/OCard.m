//
//  OCard.m
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import "OCard.h"

@implementation OCard

@synthesize name;
@synthesize image;
@synthesize text;
@synthesize cost;
@synthesize damage;
@synthesize bonus;
@synthesize drawCard;
@synthesize playAgain;

NSMutableArray *_cards;

+(NSArray*)allCards
{
    if (!_cards)
    {
        _cards = [[NSMutableArray alloc] init];
    }
    
    return _cards;
}

@end
