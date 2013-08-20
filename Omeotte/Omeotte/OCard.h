//
//  OCard.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef union
{
    int bricks;
    int gems;
    int recruits;
} Cost;

typedef struct
{
    int bricks;
    int gems;
    int recruits;
    
    int mines;
    int magics;
    int dungeons;
    
    int tower;
    int wall;

} Damage;

typedef struct
{
    int bricks;
    int gems;
    int recruits;
    
    int mines;
    int magics;
    int dungeons;
    
    int tower;
    int wall;
    
    BOOL drawCard;
    BOOL turnAgain;
    
} Bonus;

@interface OCard : NSObject

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *image;
@property(strong, nonatomic) NSString *text;
@property Cost cost;
@property Damage damage;
@property Bonus bonus;

@end
