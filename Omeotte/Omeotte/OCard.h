//
//  OCard.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import  <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

#include "Omeotte.h"

@interface OCard : NSObject

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *image;
@property int cost;
@property(strong, nonatomic) NSString *text;
@property(nonatomic) CardType type;
@property BOOL playAgain;
@property(strong,nonatomic) NSDictionary *statFields;
@property(strong,nonatomic) NSMutableArray *ops;

+(NSArray*)allCards;

@end
