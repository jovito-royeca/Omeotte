//
//  ORules.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/20/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ORule : NSObject

@property(strong, nonatomic) NSString *name;

@property int startingBricks;
@property int startingGems;
@property int startingRecruits;
    
@property int startingMines;
@property int startingMagics;
@property int startingDungeons;
    
@property int startingTower;
@property int startingWall;

@property int price;

@end
