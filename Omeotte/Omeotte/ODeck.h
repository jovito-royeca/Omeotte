//
//  ODeck.h
//  Omeotte
//
//  Created by Jovito Royeca on 8/19/13.
//  Copyright (c) 2013 JJJ Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OCard.h"
#import "OConstants.h"

@interface ODeck : NSObject
{
    NSMutableArray *cardsInLibrary;
    NSMutableArray *cardsInGraveyard;
}

-(void)shuffle;
-(OCard*)draw;

@end
